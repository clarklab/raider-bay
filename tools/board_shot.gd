extends Node

# Landing-page screenshot: a dealt board mid-season with a stocked live well.
# Usage: godot --resolution 1460x820 tools/board_shot.tscn -- <out.png>

const MAIN := preload("res://scenes/main.tscn")

func _ready() -> void:
	var main: Control = MAIN.instantiate()
	add_child(main)
	await get_tree().process_frame
	await get_tree().process_frame
	main.seen_training = true
	if main.has_method("_hide_deck_training"):
		main._hide_deck_training()
	main._new_game(false, true)
	# Let the deal ripple finish before dressing the scene.
	for i in range(260):
		await get_tree().process_frame
	main.day = 4
	main.money = 265
	main.live_well.append({"species": "Tuna", "quantity": 4, "age": 0})
	main.live_well.append({"species": "Salmon", "quantity": 2, "age": 1})
	main._update_hud()
	for i in range(10):
		await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	var args := OS.get_cmdline_user_args()
	var out := args[0] if args.size() > 0 else "user://board_shot.png"
	img.save_png(out)
	get_tree().quit()
