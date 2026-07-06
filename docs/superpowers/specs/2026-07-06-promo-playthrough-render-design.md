# Promo Playthrough Render — Design

**Date:** 2026-07-06
**Goal:** Produce a single MP4 (~45–60s, native 1460×820, 16:9) of an autonomous
Raider Bay solo game playing through 3–4 real catch/sell cycles, for use in
promo / landing-page material.

## Approach

Drive the **real** game via an in-engine autopilot, render it with Godot's Movie
Maker mode (locked-framerate, wall-clock-decoupled), and transcode the AVI to MP4
with ffmpeg. Decided against manual browser play + screen-record (robotic, low
quality) and against stitching preview labs (not a genuine playthrough).

Framing: raw game window (no phone shell). RNG: **fixed seed** for a reproducible,
curated "good take" (re-roll by changing the seed constant).

## Component 1 — Autopilot hook (`scripts/main.gd`, debug-only)

Entirely inert unless launched with a `--autoplay` user arg, so it never affects
normal play or ships as active behavior.

- **Trigger:** in `_ready()`, check `OS.get_cmdline_user_args().has("--autoplay")`.
  When set:
  - Set an `autopilot := true` flag.
  - Suppress overlays that would block the run: force `seen_training = true`
    (skip `_maybe_show_first_run_training`) and skip the update-chip check.
  - Seed `rng` with a fixed constant (`AUTOPILOT_SEED`) instead of
    `rng.randomize()`.
  - `call_deferred("_run_autopilot")`.
- **`_run_autopilot()` coroutine** — pure orchestration over existing gameplay
  functions, paced with `await get_tree().create_timer(t).timeout`:
  1. Title beat (~1.5s) → `_new_game(false)` (opens Boat Setup).
  2. Boat Setup beat (~2s): `_boat_setup_shuffle()` once (dice-roll flavor),
     force `boat_choice = 0` (motor perk → 4 moves/day) → `_boat_setup_set_sail()`.
  3. Await the board-deal animation (fixed delay).
  4. For each of ~4 days:
     - `_pick_fish_cell()`: scan `board` for the nearest fish tile reachable from
       the dock within the move budget, preferring shallow rows (4–5) near the
       dock columns. Returns a route (list of `_move` deltas).
     - Walk the route via `_move()`, one step per short beat.
     - `_find_fish()` (finder card-fan) → beat → `_cast()` (catch card-fan) → beat.
     - Walk back and dock via `_move()`.
     - `_sell_catch()` → sell modal. Alternate per day: `_confirm_sale()` (SOLD)
       vs `_haggle_sale()` (dice + confetti/BONK) — haggle shown at least once.
       Beat on the outcome → `_close_sell_modal()`.
     - `_end_day()` (weather resolve + day transition).
  5. Final beat → `get_tree().quit()` so Movie Maker finalizes the file.
- **Robustness:** each step re-checks guards (`game_over`, `active_tray`,
  `_can_attempt_cast_here`, move budget) and no-ops safely if state isn't as
  expected, so a single unlucky beat can't wedge the run. The fixed seed + steer-
  to-fish routing makes catches reliable.

## Component 2 — Render script (`scripts/render-promo.sh` + `npm run render:promo`)

1. `"$GODOT" --path . --write-movie builds/promo/raider-bay.avi --fixed-fps 60 -- --autoplay`
   (`GODOT` defaults to `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot`).
   Movie Maker renders decoupled from real time at a locked 60fps, so every tween
   / card-fan / video cutscene renders in full regardless of machine speed.
2. `ffmpeg -y -i builds/promo/raider-bay.avi -c:v libx264 -crf 18 -pix_fmt yuv420p
   -movflags +faststart -c:a aac builds/promo/raider-bay.mp4` (map audio if the AVI
   carries it; silent otherwise).
3. Print the final path + duration.

`builds/` is gitignored (build output) — the MP4 is a deliverable artifact, not
committed.

## Verification

- Run the script end-to-end; confirm `raider-bay.mp4` exists, plays, and is
  ~45–60s.
- Extract frames (ffmpeg) and confirm the reel visibly contains: boat setup,
  leaving the dock, a finder ping, at least one catch card-fan, a sell (SOLD) and
  a haggle (dice + confetti/BONK), and a weather/day transition.

## Risks / mitigations

- **Movie Maker needs a real GPU context** (not `--headless`): opens a window;
  fine to run unattended.
- **Move-budget routing:** keep fishing to cells adjacent to the dock so each trip
  completes a catch→sell in one day.
- **Overlay blockers** (training, update chip): explicitly suppressed under
  autoplay.
- **Audio track absence:** ffmpeg audio mapping tolerant of a video-only AVI.
