# Online Leaderboards — Phase 1 (integration seam) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the code seam for native leaderboards (composite per-run score + a feature-gated native wrapper wired into the existing score flow) so publishing real apps later is drop-in, while nothing changes on web/editor/un-configured builds.

**Architecture:** A small focused `Leaderboards` helper class owns the pure composite-score math and a feature-gated native wrapper (all calls no-op unless a native plugin AND a real leaderboard ID are present). `main.gd`'s existing `_record_high_score()` calls the wrapper for **solo runs only**, alongside the unchanged Netlify submission. The high-scores button opens the native board when available, else the existing global screen.

**Tech Stack:** Godot 4.6 GDScript. Verification is Godot's headless script runner (`godot --headless --script …`) for the pure logic, plus `--check-only` parse and the web build/preview for the wiring (there is no unit-test framework in this project; headless scripts are the established way to exercise pure GDScript).

**Out of scope (future phases, gated on external setup):** installing the `godot-play-game-services` plugin, enabling the gradle Android build, updating `build-android.yml`, and filling real Play Console / App Store leaderboard IDs. Phase 1 leaves all of that behind empty config + a no-op gate. See the design spec `docs/superpowers/specs/2026-06-30-online-leaderboards-design.md`.

**Godot binary:** `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot` (not on PATH).

---

### Task 1: `Leaderboards.run_score()` composite-score helper (pure, tested)

**Files:**
- Create: `scripts/leaderboards.gd`
- Create: `tools/test_leaderboards.gd`

- [ ] **Step 1: Write the failing test**

Create `tools/test_leaderboards.gd`:

```gdscript
extends SceneTree

# Headless test for the Leaderboards helper.
# Run: Godot --headless --script tools/test_leaderboards.gd

const Leaderboards := preload("res://scripts/leaderboards.gd")

func _init() -> void:
	var failures := 0
	failures += _expect("empty run", Leaderboards.run_score(0, 0), 0)
	failures += _expect("money only", Leaderboards.run_score(0, 250), 250)
	failures += _expect("trophies dominate money", Leaderboards.run_score(1, 0), 1_000_000)
	# 5 trophies + $200 must outrank 4 trophies + $999,999.
	var a := Leaderboards.run_score(5, 200)
	var b := Leaderboards.run_score(4, 999_999)
	failures += _expect("5t/$200 > 4t/$max", int(a > b), 1)
	# Money is clamped so it can never bleed into the trophy digit.
	failures += _expect("money clamps below 1e6", Leaderboards.run_score(0, 5_000_000), 999_999)
	# Negative money floors at 0 (no negative scores).
	failures += _expect("negative money floors", Leaderboards.run_score(2, -50), 2_000_000)
	if failures == 0:
		print("ALL PASS")
		quit(0)
	else:
		printerr("FAILURES: %d" % failures)
		quit(1)

func _expect(label: String, got, want) -> int:
	if got == want:
		print("ok  - %s (%s)" % [label, str(got)])
		return 0
	printerr("FAIL - %s: got %s want %s" % [label, str(got), str(want)])
	return 1
```

- [ ] **Step 2: Run test to verify it fails**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --script tools/test_leaderboards.gd`
Expected: FAIL — the `preload("res://scripts/leaderboards.gd")` cannot resolve (file does not exist yet), so the test script errors on load. Non-zero exit.

- [ ] **Step 3: Write minimal implementation**

Create `scripts/leaderboards.gd`:

```gdscript
extends RefCounted

# Loaded via `preload("res://scripts/leaderboards.gd")` (as `Leaderboards`) rather than
# `class_name`, so it resolves deterministically under `godot --headless --script`.

# Native leaderboard config — EMPTY until an app is published and a leaderboard exists.
# While empty, native submission/opening is skipped even if a plugin is present.
const LEADERBOARD_ID_ANDROID := ""   # Google Play Games leaderboard ID (Phase 2)
const LEADERBOARD_ID_IOS := ""       # Game Center leaderboard ID (Phase 3)

# The godot-play-game-services plugin registers this autoload node when installed.
const GPGS_AUTOLOAD := "GodotPlayGamesServices"

# Per-run leaderboard score: trophies dominate, money (0..999,999) is the tiebreak.
# Matches main.gd's local sort (_is_high_score_better: trophies, then money).
static func run_score(trophies: int, money: int) -> int:
	return maxi(0, trophies) * 1_000_000 + clampi(money, 0, 999_999)
```

- [ ] **Step 4: Run test to verify it passes**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --script tools/test_leaderboards.gd`
Expected: prints `ok - …` lines then `ALL PASS`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/leaderboards.gd tools/test_leaderboards.gd
git commit -m "feat(leaderboards): composite per-run score helper + headless test"
```

---

### Task 2: Feature-gated native wrapper (no-op without plugin + ID)

**Files:**
- Modify: `scripts/leaderboards.gd`
- Modify: `tools/test_leaderboards.gd`

- [ ] **Step 1: Add the failing test**

Append these lines to `tools/test_leaderboards.gd` inside `_init()`, right before the `if failures == 0:` check:

```gdscript
	# With no plugin installed and empty IDs, native is unavailable and calls no-op.
	failures += _expect("native unavailable in editor/headless", int(Leaderboards.native_available()), 0)
	# These must be safe to call and simply do nothing (no crash) when unavailable.
	Leaderboards.submit_solo_run(5, 200)
	Leaderboards.show_leaderboard()
	failures += _expect("no-op calls survived", 1, 1)
```

- [ ] **Step 2: Run test to verify it fails**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --script tools/test_leaderboards.gd`
Expected: FAIL — `Invalid call. Nonexistent function 'native_available'` (or parse error). Non-zero exit.

- [ ] **Step 3: Write minimal implementation**

Append to `scripts/leaderboards.gd`:

```gdscript
# The plugin autoload node, if the godot-play-game-services plugin is installed.
# Uses the running SceneTree via Engine.get_main_loop() so it works from both the
# game (a Node) and the headless test (a SceneTree). Returns null otherwise.
static func _plugin() -> Node:
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		var root := (loop as SceneTree).root
		if root != null and root.has_node(GPGS_AUTOLOAD):
			return root.get_node(GPGS_AUTOLOAD)
	return null

# True only when the plugin is present AND a real leaderboard ID is configured.
static func native_available() -> bool:
	return LEADERBOARD_ID_ANDROID != "" and _plugin() != null

# Submit a solo run's composite score to the native leaderboard, if available.
# NOTE (Phase 2): the exact plugin method is finalized against the installed plugin.
# It is `has_method`-guarded and never fires in Phase 1 (no plugin / empty ID).
static func submit_solo_run(trophies: int, money: int) -> void:
	if not native_available():
		return
	var g := _plugin()
	var score := run_score(trophies, money)
	if g.has_method("submit_leaderboard_score"):
		g.call("submit_leaderboard_score", LEADERBOARD_ID_ANDROID, score)

# Open the native leaderboard UI, if available (else caller falls back to the
# global-scores screen).
static func show_leaderboard() -> void:
	if not native_available():
		return
	var g := _plugin()
	if g.has_method("show_leaderboard"):
		g.call("show_leaderboard", LEADERBOARD_ID_ANDROID)
```

- [ ] **Step 4: Run test to verify it passes**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --script tools/test_leaderboards.gd`
Expected: all `ok` lines incl. the new ones, then `ALL PASS`, exit 0.

- [ ] **Step 5: Commit**

```bash
git add scripts/leaderboards.gd tools/test_leaderboards.gd
git commit -m "feat(leaderboards): feature-gated native wrapper (no-op without plugin/ID)"
```

---

### Task 3: Submit solo runs from `_record_high_score()`

**Files:**
- Modify: `scripts/main.gd` (function `_record_high_score`, near line 10356 — the `_submit_global_high_score(entry)` line)

- [ ] **Step 1: Locate the call site**

Run: `grep -n "_submit_global_high_score(entry)" scripts/main.gd`
Expected: one hit inside `_record_high_score()` (~line 10356).

- [ ] **Step 2: Add the `Leaderboards` preload constant**

In `scripts/main.gd`, immediately after the `GLOBAL_SCORES_API` constant (near line 54), add:

```gdscript
const Leaderboards := preload("res://scripts/leaderboards.gd")
```

- [ ] **Step 3: Add the native submission (solo only)**

In `scripts/main.gd`, change:

```gdscript
	_save_high_scores(scores)
	_submit_global_high_score(entry)
	return last_high_score_rank
```

to:

```gdscript
	_save_high_scores(scores)
	_submit_global_high_score(entry)
	# Native leaderboard (Google Play Games / Game Center) — solo runs only, and a
	# safe no-op unless the plugin + a real leaderboard ID are present (Phase 2+).
	if not versus_mode:
		Leaderboards.submit_solo_run(_trophy_count(), money)
	return last_high_score_rank
```

- [ ] **Step 4: Parse-check**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --check-only --script scripts/main.gd`
Expected: no `SCRIPT ERROR` / `Parse Error`, exit 0.

- [ ] **Step 5: Re-run the leaderboards test (regression)**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --script tools/test_leaderboards.gd`
Expected: `ALL PASS`, exit 0.

- [ ] **Step 6: Commit**

```bash
git add scripts/main.gd
git commit -m "feat(leaderboards): submit solo-run scores to native board (gated)"
```

---

### Task 4: Route the leaderboard button to native-when-available

**Files:**
- Modify: `scripts/main.gd` (function `_show_high_scores_screen`)

- [ ] **Step 1: Read the current entry point**

Run: `grep -n "func _show_high_scores_screen" scripts/main.gd` and read the function.
Expected: it opens/fetches the global (Netlify) high-scores screen.

- [ ] **Step 2: Prefer the native board when available**

At the very top of `_show_high_scores_screen()` (first lines of the body), insert:

```gdscript
	# On mobile with a configured native leaderboard, open the platform UI instead
	# of the in-game global screen. No-ops elsewhere (falls through to the screen).
	if Leaderboards.native_available():
		Leaderboards.show_leaderboard()
		return
```

- [ ] **Step 3: Parse-check**

Run: `/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot --headless --check-only --script scripts/main.gd`
Expected: exit 0, no errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/main.gd
git commit -m "feat(leaderboards): open native board from High Scores when available"
```

---

### Task 5: Full-build verification (web unaffected, native no-ops)

**Files:** none (verification only)

- [ ] **Step 1: Build the web export**

Run: `npm run build`
Expected: exit 0, `builds/web/index.pck` updated, no parse/export errors. (The build is also the reliable compile check.)

- [ ] **Step 2: Verify the global (Netlify) board still works and native no-ops**

Serve `builds/web/` and open it (see `docs`/memory for the local-preview flow). Play or trigger a game-over, then open HIGH SCORES.
Expected: the GLOBAL HIGH SCORES screen appears exactly as before (native is unavailable on web, so `_show_high_scores_screen` falls through). No errors in the browser console related to `Leaderboards`.

- [ ] **Step 3: Confirm no behavior change off-mobile**

Confirm: solo game-over still records + submits to Netlify; `Leaderboards.submit_solo_run` returns immediately (native unavailable). Nothing new is user-visible on web — the seam is dormant until Phase 2.

- [ ] **Step 4: Commit (if any doc/notes updates)**

No code changes expected here; only commit if notes/docs were touched.

---

## Phase 2 pointer (do NOT do now)

When the app is published, follow the design spec's Play Console checklist, then:
`use_gradle_build=true` + install the plugin under `android/plugins/` + set
`LEADERBOARD_ID_ANDROID` + confirm the plugin's real method names in
`Leaderboards.submit_solo_run` / `show_leaderboard` (replace the `has_method` best-effort
call with the installed plugin's node API) + update `build-android.yml` for the gradle
build on a branch (keep the current simple-export build green until proven).
