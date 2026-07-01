# Online Leaderboards — Hybrid (Netlify + native) design

Date: 2026-06-30
Status: approved (design), pending implementation

## Goal

Keep the existing cross-platform online leaderboard working everywhere, and layer
platform-native leaderboards (Google Play Games Services on Android, Game Center on
iOS) on top for mobile — for verified player identity and the native leaderboard UI.

## Decisions

- **Hybrid, not replacement.** The Netlify board (`GLOBAL_SCORES_API`) stays the
  everywhere-source of truth (web, Android, iOS). Native boards are an *additional*
  submission target on mobile.
- **One "High Score" leaderboard, per solo run.** Ranked by a single composite score
  for that run: `run_score = trophies * 1_000_000 + clamp(money, 0, 999_999)`.
  Trophies dominate; money is the tiebreak — matching the current local sort
  (`_is_high_score_better`: trophies, then money, then upgrades). The native service
  keeps each player's *best* submitted run, so the board reads as "best solo voyage."
- **Solo runs only** are submitted to native boards. Versus runs are never submitted
  to native (they stay on the Netlify board only).
- **Lifetime / career aggregate stats are player-only** (local, on the stats screen).
  They are never submitted to any leaderboard — only per-run solo high scores are.
- **Phased.** Ship the integration seam now (safe, testable, nothing breaks);
  wire real native services when the apps are actually published.
- **Google Play Games first, Game Center later** ("iOS equivalent when ready").

## Architecture

### Score model
A single helper computes the composite from an already-recorded run:
`_run_score(trophies, money) -> int`. Native submission fires **only for solo runs**;
versus runs and lifetime/career aggregate stats are never submitted (they remain on
Netlify / the local stats screen respectively).

### Submission path
`_submit_career_score()` is the single entry point, called from `_record_high_score()`
right where `_submit_global_high_score(entry)` already fires:
1. Always submit to Netlify (unchanged — existing behavior; solo and versus).
2. If the run is **solo** and a native leaderboard service is available and signed in,
   submit `_run_score(...)` to it too.

### Feature-gating seam (the important part for "get ready for the future")
Native calls go through a thin wrapper that is a **no-op unless the native plugin is
present**:
- Android: `Engine.has_singleton("GodotPlayGameServices")` (the
  [godot-play-game-services](https://github.com/godot-sdk-integrations/godot-play-game-services)
  plugin's singleton). If absent → no-op.
- iOS: analogous Game Center check, later.
- Web / editor / un-configured Android → the wrapper does nothing; the game plays and
  the Netlify board works exactly as today. No crashes, no missing-symbol errors.

Leaderboard/app IDs live in one config block (`LEADERBOARD_ID_ANDROID`, etc.),
**empty by default**. When empty, native submission is skipped even if the plugin
loads. So the code can ship before any Play Console setup exists.

### Viewing the board
The "HIGH SCORES" / leaderboard entry point:
- On mobile with a configured, available native service → open the **native
  leaderboard UI** (`show_leaderboard`).
- Otherwise → the existing `GLOBAL HIGH SCORES` screen (Netlify), unchanged.

## Phase 1 — build now (testable, no external deps)

- `_run_score()` composite helper.
- `_submit_career_score()` + a `_native_leaderboards.gd`-style wrapper that
  feature-gates all native calls (all no-op without the plugin + IDs).
- Config constants for the leaderboard/app IDs (empty).
- Leaderboard button routes to native-when-available, else the global screen.
- Verify: web build still submits to Netlify and shows the global board; native calls
  no-op cleanly (no plugin present).

## Phase 2 — Google Play Games (needs Play Console + gradle build)

Requires switching the Android export to the **gradle custom build**
(`use_gradle_build=true`, install the Android build template, add the plugin under
`android/plugins/`) and updating `build-android.yml` to run the gradle build. This is
a real change to the working Android pipeline; do it on a branch and keep the current
simple-export build green until the gradle build is proven.

**User (Play Console) checklist — cannot be done from code:**
1. Create the app in Google Play Console (package `com.clarklab.raiderbay`); upload at
   least an internal-testing build.
2. Set up **Play Games Services**: link the app, create an **OAuth2 client** with the
   signing cert **SHA-1** (both the debug keystore used in CI *and* the release upload
   key).
3. Create a **leaderboard** ("High Score", larger-is-better) → note its
   **leaderboard ID**; note the **project/app ID**.
4. Send me the leaderboard ID + app ID; I wire them into the config + Android manifest
   and finish the gradle/CI plumbing.
5. Test sign-in + submit on a physical device signed into Google Play.

## Phase 3 — Game Center (iOS), later

Same seam: an iOS Game Center plugin, a `has_singleton`-style gate, an
`LEADERBOARD_ID_IOS`, and App Store Connect leaderboard config. No code churn to the
submission path — just another target behind the wrapper.

## Non-goals (YAGNI)

- No achievements (single leaderboard only for now).
- No cloud-save / snapshots.
- No custom sign-in UI beyond what the native plugin provides.
- No change to how scores are *ranked* locally or on Netlify.

## Risks

- **Gradle build change** can break the working Android release build → mitigate by
  doing Phase 2 on a branch, keep simple-export green until gradle proven.
- **Community plugin maintenance** — mitigated by the Godot Foundation now maintaining
  this plugin, and by the no-op gate (a broken/absent plugin never breaks the game).
- **Can't fully test native** without the Play Console app + a real device — Phase 1 is
  built to be safe and correct regardless.
