extends Node

# One-off close-up render of the card shell for corner-radius inspection.
# Usage: godot --resolution 1200x700 tools/card_shot.tscn -- <out.png>

const MAIN := preload("res://scenes/main.tscn")

func _ready() -> void:
	var main: Control = MAIN.instantiate()
	add_child(main)
	await get_tree().process_frame
	await get_tree().process_frame

	var cover := ColorRect.new()
	cover.color = Color("#101725")
	cover.anchor_right = 1.0
	cover.anchor_bottom = 1.0
	cover.z_index = 900
	add_child(cover)

	# Big weather-size front, sell-size front, and a card back.
	var big: Control = main._build_result_card(main._fish_card_texture("Tuna"), Vector2(372.0, 372.0 * main.CATCH_CARD_ASPECT), "$40", main.GOLD)
	big.position = Vector2(60, 80)
	cover.add_child(big)
	var mid: Control = main._build_result_card(main._fish_card_texture("Halibut"), Vector2(148.0, 148.0 * main.CATCH_CARD_ASPECT), "$33", main.GOLD)
	mid.position = Vector2(520, 80)
	cover.add_child(mid)
	var back: Control = main._build_store_card_visual("motor", 1, false, Vector2(232.0, 232.0 * main.CATCH_CARD_ASPECT))
	back.position = Vector2(760, 80)
	cover.add_child(back)

	for i in range(10):
		await get_tree().process_frame
	var img := get_viewport().get_texture().get_image()
	var args := OS.get_cmdline_user_args()
	var out := args[0] if args.size() > 0 else "user://card_shot.png"
	img.save_png(out)
	get_tree().quit()
