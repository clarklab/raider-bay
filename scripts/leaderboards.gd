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
