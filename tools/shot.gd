extends Node

# Headless-ish screenshot harness: instances the main scene, starts a solo game,
# waits a few frames for layout to settle, captures the viewport, writes a PNG, quits.
# Usage: xvfb-run godot --resolution 1460x820 tools/shot.tscn -- <out.png> [select]

const MAIN := preload("res://scenes/main.tscn")

func _ready() -> void:
	var main: Control = MAIN.instantiate()
	add_child(main)
	await get_tree().process_frame
	await get_tree().process_frame
	main._new_game(false)
	# Optionally reveal a few tiles / select a cell to exercise selection states.
	var args := OS.get_cmdline_user_args()
	var out_path := "user://shot.png"
	if args.size() > 0:
		out_path = args[0]
	var scenario := ""
	if args.size() > 1:
		scenario = args[1]
	# Let board deal / tweens settle.
	for i in range(40):
		await get_tree().process_frame
	if scenario == "sea":
		# Boat out at sea + a loaded live well + chatty log: stress the rail width.
		main.boat_pos = Vector2i(4, 2)
		main.live_well = [
			{"species": "Swordfish", "quantity": 8, "age": 0},
			{"species": "Salmon", "quantity": 5, "age": 1},
			{"species": "Tuna", "quantity": 3, "age": 2},
		]
		main.log_lines = [
			"You hauled in 8 Swordfish on a single monster cast off the deep ledge!",
			"Storm rolling in tonight — multiplier jumps to 1.4x for the brave.",
			"Sold 10 Salmon at once and bagged the SALMON trophy.",
		]
		main.trophies["Salmon"] = true
		main._update_ui()
		for i in range(12):
			await get_tree().process_frame
	elif scenario == "select" and main.has_method("_on_cell_pressed"):
		main._on_cell_pressed(Vector2i(3, 2))
		for i in range(10):
			await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(out_path)
	print("WROTE ", out_path, " size=", img.get_size())
	get_tree().quit()
