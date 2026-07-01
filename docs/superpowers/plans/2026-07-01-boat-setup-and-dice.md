# Boat Setup screen + reusable 3D dice roll — plan

Date: 2026-07-01
Status: approved (design confirmed via decisions), implementing

## Goal
A full-screen "Boat Setup" screen shown when starting any new game (Solo or Pirate
Battle): pick 1 of 4 boat images in a carousel, edit a boat name and captain name
(both pre-filled from mix-and-match phrasebooks), a Shuffle button that randomizes
everything, and a **Set Sail** button that starts the game. Shuffle triggers a real
3D die that tumbles across the screen. The dice roll is built as a reusable component
for later use at the gameplay roll moments (cast, weather, combat).

## Confirmed decisions
- **Entry points:** both SOLO TRIP and PIRATE BATTLE (new game only; the unfinished-solo
  resume path is untouched).
- **Persistence:** none — fresh/random every new game. No save-system or High Scores changes.
- **Boat image usage:** setup flavor only — do NOT wire the selected image into in-game
  boat rendering. (One tasteful log line at game start surfaces the names.)

## Architecture (all in `scripts/main.gd`; monolith, extends Control)

### State
- `var pending_versus := false` — which mode Set Sail should launch.
- `var boat_choice := 0` — 0..3 index into BOAT_TEXTURES.
- `var boat_name := ""`, `var captain_name := ""`.
- `const BOAT_TEXTURES: Array[Texture2D] = [preload boat-1..4]`.

### Phrasebooks (constants)
- `BOAT_ADJ` (20): Rusty, Wild, Rocky, Salty, Frozen, Lucky, Grumpy, Mighty, Crooked,
  Drunken, Wicked, Foggy, Slippery, Ragged, Howling, Restless, Battered, Bristly,
  Lonesome, Stubborn.
- `BOAT_NOUN` (20, Alaska animals/places): Shark, The Point, Halibut, Kodiak, Otter,
  Ptarmigan, Sockeye, Walrus, Puffin, Glacier, Grizzly, Barnacle, King Crab, Sea Dog,
  Bering, Tundra, Moose, Sourdough, Chinook, Mudflat.
- `CAPTAIN_FIRST` (20, old-timey): Barnaby, Elias, Cornelius, Silas, Amos, Ezekiel,
  Jebediah, Mortimer, Thaddeus, Bartholomew, Horace, Ingmar, Sven, Knut, Magnus,
  Percival, Gus, Alistair, Ebenezer, Fitzgerald.
- `CAPTAIN_LAST` (20, salty): McGraw, Frostbeard, Salteye, Codd, Barnacle, Grimsby,
  Tarbuckle, Coldwater, Blackfin, Stormcrow, Bilgewater, Northwind, Driftwood,
  Whalebone, Ironhook, Sourdough, Halibutton, Kettleford, Frosthook, Bergstrom.
- `_random_boat_name()` -> "The {adj} {noun}"; `_random_captain_name()` -> "{first} {last}".

### UI helper (new)
- `_line_edit(initial, placeholder, max_len) -> LineEdit` — Balatro font, FONT_ACTION,
  TEXT_PRIMARY text, TEXT_DIM placeholder, CYAN caret; normal stylebox REF_INSET fill +
  BORDER_FRAME 2px border radius 8, focus stylebox BORDER_HI. min height ~52. (No LineEdit
  exists anywhere in the codebase yet — this is the first.)

### Boat Setup screen
- `_build_boat_setup_screen()` — overlay Control (full anchors, mouse_filter STOP,
  z_index 205), REF_BG_NAVY bg; centered VBox: title "OUTFIT YOUR BOAT" (gold) → boat
  carousel (big white-bordered navy card with `_icon_texture_rect(boat)` + chunky ◀/▶
  `_tactile_button`s on the sides + `● ○ ○ ○` dots) → CAPTAIN field → BOAT field →
  row [SHUFFLE (gold, dice icon), SET SAIL (green)] → back "✕" top-right. Store parts in `ui[]`.
- `_show_boat_setup(versus)` — set `pending_versus`, randomize fields, `move_to_front()`,
  visible=true. (move_to_front is required — GUI input picking is tree-order, not z_index.)
- `_hide_boat_setup()` / `_boat_setup_shuffle()` / `_boat_setup_set_sail()`.
- `_refresh_boat_carousel()` — updates the card texture + dots from `boat_choice`.
- Wire: SOLO TRIP no-save branch and PIRATE BATTLE button call `_show_boat_setup(bool)`
  instead of `_new_game(...)`; Set Sail stores names (fallback random if blank) then
  `_new_game(pending_versus)`. Add flavor log in `_new_game`:
  "Captain {captain_name} sets sail aboard {boat_name}!"

### Reusable 3D dice roll
- Lazy-built rig: overlay Control (full anchors, mouse_filter IGNORE, z_index 600,
  visible false) → SubViewportContainer(stretch=true) → SubViewport(own_world_3d=true,
  transparent_bg=true, msaa on) → Camera3D (perspective) + DirectionalLight3D +
  WorldEnvironment(ambient) + die Node3D.
- Die = MeshInstance3D BoxMesh (white StandardMaterial3D) + 21 black pip MeshInstance3D
  (flattened spheres) placed per standard 1-6 face layout, all children of the die node.
- `_play_dice_roll(on_done := Callable())` — show overlay, reset die to left off-screen,
  tween position left→right (~0.9s, slight vertical arc) in parallel with a big multi-axis
  `rotation` spin (random totals ~2-3 turns/axis); on finish hide overlay and call on_done.
  Doesn't settle on a face (parameter reserved for future gameplay use).
- Shuffle calls `_play_dice_roll()` and randomizes fields immediately (roll is cosmetic).

## Verification
- `npm run build` compiles (GDScript parse check).
- Web preview via a temporary `?boat_preview` hook: screen renders; ◀/▶ cycles boats;
  Shuffle changes names + boat and tumbles the die across; Set Sail starts a game;
  ✕ returns to title. Confirm the 3D die actually composites on the WEB export (fallback
  to a 2D tumble if transparent SubViewport 3D fails there). Remove the hook before commit.
- Adversarial review workflow before shipping; then release.

## Risks
- Transparent 3D SubViewport compositing on the web (WebGL2/mobile renderer) is unproven
  in this project — verify early; 2D-tumble fallback ready.
- Single 11k-line file: implement inline (parallel agents would conflict), review after.
