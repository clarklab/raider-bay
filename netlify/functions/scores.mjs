import { getStore } from "@netlify/blobs";

const STORE_NAME = "raider-bay-high-scores";
const SCORES_KEY = "scores.json";
const MAX_SCORES = 50;
const MAX_BODY_BYTES = 8192;

const jsonHeaders = {
  "Content-Type": "application/json; charset=utf-8",
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type",
  "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
  "Cache-Control": "no-store",
};

export default async function handler(request) {
  if (request.method === "OPTIONS") {
    return new Response("", { status: 204, headers: jsonHeaders });
  }

  try {
    if (request.method === "GET") {
      const scores = await readScores();
      return json(200, { scores, max: MAX_SCORES });
    }

    if (request.method === "POST") {
      const bodyLength = Number(request.headers.get("content-length") || 0);
      if (bodyLength > MAX_BODY_BYTES) {
        return json(413, { error: "Score payload too large." });
      }

      const entry = sanitizeScore(JSON.parse(await request.text() || "{}"));
      if (!entry) {
        return json(400, { error: "Invalid Raider Bay score." });
      }

      const scores = await readScores();
      const existing = scores.findIndex((score) => score.id === entry.id);
      if (existing >= 0) {
        scores.splice(existing, 1);
      }
      scores.push(entry);
      sortScores(scores);
      const rank = scores.findIndex((score) => score.id === entry.id) + 1;
      const trimmed = scores.slice(0, MAX_SCORES);
      await writeScores(trimmed);
      return json(200, { rank, scores: trimmed, max: MAX_SCORES });
    }

    return json(405, { error: "Method not allowed." });
  } catch (error) {
    console.error(error);
    return json(500, { error: "Scoreboard unavailable." });
  }
}

async function readScores() {
  const store = getStore(STORE_NAME);
  const scores = await store.get(SCORES_KEY, { type: "json", consistency: "strong" });
  if (!Array.isArray(scores)) {
    return [];
  }
  const clean = scores.map(sanitizeScore).filter(Boolean);
  sortScores(clean);
  return clean.slice(0, MAX_SCORES);
}

async function writeScores(scores) {
  const store = getStore(STORE_NAME);
  await store.setJSON(SCORES_KEY, scores);
}

function sanitizeScore(raw) {
  if (!raw || typeof raw !== "object") {
    return null;
  }

  const entry = {
    schema: 1,
    id: safeText(raw.id, 80) || `${Date.now()}-${Math.random().toString(36).slice(2)}`,
    money: clampInt(raw.money, 0, 9999999),
    trophies: clampInt(raw.trophies, 0, 5),
    day: clampInt(raw.day, 1, 999),
    season_days: clampInt(raw.season_days, 1, 999),
    extra_nights: clampInt(raw.extra_nights, 0, 999),
    fish_sold: clampInt(raw.fish_sold, 0, 99999),
    fish_caught: clampInt(raw.fish_caught ?? raw.fish_sold, 0, 99999),
    upgrade_total: clampInt(raw.upgrade_total, 0, 999),
    elapsed_seconds: clampInt(raw.elapsed_seconds, 0, 9999999),
    move_actions: clampInt(raw.move_actions, 0, 99999),
    casts_made: clampInt(raw.casts_made, 0, 99999),
    treasures_found: clampInt(raw.treasures_found, 0, 9999),
    mode: safeEnum(raw.mode, ["solo", "versus"], "solo"),
    outcome: safeText(raw.outcome, 32) || "SEASON OVER",
    captain: safeText(raw.captain, 40),
    boat_name: safeText(raw.boat_name, 40),
    boat: clampInt(raw.boat, 0, 15),
    timestamp: clampInt(raw.timestamp || Math.floor(Date.now() / 1000), 0, 9999999999),
  };

  if (entry.season_days < entry.day) {
    entry.season_days = entry.day;
  }
  return entry;
}

function sortScores(scores) {
  scores.sort((a, b) => (
    b.trophies - a.trophies ||
    b.money - a.money ||
    b.upgrade_total - a.upgrade_total ||
    b.fish_caught - a.fish_caught ||
    a.day - b.day ||
    a.elapsed_seconds - b.elapsed_seconds ||
    b.timestamp - a.timestamp
  ));
}

function clampInt(value, min, max) {
  const parsed = Number.parseInt(value, 10);
  if (!Number.isFinite(parsed)) {
    return min;
  }
  return Math.max(min, Math.min(max, parsed));
}

function safeEnum(value, allowed, fallback) {
  const text = String(value || "");
  return allowed.includes(text) ? text : fallback;
}

function safeText(value, maxLength) {
  return String(value || "")
    .replace(/[^\w .:!#-]/g, "")
    .trim()
    .slice(0, maxLength);
}

function json(statusCode, body) {
  return new Response(JSON.stringify(body), {
    status: statusCode,
    headers: jsonHeaders,
  });
}
