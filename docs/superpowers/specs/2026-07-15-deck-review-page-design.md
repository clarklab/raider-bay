# /deck — card art review page

**Goal:** one page showing every card image dressed exactly like an in-game card
(squarestep shell: dark outline, chunky white border, stepped pixel corners,
halftone shadow) so card art can be reviewed and art-directed in one place.

## Where it lives

- `site/deck/index.html` → deployed at `https://raiderbay.superfun.games/deck/`
  (the deploy workflow copies `site/.` into `public/`).
- The deploy workflow additionally copies `assets/cards/*.png` and
  `assets/boosters/*.png` into `public/assets/cards|boosters/`.
- Image srcs are relative `../../assets/cards/<file>.png`:
  - Prod: `/deck/../../…` clamps to `/assets/cards/…` (the deploy copies).
  - Local: serve the repo root (`python3 -m http.server 8788`) and open
    `http://127.0.0.1:8788/site/deck/` — the same relative path resolves to the
    real `assets/cards/` source files. No copy step locally.

## Weight

Card sources are 1880×2514 PNG, ~125 MB total — too heavy for a 45-image grid.
On the prod/netlify hosts the grid loads thumbnails through the Netlify Image
CDN (`/.netlify/images?url=…&w=560&fm=webp`); every `<img>` falls back to the
raw file on error, and localhost skips the CDN entirely. The lightbox always
loads the raw full-res PNG.

## Card dressing (faithful port of `main.gd`)

From `_card_shell_metrics` / `_add_squarestep_card_shell` / `_draw_stepped_slab`
/ `_gallery_face` / `_add_halftone_card_shadow`:

- Metrics from rendered card width `w` (shorter side): `b = max(3, round(w*0.055))`
  white border; `o = max(1, round(b*0.35))` dark outline; `s = max(2, round(b*0.37))`
  corner step; art inset `t = o + b`. Outer silhouettes step over 3 chunks,
  the fill/art over 2.
- Layers: `#0a0e14` outline slab → white slab at inset `o` → `#011244` fill slab
  at inset `t` → art at inset `t`, corners notched to match.
- Implemented as JS-computed integer CSS vars (`--s/--o/--t`, recomputed on
  resize/density change) driving `clip-path: polygon(…)` layers.
- Halftone shadow: 7px staggered lattice of 3px squares, `#00152d` @ 0.4,
  offset ≈ (4.3%, 5%) of card width — an inline SVG tile.
- Deck cards: outer aspect 1880/2514, art stretched to the inner rect
  (`object-fit: fill`, what the game's `STRETCH_SCALE` does). Boosters: outer
  aspect 300/420 with `object-fit: cover` (`STRETCH_KEEP_ASPECT_COVERED`).

## Content & review affordances

- Sections: Fish (5) · Treasure & Night (3) · Weather (4) · Motor / Fish Finder /
  Nets / Live Well (5 each, level order) · Card Back · Boosters (12, with
  in-game title, effect text and accent from `BOOSTER_CARDS`).
- Manifest is embedded in the page (the deck is a fixed set preloaded in
  `main.gd`; new art means touching both).
- Captions show the filename (the handle for art-direction notes).
- Density toggle S/M/L (persisted), card click → lightbox: full-res dressed
  card, filename copy button, expected-vs-actual pixel dims (flags wrong-res
  art), booster title/effect, open-raw-PNG link, ←/→ prev/next, Esc closes.
- Look matches the site: Balatro font, navy palette, gold headings, subtle
  dealt-in stagger (disabled under `prefers-reduced-motion`).

## Editing (added same day)

The page has an EDIT mode that commits changes back to the repo:

- Card data lives in `site/deck/manifest.json` (labels, booster titles/effect
  text/accents, per-card `v` cache-buster). The page fetches it at load.
- EDIT in the top bar asks once for the edit key (localStorage). In the
  inspector: replace art — any image format/size in; the page center-crops to
  the slot aspect, resizes to expected dims and re-encodes as PNG client-side
  (exact-dims PNGs under the cap pass through untouched; art too dense for
  the 4.4 MB transport cap steps down until it fits) — edit label, edit
  booster effect text → SAVE posts to `/api/deck-edit`.
- `netlify/functions/deck-edit.mjs` guards with `X-Deck-Key` ==
  `DECK_EDIT_KEY` (timing-safe), validates path/file/PNG magic/lengths,
  requires the card to already exist in the manifest (replace-only), and
  writes ONE atomic commit via the Git Data API (`GITHUB_TOKEN`, fine-grained
  PAT: this repo only, Contents r/w): art blob + manifest bump, message
  `deck: art + label for <file> via /deck editor`. Push to main triggers the
  normal deploy; art edits bump `v`, which busts browser + image-CDN caches.
- Booster effect text auto-styles its modifiers on display — money gold,
  gains green, losses red, multipliers (Double/Triple/Nx) gold — the same
  house rule `_modifier_bbcode()` in main.gd applies on the in-game booster
  pick screen. Descriptions stay plain text in the manifest; nobody
  hand-marks colors.
- Until both env vars are set in Netlify the endpoint answers 503 and the
  page surfaces that message. Booster text edits change the page manifest
  only — `main.gd` still owns the in-game strings (possible follow-up:
  game reads the manifest, or CI drift check).

## Verification

Serve the repo root, open `/site/deck/` in a browser, and compare a fish card
and a card back side-by-side against a reference render from
`tools/card_shot.tscn` (the real in-game shell).
