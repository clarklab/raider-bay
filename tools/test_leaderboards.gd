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
