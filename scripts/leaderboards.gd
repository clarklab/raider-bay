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
