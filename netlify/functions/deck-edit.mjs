import { createHash, timingSafeEqual } from "node:crypto";

// Commits /deck editor changes (card art replacements + manifest text edits)
// straight to the repo. The push to main triggers the normal site deploy.
//
// Required Netlify env vars — without them every request gets a 503:
//   GITHUB_TOKEN   fine-grained PAT, this repo only, Contents: read & write
//   DECK_EDIT_KEY  shared secret the page sends as X-Deck-Key

const OWNER = "clarklab";
const REPO = "raider-bay";
const BRANCH = "main";
const MANIFEST_PATH = "site/deck/manifest.json";
const API = "https://api.github.com";

const MAX_IMAGE_BYTES = 4_400_000; // ×4/3 base64 ≈ 5.9 MB, under the 6 MB function payload cap
const MAX_BODY_BYTES = 6_000_000;
const MAX_LABEL = 60;
const MAX_DESC = 300;
const PNG_MAGIC = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];

const jsonHeaders = {
  "Content-Type": "application/json; charset=utf-8",
  "Cache-Control": "no-store",
};

export default async function handler(request) {
  if (request.method !== "POST") {
    return json(405, { error: "POST only." });
  }

  const token = process.env.GITHUB_TOKEN;
  const editKey = process.env.DECK_EDIT_KEY;
  if (!token || !editKey) {
    return json(503, { error: "Editor not configured: set GITHUB_TOKEN and DECK_EDIT_KEY in the Netlify environment." });
  }

  if (!keysMatch(request.headers.get("x-deck-key") || "", editKey)) {
    return json(401, { error: "Bad edit key." });
  }

  const origin = request.headers.get("origin");
  if (origin && !/(\.|\/\/)(raiderbay\.superfun\.games|[a-z0-9-]+\.netlify\.app)$/.test(origin)) {
    return json(403, { error: "Bad origin." });
  }

  if (Number(request.headers.get("content-length") || 0) > MAX_BODY_BYTES) {
    return json(413, { error: "Payload too large." });
  }

  let body;
  try {
    body = JSON.parse(await request.text());
  } catch {
    return json(400, { error: "Invalid JSON." });
  }

  const edit = sanitizeEdit(body);
  if (edit.error) {
    return json(400, { error: edit.error });
  }

  try {
    // One retry if the branch moves under us mid-commit.
    for (let attempt = 0; ; attempt++) {
      const result = await commitEdit(token, edit);
      if (result.ok || attempt >= 1 || !result.retryable) {
        return json(result.ok ? 200 : result.status || 500, result.body);
      }
    }
  } catch (error) {
    console.error(error);
    return json(500, { error: "GitHub commit failed." });
  }
}

function sanitizeEdit(raw) {
  if (!raw || typeof raw !== "object") return { error: "Invalid body." };

  const dir = raw.dir === "cards" || raw.dir === "boosters" ? raw.dir : null;
  if (!dir) return { error: "Bad dir." };

  const file = String(raw.file || "");
  const prefix = dir === "cards" ? "card-" : "booster-";
  if (!/^[a-z0-9-]{3,64}\.png$/.test(file) || !file.startsWith(prefix)) {
    return { error: "Bad file name." };
  }

  const edit = { dir, file, path: `assets/${dir}/${file}` };

  if (typeof raw.label === "string") {
    edit.label = cleanText(raw.label, MAX_LABEL);
    if (!edit.label) return { error: "Label is empty." };
  }
  if (typeof raw.desc === "string" && dir === "boosters") {
    edit.desc = cleanText(raw.desc, MAX_DESC);
  }

  if (typeof raw.imageBase64 === "string" && raw.imageBase64.length > 0) {
    if (!/^[A-Za-z0-9+/=]+$/.test(raw.imageBase64)) return { error: "Bad image encoding." };
    let bytes;
    try {
      bytes = Buffer.from(raw.imageBase64, "base64");
    } catch {
      return { error: "Bad image encoding." };
    }
    if (bytes.length < 100 || bytes.length > MAX_IMAGE_BYTES) {
      return { error: `Image must be under ${(MAX_IMAGE_BYTES / 1e6).toFixed(1)} MB.` };
    }
    if (!PNG_MAGIC.every((b, i) => bytes[i] === b)) {
      return { error: "Not a PNG file." };
    }
    edit.imageBase64 = raw.imageBase64;
    edit.imageBytes = bytes.length;
  }

  if (!edit.imageBase64 && edit.label === undefined && edit.desc === undefined) {
    return { error: "Nothing to change." };
  }
  return edit;
}

async function commitEdit(token, edit) {
  const ref = await gh(token, `GET /repos/${OWNER}/${REPO}/git/ref/heads/${BRANCH}`);
  const baseCommit = ref.object.sha;
  const commit = await gh(token, `GET /repos/${OWNER}/${REPO}/git/commits/${baseCommit}`);

  // Manifest is the card registry: edits may only touch cards already in it.
  const manifestText = await ghRaw(token, `/repos/${OWNER}/${REPO}/contents/${MANIFEST_PATH}?ref=${baseCommit}`);
  const manifest = JSON.parse(manifestText);
  const entry = findCard(manifest, edit.dir, edit.file);
  if (!entry) {
    return { ok: false, status: 404, body: { error: `${edit.file} is not in the deck manifest.` } };
  }

  const changes = [];
  if (edit.label !== undefined && edit.label !== entry.label) { entry.label = edit.label; changes.push("label"); }
  if (edit.desc !== undefined && edit.desc !== entry.desc) { entry.desc = edit.desc; changes.push("text"); }
  if (edit.imageBase64) { entry.v = (Number(entry.v) || 0) + 1; changes.push("art"); }
  if (!changes.length) {
    return { ok: false, status: 400, body: { error: "No changes — matches what's already committed." } };
  }

  const tree = [];
  if (edit.imageBase64) {
    const blob = await gh(token, `POST /repos/${OWNER}/${REPO}/git/blobs`, {
      content: edit.imageBase64,
      encoding: "base64",
    });
    tree.push({ path: edit.path, mode: "100644", type: "blob", sha: blob.sha });
  }
  tree.push({
    path: MANIFEST_PATH,
    mode: "100644",
    type: "blob",
    sha: (await gh(token, `POST /repos/${OWNER}/${REPO}/git/blobs`, {
      content: JSON.stringify(manifest, null, 2) + "\n",
      encoding: "utf-8",
    })).sha,
  });

  const newTree = await gh(token, `POST /repos/${OWNER}/${REPO}/git/trees`, {
    base_tree: commit.tree.sha,
    tree,
  });
  const newCommit = await gh(token, `POST /repos/${OWNER}/${REPO}/git/commits`, {
    message: `deck: ${changes.join(" + ")} for ${edit.file} via /deck editor`,
    tree: newTree.sha,
    parents: [baseCommit],
  });

  try {
    await gh(token, `PATCH /repos/${OWNER}/${REPO}/git/refs/heads/${BRANCH}`, { sha: newCommit.sha });
  } catch (error) {
    if (String(error.message).includes("422")) {
      return { ok: false, retryable: true, status: 409, body: { error: "Branch moved, retrying…" } };
    }
    throw error;
  }

  // Ship it: tag this commit with the next version so it actually reaches
  // players. build-android.yml's release job runs on v* tags — it builds the
  // APK and publishes a release, which is what the evergreen download link and
  // the in-game GET UPDATE chip both read (both key off releases/latest, and
  // the chip fires because tag_name bumped). Best-effort: the art is already
  // committed and web-deployed even if tagging hiccups, so never fail the edit.
  const release = await tagRelease(token, newCommit.sha);

  return {
    ok: true,
    body: {
      ok: true,
      sha: newCommit.sha.slice(0, 7),
      changed: changes,
      manifest,
      version: release.tag,
      tagError: release.error,
      actionsUrl: `https://github.com/${OWNER}/${REPO}/actions`,
    },
  };
}

// Tags `sha` with the next patch version (vX.Y.Z) to cut a release build.
// Returns { tag } on success or { error } if it couldn't tag. A concurrent
// edit can grab the same number (422 on ref create) — recompute and retry.
async function tagRelease(token, sha) {
  for (let attempt = 0; attempt < 3; attempt++) {
    try {
      const tag = await nextVersionTag(token);
      await gh(token, `POST /repos/${OWNER}/${REPO}/git/refs`, { ref: `refs/tags/${tag}`, sha });
      return { tag };
    } catch (error) {
      if (String(error.message).includes("422") && attempt < 2) continue; // tag exists, race — bump again
      console.error("tagRelease failed:", error);
      return { error: "Committed, but couldn't cut a release tag — trigger a build manually." };
    }
  }
  return { error: "Committed, but couldn't cut a release tag — trigger a build manually." };
}

// Highest existing vMAJOR.MINOR.PATCH tag with its patch bumped by one.
async function nextVersionTag(token) {
  const refs = await gh(token, `GET /repos/${OWNER}/${REPO}/git/matching-refs/tags/v`);
  let best = null;
  for (const r of Array.isArray(refs) ? refs : []) {
    const m = /^refs\/tags\/v(\d+)\.(\d+)\.(\d+)$/.exec(r.ref || "");
    if (!m) continue;
    const v = [Number(m[1]), Number(m[2]), Number(m[3])];
    if (!best || cmpVer(v, best) > 0) best = v;
  }
  const next = best ? [best[0], best[1], best[2] + 1] : [1, 0, 0];
  return `v${next[0]}.${next[1]}.${next[2]}`;
}

function cmpVer(a, b) {
  return (a[0] - b[0]) || (a[1] - b[1]) || (a[2] - b[2]);
}

function findCard(manifest, dir, file) {
  for (const section of manifest.sections || []) {
    if (section.dir !== dir) continue;
    for (const card of section.cards || []) {
      if (card.f === file) return card;
    }
  }
  return null;
}

async function gh(token, route, payload) {
  const [method, path] = route.split(" ");
  const response = await fetch(API + path, {
    method,
    headers: ghHeaders(token),
    body: payload ? JSON.stringify(payload) : undefined,
  });
  if (!response.ok) {
    throw new Error(`GitHub ${method} ${path} -> ${response.status}: ${(await response.text()).slice(0, 300)}`);
  }
  return response.json();
}

async function ghRaw(token, path) {
  const response = await fetch(API + path, {
    headers: { ...ghHeaders(token), Accept: "application/vnd.github.raw+json" },
  });
  if (!response.ok) {
    throw new Error(`GitHub GET ${path} -> ${response.status}`);
  }
  return response.text();
}

function ghHeaders(token) {
  return {
    Authorization: `Bearer ${token}`,
    Accept: "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    "User-Agent": "raider-bay-deck-editor",
    "Content-Type": "application/json",
  };
}

function keysMatch(given, expected) {
  const a = createHash("sha256").update(given).digest();
  const b = createHash("sha256").update(expected).digest();
  return timingSafeEqual(a, b);
}

function cleanText(value, maxLength) {
  return String(value)
    .replace(/[\u0000-\u001f\u007f]/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, maxLength);
}

function json(statusCode, body) {
  return new Response(JSON.stringify(body), { status: statusCode, headers: jsonHeaders });
}
