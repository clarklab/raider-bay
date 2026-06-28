extends Control

# ────────────────────────────────────────────────────────────────────────
# Game constants
# ────────────────────────────────────────────────────────────────────────

const GRID_COLS := 8
const GRID_ROWS := 6
const DOCK_COL := 3
const DOCK_WIDTH_CELLS := 2
# THE DOCKS is a two-cell labelled gateway at cols DOCK_START_COL..DOCK_END_COL.
const DOCK_START_COL := DOCK_COL
const DOCK_END_COL := DOCK_COL + 1
# Entered/left via the water cells above it (straight up or diagonal); boats park in the dotted side zones.
const DOCK_ACCESS_START_COL := DOCK_START_COL - 1
const DOCK_ACCESS_END_COL := DOCK_END_COL + 1
const BOARD_CARD_GAP := 4
const BOARD_CELL_WIDTH := 78
const BOARD_CELL_HEIGHT := 101
const BOARD_GRID_WIDTH := GRID_COLS * BOARD_CELL_WIDTH + (GRID_COLS - 1) * BOARD_CARD_GAP
const BOARD_GRID_HEIGHT := GRID_ROWS * BOARD_CELL_HEIGHT + (GRID_ROWS - 1) * BOARD_CARD_GAP
const BOARD_WRAP_WIDTH := BOARD_GRID_WIDTH + 54
const BOARD_WRAP_HEIGHT := BOARD_GRID_HEIGHT + BOARD_CELL_HEIGHT + BOARD_CARD_GAP + 14
const MAX_DAYS := 14
const START_MONEY := 50
const BASE_MOVES := 3
const BASE_LIVE_WELL_DAYS := 2
const START_CASTS := 1
const CONDITION_MAX := 10
const UPGRADE_MAX_LEVEL := 5
const REPAIR_COST_PER_SEGMENT := 8
const EXTRA_NIGHT_COST := 250
const TROPHY_REQUIRED := 10
const TROPHY_WIN_COUNT := 5
const TREASURE_VALUES: Array[int] = [100, 100, 200, 200]
const TREASURE_KIND_CASH := "cash"
const TREASURE_KIND_PAID_NIGHT := "paid_night"
const SHOAL_TARGET_RANGE := Vector2i(5, 6)
const MID_TARGET_RANGE := Vector2i(8, 8)
const DEEP_TARGET_RANGE := Vector2i(10, 11)
const SHOAL_ITEM_COUNT := 2
const MID_ITEM_COUNT := 3
const DEEP_ITEM_COUNT := 3
const SHOAL_CASH_ITEM_COUNT := 1
const MID_CASH_ITEM_COUNT := 1
const DEEP_CASH_ITEM_COUNT := 2
const CASTS_PER_HOLE: Array[int] = [1, 2, 3, 5]
const CAST_DIE_SIDES := 6
const TABLE_SIDE_WIDTH := 280
const TABLE_COMMAND_WIDTH := 332
const TABLE_HEADER_HEIGHT := 118
const SAVE_PATH := "user://raider_bay_save.json"
const HIGH_SCORES_PATH := "user://raider_bay_high_scores.json"
const GLOBAL_SCORES_API := "https://raiderbay.netlify.app/api/scores"
const GLOBAL_SCORES_TIMEOUT := 8.0
const MAX_HIGH_SCORES := 50
const SAVE_VERSION := 1
const MODE_SOLO := "solo"
const MODE_VERSUS := "versus"
const BOT_NAME := "Rust Bucket"

const GAME_BG_TEXTURE: Texture2D = preload("res://assets/game-bg.webp")
const START_SCREEN_TEXTURE: Texture2D = preload("res://assets/screen-start.png")
const START_BUTTON_SOLO_TEXTURE: Texture2D = preload("res://assets/button-solo.png")
const START_BUTTON_BATTLE_TEXTURE: Texture2D = preload("res://assets/button-battle.png")
const FONT_BALATRO: FontFile = preload("res://assets/fonts/Balatro.otf")
const FISH_COD_TEXTURE: Texture2D = preload("res://assets/fish-cod.webp")
const FISH_GROUPER_TEXTURE: Texture2D = preload("res://assets/fish-grouper.webp")
const FISH_HALIBUT_TEXTURE: Texture2D = preload("res://assets/fish-halibut.webp")
const FISH_SALMON_TEXTURE: Texture2D = preload("res://assets/fish-salmon.webp")
const FISH_SWORDFISH_TEXTURE: Texture2D = preload("res://assets/fish-swordish.webp")
const FISH_TUNA_TEXTURE: Texture2D = preload("res://assets/fish-tuna.webp")
const ICON_HEALTH_TEXTURE: Texture2D = preload("res://assets/icons/material-cardiology.png")
const ICON_LIVE_WELL_TEXTURE: Texture2D = preload("res://assets/icons/material-set-meal.png")
const ICON_MAP_TEXTURE: Texture2D = preload("res://assets/icons/material-explore.png")
const ICON_UPGRADES_TEXTURE: Texture2D = preload("res://assets/icons/material-construction.png")
const ICON_RADIO_TEXTURE: Texture2D = preload("res://assets/icons/material-settings-input-antenna.png")
const ICON_CLEAR_TEXTURE: Texture2D = preload("res://assets/icons/material-sunny.png")
const ICON_STORM_TEXTURE: Texture2D = preload("res://assets/icons/material-thunderstorm.png")
const ICON_HURRICANE_TEXTURE: Texture2D = preload("res://assets/icons/material-cyclone.png")
const ICON_CARD_SHIP_TEXTURE: Texture2D = preload("res://assets/icons/icon-card-ship.svg")
const ICON_ROCKET_FISH_TEXTURE: Texture2D = preload("res://assets/icons/icon-rocket-fish.svg")
const ICON_TROPHY_OUTLINE: Texture2D = preload("res://assets/icons/trophy-outline.svg")
const ICON_TROPHY_SOLID: Texture2D = preload("res://assets/icons/trophy-solid.svg")
const ICON_DAY_TEXTURE: Texture2D = preload("res://assets/icons/icon-day.svg")
const ICON_FUNDS_TEXTURE: Texture2D = preload("res://assets/icons/icon-funds.svg")
const ICON_MOVES_TEXTURE: Texture2D = preload("res://assets/icons/icon-moves.svg")
const ICON_FIND_FISH_TEXTURE: Texture2D = preload("res://assets/icons/icon-find-fish.svg")
const ICON_CAST_TEXTURE: Texture2D = preload("res://assets/icons/icon-cast.svg")
const ICON_CARD_GROUPER_TEXTURE: Texture2D = preload("res://assets/icons/icon-card-grouper.png")
const ICON_CARD_HALIBUT_TEXTURE: Texture2D = preload("res://assets/icons/icon-card-halibut.png")
const ICON_CARD_SALMON_TEXTURE: Texture2D = preload("res://assets/icons/icon-card-salmon.png")
const ICON_CARD_SWORDFISH_TEXTURE: Texture2D = preload("res://assets/icons/icon-card-swordfish.png")
const ICON_CARD_TUNA_TEXTURE: Texture2D = preload("res://assets/icons/icon-card-tuna.png")
const CARD_GROUPER_TEXTURE: Texture2D = preload("res://assets/cards/card-grouper.png")
const CARD_HALIBUT_TEXTURE: Texture2D = preload("res://assets/cards/card-halibut.png")
const CARD_SALMON_TEXTURE: Texture2D = preload("res://assets/cards/card-salmon.png")
const CARD_SWORDFISH_TEXTURE: Texture2D = preload("res://assets/cards/card-swordfish.png")
const CARD_TUNA_TEXTURE: Texture2D = preload("res://assets/cards/card-tuna.png")
const CARD_TREASURE_100_TEXTURE: Texture2D = preload("res://assets/cards/card-treasure-100.png")
const CARD_TREASURE_200_TEXTURE: Texture2D = preload("res://assets/cards/card-treasure-200.png")
const CARD_TREASURE_NIGHT_TEXTURE: Texture2D = preload("res://assets/cards/card-night-1.png")
const CARD_BACK_TEXTURE: Texture2D = preload("res://assets/cards/card-back.png")
const CARD_MOTOR_TEXTURES: Array[Texture2D] = [
	preload("res://assets/cards/card-motor-1.png"),
	preload("res://assets/cards/card-motor-2.png"),
	preload("res://assets/cards/card-motor-3.png"),
	preload("res://assets/cards/card-motor-4.png"),
	preload("res://assets/cards/card-motor-5.png"),
]
const CARD_FISH_FINDER_TEXTURES: Array[Texture2D] = [
	preload("res://assets/cards/card-fish-finder-1.png"),
	preload("res://assets/cards/card-fish-finder-2.png"),
	preload("res://assets/cards/card-fish-finder-3.png"),
	preload("res://assets/cards/card-fish-finder-4.png"),
	preload("res://assets/cards/card-fish-finder-5.png"),
]
const CARD_NETS_TEXTURES: Array[Texture2D] = [
	preload("res://assets/cards/card-nets-1.png"),
	preload("res://assets/cards/card-nets-2.png"),
	preload("res://assets/cards/card-nets-3.png"),
	preload("res://assets/cards/card-nets-4.png"),
	preload("res://assets/cards/card-nets-5.png"),
]

const BG_CALM_STREAM: AudioStream = preload("res://assets/bg-calm.mp3")
const BG_BIRDS_STREAM: AudioStream = preload("res://assets/bg-birds.mp3")
const BG_WAVES_STREAM: AudioStream = preload("res://assets/bg-waves.mp3")
const SOUND_REEL_STREAM: AudioStream = preload("res://assets/sound-reel.mp3")
const SOUND_BONK_STREAM: AudioStream = preload("res://assets/sound-bonk.mp3")
const SOUND_CATCH_STREAM: AudioStream = preload("res://assets/sound-catch.mp3")

# Birds cycle: distant → near → close → gone, on a rolling loop. Volumes are
# linear amplitudes (0..1); we crossfade between them so the birds "come and
# go" rather than snapping between levels.
const BIRDS_VOLUME_PHASES: Array[float] = [0.20, 0.60, 0.80, 0.0]
const BIRDS_PHASE_SECONDS := 22.0
const BIRDS_TRANSITION_SECONDS := 7.0
const WEATHER_AUDIO_CROSSFADE_SECONDS := 1.8
const AUDIO_SILENT_DB := -80.0
const BOT_STEP_SECONDS := 0.5
const CATCH_CARD_MAX_DRAW := 12
const CATCH_CARD_ASPECT := 2514.0 / 1880.0
const CATCH_CARD_DRAW_STAGGER := 0.7
const CATCH_CARD_DRAW_SECONDS := 0.34
const CATCH_TOTAL_POP_DELAY := 0.74
# Per-card plonk pitch ramp (semitone offsets): plonk → PLONK → plink → PLINK → PLANK …
const PLONK_SEMITONES: Array[int] = [0, 2, 4, 7, 9, 12, 14, 16, 19, 21, 23, 24]

# Typography — mobile-friendly defaults. Bump in one place to scale the whole UI.
const FONT_TITLE      := 30
const FONT_SUBTITLE   := 13
const FONT_PILL       := 16
const FONT_HEADER     := 15
const FONT_TAB        := 15
const FONT_ACTION     := 17
const FONT_BODY       := 16
const FONT_SMALL      := 14
const FONT_CELL       := 18
const FONT_CELL_BIG   := 22
const FONT_BOAT       := 30

const SPECIES: Array[String] = ["Swordfish", "Salmon", "Grouper", "Halibut", "Tuna"]
const BASE_PRICES: Dictionary = {
	"Cod": 18,
	"Swordfish": 18,
	"Salmon": 22,
	"Grouper": 25,
	"Halibut": 28,
	"Tuna": 32,
}

const UPGRADE_KEYS: Array[String] = ["motor", "fish_finder", "nets", "live_well", "cannons", "defense"]
const UPGRADE_BASE_COST: Dictionary = {
	"motor": 50,
	"fish_finder": 50,
	"nets": 50,
	"live_well": 50,
	"cannons": 50,
	"defense": 50,
}
const UPGRADE_COST_STEP: Dictionary = {
	"motor": 50,
	"fish_finder": 50,
	"nets": 50,
	"live_well": 50,
	"cannons": 50,
	"defense": 50,
}

const CONDITION_KEYS: Array[String] = ["hull", "propeller", "rudder", "nets"]

# ────────────────────────────────────────────────────────────────────────
# Palette (navy-first, tactile)
# ────────────────────────────────────────────────────────────────────────

const BG_DEEP        := Color("#05131d")
const BG_PANEL       := Color("#0a2536")
const BG_PANEL_DARK  := Color("#071a27")
const BG_PANEL_LIGHT := Color("#12384f")
const BG_BODY        := Color("#203b59")
const BG_NAV         := Color("#081722")
const BG_ROW         := Color("#243f5f")
const BORDER_DARK    := Color("#07121c")
const BORDER_FRAME   := Color("#27668d")
const BORDER_HI      := Color("#6fb6d8")
const TEXT_PRIMARY   := Color("#f1f7fb")
const TEXT_MUTED     := Color("#a3bccd")
const TEXT_DIM       := Color("#5a7993")
const CYAN           := Color("#8bd7f5")
const CYAN_DEEP      := Color("#1688b0")
const GOLD           := Color("#f4c64a")
const GOLD_DEEP      := Color("#b98a1d")
const GOLD_DIM       := Color("#5b4818")
const NEON_COMPUTER_YELLOW := Color("#fff04a")
const RED            := Color("#f87171")
const RED_DEEP       := Color("#a64545")
const RED_DIM        := Color("#5b1f24")
const GREEN          := Color("#62d3a0")
const GREEN_DEEP     := Color("#2e8c66")
const PURPLE         := Color("#b59cf6")
const PURPLE_DEEP    := Color("#6d58b8")
const INDIGO         := Color("#8f9cf1")
const INDIGO_DEEP    := Color("#4f5db9")
const WOOD_DARK      := Color("#5b3a20")
const WOOD_MID       := Color("#7c5230")
const WOOD_LIGHT     := Color("#a8784a")
# Sea bands: top two rows are deepest, middle three are mid-water, bottom
# three are visually transparent so the chart/map art carries the shallows.
const SEA_DEEP       := Color("#132b53")
const SEA_MID        := Color("#245a78")
const SEA_SHOAL      := Color("#4aa5ba")
const SEGMENT_EMPTY  := Color("#0a1f2e")
const SHADOW         := Color(0, 0, 0, 0.32)

# ────────────────────────────────────────────────────────────────────────
# Runtime state
# ────────────────────────────────────────────────────────────────────────

var rng := RandomNumberGenerator.new()

var game_started := false
var versus_mode := false

var board: Array[Dictionary] = []
var boat_pos := Vector2i(DOCK_COL, GRID_ROWS)
var day := 1
var money := 0
var moves_remaining := 0
var finds_remaining := 0
var casts_remaining := 0
var game_over := false
var game_stats: Dictionary = {}
var high_score_recorded := false
var last_high_score_rank := -1
var last_high_score_top_10 := false
var global_scores_status := ""
var global_scores: Array = []

var upgrades: Dictionary = {}
var conditions: Dictionary = {}
var live_well: Array[Dictionary] = []
var market_prices: Dictionary = {}
var sold_totals: Dictionary = {}
var trophies: Dictionary = {}
var sale_selection: Dictionary = {}
var extra_nights := 0
var upgrade_cart: Dictionary = {}
var extra_night_cart := 0

var weather_deck: Array[Dictionary] = []
var forecast: Array[Dictionary] = []
var current_weather: Dictionary = {"name": "Clear", "strength": 0}
var log_lines: Array[String] = []
var cast_holes_today: Dictionary = {}

var bot_pos := Vector2i(DOCK_COL, GRID_ROWS)
var bot_money := 0
var bot_moves_remaining := 0
var bot_finds_remaining := 0
var bot_casts_remaining := 0
var bot_live_well: Array[Dictionary] = []
var bot_upgrades: Dictionary = {}
var bot_conditions: Dictionary = {}
var bot_sold_totals: Dictionary = {}
var bot_trophies: Dictionary = {}
var bot_cast_holes_today: Dictionary = {}

var active_tab: String = "map"  # health | live_well | map | upgrades | radio
var active_tray: String = ""     # "" | upgrade | repair
var selected_upgrade_card_key := ""
var selected_upgrade_card_level := 0
var upgrade_card_purchase_locked := false
var card_tooltip_token := 0
var end_day_prompt_time := 0.0
var catch_card_token := 0
var board_fx_time := 0.0

# ────────────────────────────────────────────────────────────────────────
# UI node refs
# ────────────────────────────────────────────────────────────────────────

var ui: Dictionary = {}
var cell_buttons: Array[Button] = []
var action_buttons: Dictionary = {}
var tab_buttons: Dictionary = {}
var boat_segment_panels: Dictionary = {}
var upgrade_tray_rows: Dictionary = {}
var upgrade_store_lanes: Dictionary = {}
var repair_tray_rows: Dictionary = {}

var audio_calm: AudioStreamPlayer
var audio_waves: AudioStreamPlayer
var audio_birds: AudioStreamPlayer
var audio_reel: AudioStreamPlayer
var audio_bonk: AudioStreamPlayer
var audio_catch: AudioStreamPlayer
var plonk_players: Array[AudioStreamPlayer] = []
var plonk_index: int = 0
var cast_audio_token: int = 0
var audio_muted: bool = false
var birds_phase_index: int = 0
var birds_phase_time: float = 0.0
var birds_previous_volume: float = 0.0
var calm_current_volume: float = 1.0
var waves_current_volume: float = 0.0
var global_scores_fetch_request: HTTPRequest
var global_scores_submit_request: HTTPRequest


# ────────────────────────────────────────────────────────────────────────
# Lifecycle
# ────────────────────────────────────────────────────────────────────────

func _ready() -> void:
	rng.randomize()
	_apply_global_font_theme()
	# Balatro.otf only has a limited glyph set; fall back to Godot's bundled font (full Unicode
	# coverage, ships in the export) so symbols like · ● × → don't render as tofu squares.
	# (Via a local Font var because you can't assign to a const's property directly.)
	var balatro_font: Font = FONT_BALATRO
	if ThemeDB.fallback_font and balatro_font.fallbacks.is_empty():
		balatro_font.fallbacks = [ThemeDB.fallback_font]
	_build_ui()
	_build_start_screen()
	_show_start_screen()
	_build_audio()
	_build_global_score_requests()
	_apply_safe_area_inset()
	get_viewport().size_changed.connect(_apply_safe_area_inset)
	set_process(true)
	_schedule_catch_preview_from_query()


func _apply_global_font_theme() -> void:
	var app_theme: Theme = theme
	if app_theme == null:
		app_theme = Theme.new()
	app_theme.default_font = FONT_BALATRO
	app_theme.default_font_size = FONT_BODY
	theme = app_theme


func _build_global_score_requests() -> void:
	global_scores_fetch_request = HTTPRequest.new()
	global_scores_fetch_request.timeout = GLOBAL_SCORES_TIMEOUT
	global_scores_fetch_request.request_completed.connect(_on_global_scores_fetch_completed)
	add_child(global_scores_fetch_request)

	global_scores_submit_request = HTTPRequest.new()
	global_scores_submit_request.timeout = GLOBAL_SCORES_TIMEOUT
	global_scores_submit_request.request_completed.connect(_on_global_score_submit_completed)
	add_child(global_scores_submit_request)


func _schedule_catch_preview_from_query() -> void:
	if not OS.has_feature("web") and not ClassDB.class_exists("JavaScriptBridge"):
		return
	var search := str(JavaScriptBridge.eval("window.location.search + window.location.hash", true))
	if search.find("catch_preview=") == -1:
		return

	var raw := ""
	var query := search.trim_prefix("?")
	for part in query.split("&", false):
		if part.begins_with("catch_preview="):
			raw = part.trim_prefix("catch_preview=").to_lower()
			break
	if raw == "":
		return
	if _schedule_fan_preview(raw):
		return
	if _schedule_finder_preview(raw):
		return
	if _schedule_treasure_preview(raw):
		return

	var species_key := ""
	var quantity_text := ""
	var multiplier_text := ""
	var reading_multiplier := false
	for i in range(raw.length()):
		var ch := raw.substr(i, 1)
		if ch == "x":
			reading_multiplier = true
		elif ch >= "0" and ch <= "9":
			if reading_multiplier:
				multiplier_text += ch
			else:
				quantity_text += ch
		else:
			species_key += ch

	var species := _species_from_key(species_key)
	var quantity: int = clampi(int(quantity_text) if quantity_text != "" else 4, 1, CATCH_CARD_MAX_DRAW)
	var multiplier: int = max(1, int(multiplier_text) if multiplier_text != "" else 1)
	call_deferred("_run_catch_preview", species, quantity, multiplier)


func _schedule_fan_preview(raw: String) -> bool:
	var compact := raw.replace("-", "").replace("_", "")
	if compact in ["cardgallery", "gallery", "cardstyles", "cardedges", "edges"]:
		call_deferred("_run_card_gallery")
		return true
	if compact in ["fanlab", "fans", "fanpreview", "cardfan", "cardfans"]:
		call_deferred("_run_fan_lab_preview", "")
		return true
	if compact.begins_with("fan"):
		var variant := compact.trim_prefix("fan")
		if variant in ["a", "b", "c", "d"]:
			call_deferred("_run_fan_lab_preview", variant)
			return true
	return false


func _schedule_treasure_preview(raw: String) -> bool:
	var compact := raw.replace("-", "").replace("_", "")
	match compact:
		"treasure100", "cash100", "gold100", "loot100":
			call_deferred("_run_treasure_preview", TREASURE_KIND_CASH, 100)
			return true
		"treasure200", "cash200", "gold200", "loot200":
			call_deferred("_run_treasure_preview", TREASURE_KIND_CASH, 200)
			return true
		"treasurenight1", "night1", "paidnight", "paidnight1", "extra1":
			call_deferred("_run_treasure_preview", TREASURE_KIND_PAID_NIGHT, 0)
			return true
	return false


func _schedule_finder_preview(raw: String) -> bool:
	var compact := raw.replace("-", "").replace("_", "")
	if compact.begins_with("fishfinder"):
		compact = compact.trim_prefix("fishfinder")
	elif compact.begins_with("finder"):
		compact = compact.trim_prefix("finder")
	else:
		return false

	var species_key := ""
	var casts_text := ""
	for i in range(compact.length()):
		var ch := compact.substr(i, 1)
		if ch >= "0" and ch <= "9":
			casts_text += ch
		else:
			species_key += ch

	var species := _species_from_key(species_key)
	var casts: int = clampi(int(casts_text) if casts_text != "" else 3, 1, CATCH_CARD_MAX_DRAW)
	call_deferred("_run_finder_preview", species, casts)
	return true


func _run_catch_preview(species: String, quantity: int, multiplier: int) -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false
	await get_tree().create_timer(0.35).timeout
	_show_catch_card_fan(species, quantity, multiplier)


func _run_finder_preview(species: String, casts: int) -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false
	await get_tree().create_timer(0.35).timeout
	_show_finder_card_fan(species, casts)


func _run_fan_lab_preview(variant_key: String = "") -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false
	await get_tree().create_timer(0.35).timeout

	var variants: Array = ["a", "b", "c", "d"]
	var normalized := variant_key.to_lower()
	if normalized in variants:
		variants = [normalized]

	for i in range(variants.size()):
		var config := _catch_fan_preview_variant(str(variants[i]))
		_show_fan_preview_variant(config)
		if i < variants.size() - 1:
			await get_tree().create_timer(_catch_fan_sequence_seconds(config)).timeout


func _run_treasure_preview(kind: String, value: int) -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false
	await get_tree().create_timer(0.35).timeout
	_show_treasure_card_fan({"treasure_type": kind, "value": value})


func _apply_safe_area_inset() -> void:
	var screen_size := DisplayServer.screen_get_size()
	if screen_size.x <= 0 or screen_size.y <= 0:
		return
	var safe := DisplayServer.get_display_safe_area()
	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size.x <= 0 or viewport_size.y <= 0:
		return
	var left_pixels := maxi(safe.position.x, 0)
	var top_pixels := maxi(safe.position.y, 0)
	var right_pixels := maxi(screen_size.x - safe.position.x - safe.size.x, 0)
	var bottom_pixels := maxi(screen_size.y - safe.position.y - safe.size.y, 0)
	var left_inset := int(round((float(left_pixels) / float(screen_size.x)) * viewport_size.x))
	var top_inset := int(round((float(top_pixels) / float(screen_size.y)) * viewport_size.y))
	var right_inset := int(round((float(right_pixels) / float(screen_size.x)) * viewport_size.x))
	var bottom_inset := int(round((float(bottom_pixels) / float(screen_size.y)) * viewport_size.y))
	left_inset = clampi(left_inset, 0, int(viewport_size.x * 0.20))
	top_inset = clampi(top_inset, 0, int(viewport_size.y * 0.20))
	right_inset = clampi(right_inset, 0, int(viewport_size.x * 0.20))
	bottom_inset = clampi(bottom_inset, 0, int(viewport_size.y * 0.20))
	if ui.has("root_margin"):
		var root: MarginContainer = ui["root_margin"]
		root.add_theme_constant_override("margin_left", 14 + left_inset)
		root.add_theme_constant_override("margin_top", top_inset)
		root.add_theme_constant_override("margin_right", 14 + right_inset)
		root.add_theme_constant_override("margin_bottom", 12 + bottom_inset)
	if ui.has("top_safe_fill"):
		var fill: ColorRect = ui["top_safe_fill"]
		fill.offset_bottom = float(top_inset)


var title_letters: Array = []
var title_ebb_active: bool = false
var title_ebb_time: float = 0.0


const BOARD_LONG_PRESS_SECONDS := 0.4
var board_press_cell := Vector2i(-1, -1)
var board_press_time := 0.0
var board_long_fired := false
var board_long_pressed := false


func _process(delta: float) -> void:
	if game_started and not game_over:
		_stat_add("elapsed_seconds", delta)
	board_fx_time += delta
	if ui.has("board_wrap"):
		_update_board_presence_fx()
	if action_buttons.has("end_day"):
		_update_end_day_prompt(delta)
	_update_audio(delta)
	if board_press_cell.x >= 0 and not board_long_fired and not game_over and active_tray == "":
		board_press_time += delta
		if board_press_time >= BOARD_LONG_PRESS_SECONDS:
			board_long_fired = true
			board_long_pressed = _show_board_card_tooltip(board_press_cell)
	if title_ebb_active and ui.has("start_overlay") and (ui["start_overlay"] as Control).visible:
		_update_title_ebb(delta)


func _build_audio() -> void:
	audio_calm = _make_loop_player(BG_CALM_STREAM, 0.0)
	audio_waves = _make_loop_player(BG_WAVES_STREAM, AUDIO_SILENT_DB)
	audio_birds = _make_loop_player(BG_BIRDS_STREAM, AUDIO_SILENT_DB)
	audio_reel = _make_one_shot_player(SOUND_REEL_STREAM)
	audio_bonk = _make_one_shot_player(SOUND_BONK_STREAM)
	audio_catch = _make_one_shot_player(SOUND_CATCH_STREAM)
	_build_plonk_players()


# A short synthesized "pluck" used for the ascending per-card catch ticks. Built in
# code so there is no asset to ship; pitch_scale shifts it up the scale per card.
func _build_plonk_stream() -> AudioStreamWAV:
	var rate := 44100
	var sample_count := int(rate * 0.2)
	var base_freq := 392.0
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	for i in range(sample_count):
		var t := float(i) / float(rate)
		var attack := clampf(t / 0.003, 0.0, 1.0)
		var env := exp(-t * 24.0) * attack
		var wave := sin(TAU * base_freq * t) * 0.72 + sin(TAU * base_freq * 2.0 * t) * 0.16
		data.encode_s16(i * 2, int(clampf(wave * env, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.stereo = false
	stream.data = data
	return stream


func _build_plonk_players() -> void:
	var stream := _build_plonk_stream()
	for i in range(6):
		var p := AudioStreamPlayer.new()
		p.stream = stream
		p.volume_db = -4.0
		p.autoplay = false
		add_child(p)
		plonk_players.append(p)


# Plays the pluck pitched up the pentatonic ramp for the index-th card in a cascade,
# a little louder each step, so a bigger catch climbs higher and prouder.
func _play_catch_plonk(index: int) -> void:
	if plonk_players.is_empty():
		return
	var semis := float(PLONK_SEMITONES[clampi(index, 0, PLONK_SEMITONES.size() - 1)])
	var player := plonk_players[plonk_index % plonk_players.size()]
	plonk_index += 1
	player.pitch_scale = clampf(pow(2.0, semis / 12.0), 1.0, 4.0)
	player.volume_db = lerpf(-5.0, 1.5, clampf(float(index) / 6.0, 0.0, 1.0))
	player.play()


func _make_one_shot_player(stream: AudioStream) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	var s := stream.duplicate() as AudioStream
	if s is AudioStreamMP3:
		(s as AudioStreamMP3).loop = false
	player.stream = s
	player.volume_db = 0.0
	player.autoplay = false
	add_child(player)
	return player


func _play_cast_outcome(outcome: String) -> void:
	if audio_reel == null:
		return
	cast_audio_token += 1
	var token := cast_audio_token
	audio_reel.stop()
	audio_bonk.stop()
	audio_catch.stop()
	if outcome == "empty":
		audio_reel.play(0.0)
		await get_tree().create_timer(1.0).timeout
		if token != cast_audio_token:
			return
		audio_reel.stop()
		audio_bonk.play()
	elif outcome == "catch":
		var dur := rng.randf_range(1.0, 2.5)
		var stream_len := audio_reel.stream.get_length() if audio_reel.stream else 0.0
		var start := 0.0
		if stream_len > dur:
			start = rng.randf_range(0.0, stream_len - dur)
		audio_reel.play(start)
		await get_tree().create_timer(dur).timeout
		if token != cast_audio_token:
			return
		audio_reel.stop()
		audio_catch.play()


func _make_loop_player(stream: AudioStream, start_db: float) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	var s := stream.duplicate() as AudioStream
	if s is AudioStreamMP3:
		(s as AudioStreamMP3).loop = true
	player.stream = s
	player.volume_db = start_db
	player.autoplay = false
	add_child(player)
	player.play()
	return player


func _update_audio(delta: float) -> void:
	if audio_calm == null:
		return

	var on_start_screen := ui.has("start_overlay") and (ui["start_overlay"] as Control).visible
	var weather_name := str(current_weather.get("name", "Clear")) if not current_weather.is_empty() else "Clear"
	var want_calm := on_start_screen or weather_name == "Clear"

	var calm_target := 1.0 if want_calm else 0.0
	var waves_target := 0.0 if want_calm else 1.0
	var step := delta / WEATHER_AUDIO_CROSSFADE_SECONDS
	calm_current_volume = move_toward(calm_current_volume, calm_target, step)
	waves_current_volume = move_toward(waves_current_volume, waves_target, step)
	audio_calm.volume_db = AUDIO_SILENT_DB if calm_current_volume <= 0.001 else linear_to_db(calm_current_volume)
	audio_waves.volume_db = AUDIO_SILENT_DB if waves_current_volume <= 0.001 else linear_to_db(waves_current_volume)

	birds_phase_time += delta
	if birds_phase_time >= BIRDS_PHASE_SECONDS:
		birds_phase_time = fmod(birds_phase_time, BIRDS_PHASE_SECONDS)
		birds_previous_volume = BIRDS_VOLUME_PHASES[birds_phase_index]
		birds_phase_index = (birds_phase_index + 1) % BIRDS_VOLUME_PHASES.size()
	var birds_target: float = BIRDS_VOLUME_PHASES[birds_phase_index]
	var fade_t := clampf(birds_phase_time / BIRDS_TRANSITION_SECONDS, 0.0, 1.0)
	var eased := smoothstep(0.0, 1.0, fade_t)
	var birds_v := lerpf(birds_previous_volume, birds_target, eased)
	audio_birds.volume_db = AUDIO_SILENT_DB if birds_v <= 0.001 else linear_to_db(birds_v)


func _update_end_day_prompt(delta: float) -> void:
	var b: Button = action_buttons["end_day"]
	if not b.visible or b.disabled or not bool(b.get_meta("action_prompt", false)):
		return
	end_day_prompt_time += delta
	var pulse := 0.68 + 0.32 * ((sin(end_day_prompt_time * PI * 3.0) + 1.0) * 0.5)
	b.modulate = Color(1, 1, 1, pulse)


# ────────────────────────────────────────────────────────────────────────
# UI construction
# ────────────────────────────────────────────────────────────────────────

func _build_ui() -> void:
	var background := TextureRect.new()
	background.texture = GAME_BG_TEXTURE
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	add_child(background)

	var background_wash := ColorRect.new()
	background_wash.color = _with_alpha(BG_BODY, 0.54)
	background_wash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_wash.anchor_right = 1.0
	background_wash.anchor_bottom = 1.0
	add_child(background_wash)

	var top_safe_fill := ColorRect.new()
	top_safe_fill.color = Color(0, 0, 0, 1)
	top_safe_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_safe_fill.anchor_left = 0.0
	top_safe_fill.anchor_right = 1.0
	top_safe_fill.anchor_top = 0.0
	top_safe_fill.anchor_bottom = 0.0
	top_safe_fill.offset_top = 0
	top_safe_fill.offset_bottom = 0
	top_safe_fill.z_index = 50
	add_child(top_safe_fill)
	ui["top_safe_fill"] = top_safe_fill

	var root := MarginContainer.new()
	root.anchor_right = 1.0
	root.anchor_bottom = 1.0
	root.add_theme_constant_override("margin_left", 14)
	root.add_theme_constant_override("margin_top", 0)
	root.add_theme_constant_override("margin_right", 14)
	root.add_theme_constant_override("margin_bottom", 12)
	add_child(root)
	ui["root_margin"] = root

	var screen := VBoxContainer.new()
	screen.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen.add_theme_constant_override("separation", 10)
	root.add_child(screen)

	_build_table_layout(screen)
	_build_sell_modal()
	_build_rules_modal()
	_build_tray_overlay()
	_build_catch_card_overlay()
	_build_card_tooltip_overlay()
	_build_game_over_screen()
	_build_high_scores_screen()
	_build_deck_training_screen()


func _build_table_layout(parent: Container) -> void:
	# Board gets the full vertical space: no top header, no bottom log strip flanking it.
	var main := HBoxContainer.new()
	main.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main.add_theme_constant_override("separation", 24)
	parent.add_child(main)

	_build_left_table_rail(main)
	_build_center_table(main)
	_build_command_rail(main)


func _build_table_header(parent: Container) -> void:
	var header := _panel_lifted(Color("#071829"), BORDER_FRAME, 1, 6, 5)
	header.custom_minimum_size = Vector2(0, TABLE_HEADER_HEIGHT)
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(header)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 12)
	pad.add_theme_constant_override("margin_right", 12)
	pad.add_theme_constant_override("margin_top", 10)
	pad.add_theme_constant_override("margin_bottom", 10)
	header.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	pad.add_child(row)

	var brand := VBoxContainer.new()
	brand.custom_minimum_size = Vector2(240, 0)
	brand.size_flags_vertical = Control.SIZE_EXPAND_FILL
	brand.alignment = BoxContainer.ALIGNMENT_CENTER
	brand.add_theme_constant_override("separation", 1)
	row.add_child(brand)

	var title := _label("RAIDER BAY", 38, GOLD, HORIZONTAL_ALIGNMENT_LEFT)
	title.add_theme_constant_override("outline_size", 3)
	title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.72))
	brand.add_child(title)
	var subtitle := _label("CARD-TABLE FISHING", 16, TEXT_MUTED, HORIZONTAL_ALIGNMENT_LEFT)
	brand.add_child(subtitle)

	var stats := GridContainer.new()
	stats.columns = 5
	stats.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stats.add_theme_constant_override("h_separation", 8)
	stats.add_theme_constant_override("v_separation", 7)
	row.add_child(stats)

	ui["stat_day"] = _stat_card("DAY", "1/%d" % MAX_DAYS, CYAN)
	ui["stat_funds"] = _stat_card("FUNDS", "$0", GOLD)
	ui["stat_moves"] = _stat_card("MOVES", "0", BORDER_HI)
	ui["stat_casts"] = _stat_card("CASTS", "0", GREEN)
	ui["stat_finds"] = _stat_card("FINDS", "0", PURPLE)
	for key in ["stat_day", "stat_funds", "stat_moves", "stat_casts", "stat_finds"]:
		stats.add_child(ui[key])

	var forecast_panel := _panel(Color("#0a2132"), BORDER_DARK, 1, 5)
	forecast_panel.custom_minimum_size = Vector2(356, 0)
	forecast_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_child(forecast_panel)

	var forecast_pad := MarginContainer.new()
	forecast_pad.add_theme_constant_override("margin_left", 9)
	forecast_pad.add_theme_constant_override("margin_right", 9)
	forecast_pad.add_theme_constant_override("margin_top", 7)
	forecast_pad.add_theme_constant_override("margin_bottom", 7)
	forecast_panel.add_child(forecast_pad)

	var forecast_col := VBoxContainer.new()
	forecast_col.add_theme_constant_override("separation", 6)
	forecast_pad.add_child(forecast_col)
	forecast_col.add_child(_label("WEATHER DECK", 14, TEXT_MUTED))

	ui["forecast_chips"] = HBoxContainer.new()
	ui["forecast_chips"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["forecast_chips"].add_theme_constant_override("separation", 6)
	forecast_col.add_child(ui["forecast_chips"])


func _build_left_table_rail(parent: Container) -> void:
	var rail := _bare_panel()
	rail.custom_minimum_size = Vector2(TABLE_SIDE_WIDTH, 0)
	rail.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	rail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(rail)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 12)
	pad.add_theme_constant_override("margin_right", 12)
	pad.add_theme_constant_override("margin_top", 12)
	pad.add_theme_constant_override("margin_bottom", 12)
	rail.add_child(pad)

	# Five status counter-buttons, stacked and sharing the full rail height.
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 16)
	pad.add_child(col)

	col.add_child(_counter_button("stat_day", ICON_DAY_TEXTURE, "DAY", Color("#8ad5f3"), Callable()))
	col.add_child(_counter_button("stat_funds", ICON_FUNDS_TEXTURE, "FUNDS", Color("#ffba00"), _on_funds_pressed))
	col.add_child(_counter_button("stat_moves", ICON_MOVES_TEXTURE, "MOVES", Color("#ff6161"), _request_end_day))
	col.add_child(_counter_button("stat_finds", ICON_FIND_FISH_TEXTURE, "FIND FISH", Color("#c889ff"), _find_fish))
	col.add_child(_counter_button("stat_casts", ICON_CAST_TEXTURE, "CAST", Color("#84ed72"), _cast))


func _build_center_table(parent: Container) -> void:
	var table := _bare_panel()
	table.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	table.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(table)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 10)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 10)
	pad.add_theme_constant_override("margin_bottom", 10)
	table.add_child(pad)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pad.add_child(center)
	_build_board(center)


func _build_command_rail(parent: Container) -> void:
	var rail := _bare_panel()
	rail.custom_minimum_size = Vector2(TABLE_COMMAND_WIDTH, 0)
	rail.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	rail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(rail)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 12)
	pad.add_theme_constant_override("margin_right", 12)
	pad.add_theme_constant_override("margin_top", 12)
	pad.add_theme_constant_override("margin_bottom", 12)
	rail.add_child(pad)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	pad.add_child(scroll)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 24)
	scroll.add_child(col)

	_build_forecast_card(col)
	_build_action_bar(col)
	_build_market_card(col)
	_build_compact_ship_card(col)
	_build_live_well_card(col)
	_build_radio_card(col)
	_build_log_strip(col)


func _build_forecast_card(parent: Container) -> void:
	var forecast_panel := _bare_panel()
	forecast_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(forecast_panel)

	var forecast_pad := MarginContainer.new()
	forecast_pad.add_theme_constant_override("margin_left", 9)
	forecast_pad.add_theme_constant_override("margin_right", 9)
	forecast_pad.add_theme_constant_override("margin_top", 7)
	forecast_pad.add_theme_constant_override("margin_bottom", 7)
	forecast_panel.add_child(forecast_pad)

	var forecast_col := VBoxContainer.new()
	forecast_col.add_theme_constant_override("separation", 6)
	forecast_pad.add_child(forecast_col)
	forecast_col.add_child(_label("WEATHER DECK", 14, TEXT_MUTED))

	ui["forecast_chips"] = HBoxContainer.new()
	ui["forecast_chips"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["forecast_chips"].add_theme_constant_override("separation", 6)
	forecast_col.add_child(ui["forecast_chips"])


func _build_market_card(parent: Container) -> void:
	var card := _bare_panel()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 9)
	pad.add_theme_constant_override("margin_right", 9)
	pad.add_theme_constant_override("margin_top", 9)
	pad.add_theme_constant_override("margin_bottom", 9)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 7)
	pad.add_child(col)
	col.add_child(_label("FISH MARKET", 14, GOLD))
	ui["top_market_rows"] = VBoxContainer.new()
	ui["top_market_rows"].add_theme_constant_override("separation", 5)
	col.add_child(ui["top_market_rows"])


func _build_compact_ship_card(parent: Container) -> void:
	var card := _bare_panel()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 9)
	pad.add_theme_constant_override("margin_right", 9)
	pad.add_theme_constant_override("margin_top", 9)
	pad.add_theme_constant_override("margin_bottom", 9)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 7)
	pad.add_child(col)

	col.add_child(_label("SHIP CARDS", 15, PURPLE))

	ui["compact_ship_cards"] = GridContainer.new()
	ui["compact_ship_cards"].columns = 1
	ui["compact_ship_cards"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["compact_ship_cards"].add_theme_constant_override("v_separation", 5)
	col.add_child(ui["compact_ship_cards"])


func _build_live_well_card(parent: Container) -> void:
	var card := _bare_panel()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 9)
	pad.add_theme_constant_override("margin_right", 9)
	pad.add_theme_constant_override("margin_top", 9)
	pad.add_theme_constant_override("margin_bottom", 9)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 7)
	pad.add_child(col)
	col.add_child(_label("CATCH HAND", 14, GREEN))

	ui["live_well_lines"] = VBoxContainer.new()
	ui["live_well_lines"].add_theme_constant_override("separation", 4)
	col.add_child(ui["live_well_lines"])

	ui["live_well_status"] = _label("Empty", FONT_SMALL, TEXT_MUTED)
	ui["live_well_status"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["live_well_status"])

	ui["live_well_sell"] = _action_button("SELL FISH", "sell", _sell_catch)
	ui["live_well_sell"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["live_well_sell"])


func _build_radio_card(parent: Container) -> void:
	var card := _bare_panel()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 9)
	pad.add_theme_constant_override("margin_right", 9)
	pad.add_theme_constant_override("margin_top", 9)
	pad.add_theme_constant_override("margin_bottom", 9)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 7)
	pad.add_child(col)

	var controls := HBoxContainer.new()
	controls.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	controls.add_theme_constant_override("separation", 7)
	col.add_child(controls)

	var mute_btn := _tactile_button("MUTE", 0, 40, BG_PANEL_LIGHT, CYAN_DEEP, TEXT_PRIMARY)
	mute_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mute_btn.pressed.connect(_toggle_audio_mute)
	controls.add_child(mute_btn)
	ui["mute_button"] = mute_btn

	var rules_btn := _tactile_button("RULES", 0, 40, BG_PANEL_LIGHT, GOLD_DEEP, TEXT_PRIMARY)
	rules_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rules_btn.pressed.connect(_show_rules_modal)
	controls.add_child(rules_btn)

	ui["radio_lines"] = VBoxContainer.new()
	ui["radio_lines"].add_theme_constant_override("separation", 4)
	col.add_child(ui["radio_lines"])


func _build_start_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 200
	add_child(overlay)
	ui["start_overlay"] = overlay

	var bg := ColorRect.new()
	bg.color = Color("#0b1a3a")
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(bg)
	overlay.add_child(bg)

	var vp := get_viewport().get_visible_rect().size
	var cx := vp.x * 0.5

	var title_layer := Control.new()
	title_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(title_layer)
	overlay.add_child(title_layer)
	_build_arched_title(title_layer, "RAIDER BAY", cx, vp.y * 0.30, 122)

	var btn_w := 440.0
	var btn_gap := 44.0
	var btn_y := vp.y * 0.58
	var solo := _pixel_button("SOLO TRIP", CYAN, Color("#15273f"), TEXT_PRIMARY, ICON_ROCKET_FISH_TEXTURE, _on_solo_trip_pressed)
	solo.position = Vector2(cx - btn_w - btn_gap * 0.5, btn_y)
	overlay.add_child(solo)
	var battle := _pixel_button("PIRATE BATTLE", RED, Color("#2b1417"), Color("#ff6b6b"), null, func(): _new_game(true))
	battle.position = Vector2(cx + btn_gap * 0.5, btn_y)
	overlay.add_child(battle)

	var links := HBoxContainer.new()
	links.alignment = BoxContainer.ALIGNMENT_CENTER
	links.add_theme_constant_override("separation", 14)
	links.mouse_filter = Control.MOUSE_FILTER_IGNORE
	links.add_child(_title_link("DECK TRAINING", _show_deck_training))
	links.add_child(_title_link_sep())
	links.add_child(_title_link("HIGH SCORES", _show_high_scores_screen))
	links.add_child(_title_link_sep())
	links.add_child(_title_link("SETTINGS", _show_settings_screen))
	links.add_child(_title_link_sep())
	links.add_child(_title_link("CREDITS", _show_credits_screen))

	var links_wrap := Control.new()
	links_wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	links_wrap.anchor_right = 1.0
	links_wrap.offset_top = vp.y * 0.80
	links_wrap.offset_bottom = vp.y * 0.80 + 40.0
	overlay.add_child(links_wrap)
	var lc := CenterContainer.new()
	lc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(lc)
	links_wrap.add_child(lc)
	lc.add_child(links)

	var chooser := _build_solo_save_chooser()
	overlay.add_child(chooser)
	ui["start_solo_chooser"] = chooser


# Vertical gradient over rendered glyphs, by the glyph's local Y (per-letter, so it stays consistent
# across the arched title). Applied to each title letter's fill Label.
func _title_gradient_material(top: Color, bot: Color, y0: float, y1: float) -> ShaderMaterial:
	var sh := Shader.new()
	sh.code = "shader_type canvas_item;\nuniform vec4 c_top : source_color;\nuniform vec4 c_bot : source_color;\nuniform float y0;\nuniform float y1;\nvarying float v_y;\nvoid vertex() { v_y = VERTEX.y; }\nvoid fragment() {\n\tfloat cov = texture(TEXTURE, UV).a;\n\tfloat t = clamp((v_y - y0) / max(y1 - y0, 1.0), 0.0, 1.0);\n\tCOLOR = vec4(mix(c_top.rgb, c_bot.rgb, t), cov * COLOR.a);\n}"
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("c_top", top)
	mat.set_shader_parameter("c_bot", bot)
	mat.set_shader_parameter("y0", y0)
	mat.set_shader_parameter("y1", y1)
	return mat


func _title_letter(parent: Control, ch: String, center: Vector2, rot: float, font_size: int, cell: Vector2, grad: ShaderMaterial) -> void:
	# Each letter is its own group (so it can pop in and ebb as a unit); inside: drop shadow,
	# dark pixel stroke (fattened outline), and the gradient fill, stacked back-to-front.
	var g := Control.new()
	g.custom_minimum_size = cell
	g.size = cell
	g.pivot_offset = cell * 0.5
	g.position = center - cell * 0.5
	g.rotation_degrees = rot
	g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(g)
	var passes := [
		{"off": Vector2(6, 11), "col": Color("#04091c"), "outline": 0, "grad": false},
		{"off": Vector2.ZERO, "col": Color("#0b1736"), "outline": 6, "grad": false},
		{"off": Vector2.ZERO, "col": Color.WHITE, "outline": 0, "grad": true},
	]
	for p in passes:
		var lbl := Label.new()
		lbl.text = ch
		lbl.add_theme_font_override("font", FONT_BALATRO)
		lbl.add_theme_font_size_override("font_size", font_size)
		lbl.add_theme_color_override("font_color", p["col"])
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var ol := int(p["outline"])
		if ol > 0:
			lbl.add_theme_constant_override("outline_size", ol)
			lbl.add_theme_color_override("font_outline_color", p["col"])
		if bool(p["grad"]):
			lbl.material = grad
		lbl.custom_minimum_size = cell
		lbl.size = cell
		lbl.position = p["off"] as Vector2
		g.add_child(lbl)
	title_letters.append({"node": g, "base_y": g.position.y, "base_rot": rot, "phase": float(title_letters.size()) * 0.55})


func _build_arched_title(parent: Control, text: String, center_x: float, base_y: float, font_size: int) -> void:
	title_letters.clear()
	var line_h := float(font_size) * 1.25
	var grad := _title_gradient_material(Color("#5b8fd6"), Color("#d6e8ff"), line_h * 0.26, line_h * 0.82)
	var advances: Array[float] = []
	var total := 0.0
	for i in range(text.length()):
		var cw := FONT_BALATRO.get_char_size(text.unicode_at(i), font_size).x
		advances.append(cw)
		total += cw
	var half := maxf(total * 0.5, 1.0)
	var arch_depth := float(font_size) * 0.5
	var arch_tilt := 9.0
	var x := center_x - total * 0.5
	for i in range(text.length()):
		var cw: float = advances[i]
		var cc := x + cw * 0.5
		x += cw
		if text[i] == " ":
			continue
		var xn := (cc - center_x) / half
		var y_off := arch_depth * xn * xn
		_title_letter(parent, text[i], Vector2(cc, base_y + y_off), arch_tilt * xn, font_size, Vector2(cw, line_h), grad)


# Janky pop-twist intro: each letter snaps in from tiny + spun, staggered one at a time.
func _play_title_intro() -> void:
	title_ebb_active = false
	title_ebb_time = 0.0
	for i in range(title_letters.size()):
		var e = title_letters[i]
		var g: Control = e["node"]
		if not is_instance_valid(g):
			continue
		var base_rot: float = e["base_rot"]
		var dir := 1.0 if i % 2 == 0 else -1.0
		var old: Tween = g.get_meta("intro_tween", null) as Tween
		if old:
			old.kill()
		g.position.y = float(e["base_y"])
		g.scale = Vector2(0.04, 0.04)
		g.rotation_degrees = base_rot + dir * randf_range(30.0, 60.0)
		g.modulate = Color(1, 1, 1, 0)
		var t := g.create_tween()
		g.set_meta("intro_tween", t)
		t.tween_interval(float(i) * 0.08)
		t.tween_property(g, "modulate:a", 1.0, 0.05)
		t.parallel().tween_property(g, "scale", Vector2(1.2, 1.2), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.parallel().tween_property(g, "rotation_degrees", base_rot, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.tween_property(g, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var settle := create_tween()
	settle.tween_interval(float(title_letters.size()) * 0.08 + 0.30)
	settle.tween_callback(func(): title_ebb_active = true)


# Once in, the letters bob and sway on a per-letter phase so the title undulates like water.
func _update_title_ebb(delta: float) -> void:
	title_ebb_time += delta
	# Ease the sway in from zero so it grows smoothly out of the intro (no snap onto the wave).
	var ramp := smoothstep(0.0, 0.8, title_ebb_time)
	var amp := 7.0 * ramp
	var rot_amp := 2.2 * ramp
	var speed := 1.6
	for e in title_letters:
		var g: Control = e["node"]
		if not is_instance_valid(g):
			continue
		var ph: float = e["phase"]
		g.position.y = float(e["base_y"]) + amp * sin(title_ebb_time * speed + ph)
		g.rotation_degrees = float(e["base_rot"]) + rot_amp * sin(title_ebb_time * speed + ph + 0.6)


func _pixel_button(text: String, accent: Color, fill: Color, text_color: Color, icon: Texture2D, on_pressed: Callable) -> Control:
	var bw := 440.0
	var bh := 92.0
	var card := Control.new()
	card.custom_minimum_size = Vector2(bw, bh)
	card.size = Vector2(bw, bh)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_gallery_chunky_rrect(card, 7.0, 12.0, bw, bh, Color(0, 0, 0, 0.40), 2, 4)
	_gallery_chunky_rrect(card, 0.0, 0.0, bw, bh, accent, 2, 4)
	_gallery_chunky_rrect(card, 3.0, 3.0, bw - 6.0, bh - 6.0, fill, 2, 4)
	if icon != null:
		var ic := TextureRect.new()
		ic.texture = icon
		ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ic.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ic.position = Vector2(22, (bh - 56.0) * 0.5)
		ic.size = Vector2(56, 56)
		card.add_child(ic)
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_override("font", FONT_BALATRO)
	lbl.add_theme_font_size_override("font_size", 34)
	lbl.add_theme_color_override("font_color", text_color)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(lbl)
	lbl.offset_left = 70.0 if icon != null else 22.0
	lbl.offset_right = -22.0
	card.add_child(lbl)
	var btn := Button.new()
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_anchor_fill(btn)
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		btn.add_theme_stylebox_override(st, _transparent_style())
	btn.pressed.connect(on_pressed)
	card.add_child(btn)
	return card


func _title_link(text: String, on_pressed: Callable) -> Button:
	var b := Button.new()
	b.flat = true
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_override("font", FONT_BALATRO)
	b.add_theme_font_size_override("font_size", 22)
	b.add_theme_color_override("font_color", _with_alpha(CYAN, 0.82))
	b.add_theme_color_override("font_hover_color", TEXT_PRIMARY)
	b.add_theme_color_override("font_pressed_color", CYAN)
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		b.add_theme_stylebox_override(st, _transparent_style())
	b.pressed.connect(on_pressed)
	return b


func _title_link_sep() -> Control:
	# A drawn dot rather than a "·" glyph, so the separator never depends on font coverage.
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(16, 30)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var dot := ColorRect.new()
	dot.color = _with_alpha(TEXT_DIM, 0.7)
	dot.anchor_left = 0.5
	dot.anchor_right = 0.5
	dot.anchor_top = 0.5
	dot.anchor_bottom = 0.5
	dot.offset_left = -3.0
	dot.offset_right = 3.0
	dot.offset_top = -3.0
	dot.offset_bottom = 3.0
	dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrap.add_child(dot)
	return wrap


func _show_info_overlay(title_text: String, body_text: String) -> void:
	if ui.has("info_overlay") and is_instance_valid(ui["info_overlay"]):
		(ui["info_overlay"] as Control).queue_free()
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 260
	add_child(overlay)
	ui["info_overlay"] = overlay
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.5)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_anchor_fill(shade)
	overlay.add_child(shade)
	var cc := CenterContainer.new()
	cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(cc)
	overlay.add_child(cc)
	var panel := _panel_lifted(Color("#0a1730"), BORDER_FRAME, 2, 6, 10)
	panel.custom_minimum_size = Vector2(540, 0)
	cc.add_child(panel)
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 30)
	pad.add_theme_constant_override("margin_right", 30)
	pad.add_theme_constant_override("margin_top", 26)
	pad.add_theme_constant_override("margin_bottom", 26)
	panel.add_child(pad)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 18)
	pad.add_child(col)
	col.add_child(_label(title_text, 34, CYAN, HORIZONTAL_ALIGNMENT_CENTER))
	var body := _label(body_text, 18, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(body)
	var close := _tactile_button("CLOSE", 0, 48, BG_PANEL, BORDER_HI, TEXT_PRIMARY)
	close.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close.pressed.connect(func(): overlay.queue_free())
	col.add_child(close)


# Yes/no confirm in the pixel-modal style (clone of _show_info_overlay with two buttons).
func _show_confirm_overlay(title_text: String, body_text: String, confirm_label: String, on_confirm: Callable) -> void:
	if ui.has("info_overlay") and is_instance_valid(ui["info_overlay"]):
		(ui["info_overlay"] as Control).queue_free()
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 262
	add_child(overlay)
	ui["info_overlay"] = overlay
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.55)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_anchor_fill(shade)
	overlay.add_child(shade)
	var cc := CenterContainer.new()
	cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(cc)
	overlay.add_child(cc)
	var panel := _panel_lifted(Color("#0a1730"), BORDER_FRAME, 2, 6, 10)
	panel.custom_minimum_size = Vector2(520, 0)
	cc.add_child(panel)
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 30)
	pad.add_theme_constant_override("margin_right", 30)
	pad.add_theme_constant_override("margin_top", 26)
	pad.add_theme_constant_override("margin_bottom", 26)
	panel.add_child(pad)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 18)
	pad.add_child(col)
	col.add_child(_label(title_text, 30, GOLD, HORIZONTAL_ALIGNMENT_CENTER))
	var body := _label(body_text, 18, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(body)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 12)
	col.add_child(row)
	var cancel := _tactile_button("CANCEL", 130, 48, BG_PANEL_LIGHT, BORDER_FRAME, TEXT_MUTED)
	cancel.pressed.connect(func(): overlay.queue_free())
	row.add_child(cancel)
	var confirm := _tactile_button(confirm_label, 130, 48, GREEN_DEEP, GOLD_DEEP, TEXT_PRIMARY)
	confirm.pressed.connect(func():
		overlay.queue_free()
		on_confirm.call())
	row.add_child(confirm)


# The MOVES/END-DAY button: confirm first if the player still has actions to spend.
func _request_end_day() -> void:
	if game_over or active_tray != "":
		return
	if moves_remaining > 0 or casts_remaining > 0 or finds_remaining > 0:
		_show_confirm_overlay("END YOUR DAY?", "You still have moves, casts, or finds left. Are you sure you want to end your day?", "END DAY", _end_day)
	else:
		_end_day()


func _show_settings_screen() -> void:
	_show_info_overlay("SETTINGS", "Settings are coming soon — audio, controls, and display options will live here.")


func _show_credits_screen() -> void:
	_show_info_overlay("CREDITS", "RAIDER BAY\n\nA Superfun joint, built in Godot.")


func _show_start_screen() -> void:
	_hide_game_over_screen()
	if ui.has("start_solo_chooser"):
		(ui["start_solo_chooser"] as Control).visible = false
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = true
	_play_title_intro()


func _hide_start_screen() -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false


func _on_solo_trip_pressed() -> void:
	if _has_unfinished_solo_save():
		_show_solo_save_chooser()
	else:
		_new_game(false)


func _show_solo_save_chooser() -> void:
	if ui.has("start_solo_chooser"):
		(ui["start_solo_chooser"] as Control).visible = true


func _hide_solo_save_chooser() -> void:
	if ui.has("start_solo_chooser"):
		(ui["start_solo_chooser"] as Control).visible = false


func _resume_solo_game() -> void:
	if _has_unfinished_solo_save() and _load_game():
		return
	_hide_solo_save_chooser()
	_new_game(false)


func _start_screen_button(texture: Texture2D, text: String, top_ratio: float, pressed: Callable, text_y_offset: int = 0) -> Button:
	var b := Button.new()
	b.text = ""
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.anchor_left = 0.016
	b.anchor_right = 0.984
	b.anchor_top = top_ratio
	b.anchor_bottom = top_ratio + 0.10285
	b.offset_left = 0
	b.offset_right = 0
	b.offset_top = 0
	b.offset_bottom = 0
	b.pressed.connect(pressed)
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		b.add_theme_stylebox_override(state, _transparent_style())

	var art := TextureRect.new()
	art.texture = texture
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_SCALE
	art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(art)
	b.add_child(art)

	_add_start_button_text(b, text, 50, text_y_offset)
	return b


func _build_solo_save_chooser() -> Control:
	var chooser := Control.new()
	chooser.anchor_right = 1.0
	chooser.anchor_bottom = 1.0
	chooser.mouse_filter = Control.MOUSE_FILTER_STOP
	chooser.visible = false
	chooser.z_index = 10

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.46)
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	chooser.add_child(shade)

	var card := _panel_lifted(Color("#071521"), Color("#9fb8da"), 2, 4, 12)
	card.anchor_left = 0.10
	card.anchor_right = 0.90
	card.anchor_top = 0.55
	card.anchor_bottom = 0.76
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	chooser.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 22)
	pad.add_theme_constant_override("margin_right", 22)
	pad.add_theme_constant_override("margin_top", 18)
	pad.add_theme_constant_override("margin_bottom", 18)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 12)
	pad.add_child(col)

	var prompt := _label("SOLO SAVE FOUND", 31, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	prompt.add_theme_constant_override("shadow_offset_y", 5)
	prompt.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	prompt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(prompt)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 10)
	col.add_child(row)

	var new_trip := _tactile_button("NEW TRIP", 0, 50, BG_PANEL_LIGHT, GOLD_DEEP, TEXT_PRIMARY)
	new_trip.add_theme_font_size_override("font_size", 24)
	new_trip.add_theme_color_override("font_color", TEXT_PRIMARY)
	new_trip.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	new_trip.add_theme_constant_override("shadow_offset_y", 5)
	new_trip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	new_trip.pressed.connect(func(): _new_game(false))
	row.add_child(new_trip)

	var resume := _tactile_button("RESUME GAME", 0, 50, BG_PANEL_LIGHT, CYAN_DEEP, TEXT_PRIMARY)
	resume.add_theme_font_size_override("font_size", 24)
	resume.add_theme_color_override("font_color", TEXT_PRIMARY)
	resume.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	resume.add_theme_constant_override("shadow_offset_y", 5)
	resume.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	resume.pressed.connect(_resume_solo_game)
	row.add_child(resume)

	return chooser


func _add_start_button_text(parent: Control, text: String, size: int, y_offset: int = 0) -> void:
	var shadow := _start_button_label(text, size, Color(0, 0, 0, 0.95))
	_anchor_fill(shadow)
	shadow.offset_top += 5 + y_offset
	shadow.offset_bottom += 5 + y_offset
	parent.add_child(shadow)

	var label := _start_button_label(text, size, TEXT_PRIMARY)
	_anchor_fill(label)
	label.offset_top += y_offset
	label.offset_bottom += y_offset
	parent.add_child(label)


func _start_button_label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", FONT_BALATRO)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _build_top_status(parent: Container) -> void:
	_build_table_header(parent)


func _build_tab_body(parent: Container) -> void:
	var stack := Control.new()
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(stack)

	ui["tab_health"] = _build_health_tab()
	ui["tab_live_well"] = _build_live_well_tab()
	ui["tab_map"] = _build_map_tab()
	ui["tab_upgrades"] = _build_upgrades_tab()
	ui["tab_radio"] = _build_radio_tab()

	for view_key in ["tab_health", "tab_live_well", "tab_map", "tab_upgrades", "tab_radio"]:
		var view: Control = ui[view_key]
		view.anchor_right = 1.0
		view.anchor_bottom = 1.0
		stack.add_child(view)


func _build_bottom_nav(parent: Container) -> void:
	var nav := _panel(BG_NAV, BG_NAV, 0, 0)
	nav.custom_minimum_size = Vector2(0, 120)
	nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(nav)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 18)
	pad.add_theme_constant_override("margin_right", 18)
	pad.add_theme_constant_override("margin_top", 10)
	pad.add_theme_constant_override("margin_bottom", 8)
	nav.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 10)
	pad.add_child(row)

	tab_buttons["health"] = _bottom_nav_button(ICON_HEALTH_TEXTURE, "Boat Health", "health")
	tab_buttons["live_well"] = _bottom_nav_button(ICON_LIVE_WELL_TEXTURE, "Live Well", "live_well")
	tab_buttons["map"] = _bottom_nav_button(ICON_MAP_TEXTURE, "Map", "map")
	tab_buttons["upgrades"] = _bottom_nav_button(ICON_UPGRADES_TEXTURE, "Upgrades", "upgrades")
	tab_buttons["radio"] = _bottom_nav_button(ICON_RADIO_TEXTURE, "Radio Chat", "radio")

	for key in ["health", "live_well", "map", "upgrades", "radio"]:
		row.add_child(tab_buttons[key])


func _build_sell_modal() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 120
	add_child(overlay)
	ui["sell_overlay"] = overlay

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.58)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(backdrop)

	var card := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 2, 5, 12)
	card.anchor_left = 0.5
	card.anchor_right = 0.5
	card.anchor_top = 0.5
	card.anchor_bottom = 0.5
	card.offset_left = -290
	card.offset_right = 290
	card.offset_top = -310
	card.offset_bottom = 310
	overlay.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 18)
	pad.add_theme_constant_override("margin_bottom", 18)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 12)
	pad.add_child(col)

	ui["sell_title"] = _label("Sell Catch", 28, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_title"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["sell_title"])

	var sell_scroll := ScrollContainer.new()
	sell_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sell_scroll.custom_minimum_size = Vector2(0, 330)
	sell_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sell_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(sell_scroll)

	ui["sell_rows"] = VBoxContainer.new()
	ui["sell_rows"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_rows"].add_theme_constant_override("separation", 4)
	sell_scroll.add_child(ui["sell_rows"])

	ui["sell_total"] = _label("", 24, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_total"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["sell_total"])

	ui["sell_result"] = _label("", FONT_BODY, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_result"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["sell_result"])

	ui["sell_action_row"] = HBoxContainer.new()
	ui["sell_action_row"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_action_row"].add_theme_constant_override("separation", 8)
	col.add_child(ui["sell_action_row"])

	ui["sell_confirm"] = _tactile_button("SELL", 0, 54, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	ui["sell_confirm"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_confirm"].pressed.connect(_confirm_sale)
	ui["sell_action_row"].add_child(ui["sell_confirm"])

	ui["sell_haggle"] = _tactile_button("HAGGLE", 0, 54, BG_PANEL_LIGHT, CYAN_DEEP, CYAN)
	ui["sell_haggle"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_haggle"].pressed.connect(_haggle_sale)
	ui["sell_action_row"].add_child(ui["sell_haggle"])

	ui["sell_cancel"] = _tactile_button("CANCEL", 0, 54, BG_PANEL_LIGHT, BORDER_FRAME, TEXT_MUTED)
	ui["sell_cancel"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_cancel"].pressed.connect(_close_sell_modal)
	ui["sell_action_row"].add_child(ui["sell_cancel"])

	ui["sell_ok"] = _tactile_button("OK", 0, 54, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	ui["sell_ok"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_ok"].visible = false
	ui["sell_ok"].pressed.connect(_close_sell_modal)
	col.add_child(ui["sell_ok"])


func _build_rules_modal() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 130
	add_child(overlay)
	ui["rules_overlay"] = overlay

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.72)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(backdrop)

	var card := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 2, 5, 12)
	card.anchor_left = 0.06
	card.anchor_right = 0.94
	card.anchor_top = 0.05
	card.anchor_bottom = 0.95
	overlay.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 18)
	pad.add_theme_constant_override("margin_bottom", 18)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 12)
	pad.add_child(col)

	var title := _label("RAIDER BAY RULES", 26, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(scroll)

	var rules_label := RichTextLabel.new()
	rules_label.bbcode_enabled = true
	rules_label.fit_content = true
	rules_label.scroll_active = false
	rules_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rules_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rules_label.add_theme_color_override("default_color", TEXT_PRIMARY)
	rules_label.add_theme_font_size_override("normal_font_size", FONT_BODY)
	rules_label.add_theme_font_size_override("bold_font_size", FONT_BODY)
	rules_label.text = _rules_text()
	scroll.add_child(rules_label)

	var close_btn := _tactile_button("CLOSE", 0, 50, BG_PANEL_LIGHT, GOLD_DEEP, TEXT_PRIMARY)
	close_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close_btn.pressed.connect(_hide_rules_modal)
	col.add_child(close_btn)


func _show_rules_modal() -> void:
	if ui.has("rules_overlay"):
		(ui["rules_overlay"] as Control).visible = true


func _hide_rules_modal() -> void:
	if ui.has("rules_overlay"):
		(ui["rules_overlay"] as Control).visible = false


func _toggle_audio_mute() -> void:
	audio_muted = not audio_muted
	AudioServer.set_bus_mute(0, audio_muted)
	if ui.has("mute_button"):
		var b: Button = ui["mute_button"]
		b.text = "UNMUTE" if audio_muted else "MUTE"


func _rules_text() -> String:
	var board_size := "%dx%d" % [GRID_COLS, GRID_ROWS]
	return ("[b]OBJECTIVE[/b]\n"
			+ "Catch fish and sell 10 of one species at the docks to claim that fish's trophy. Collect all five trophies "
			+ "(Swordfish, Salmon, Grouper, Halibut, Tuna) before the 14-day season ends. In Pirate Battle the first captain to "
		+ "earn enough trophies — or sink their rival — takes the bay.\n\n"
		+ "[b]THE BAY[/b]\n"
		+ "A " + board_size + " hidden grid of water. The dock is a 3-wide strip below the bottom row. Three depth zones layer the bay:\n"
		+ "  • shallow water (about 1 in 3, with 2 items)\n  • middle water (1 in 2, with 3 items)\n  • deep water (about 2 in 3, with 3 items)\n"
			+ "Deeper water yields bigger fish but punishes mistakes harder. Each non-dock square may hide a fish hole, "
			+ "cash treasure, a Paid Night treasure that grants one extra night at sea, or nothing.\n\n"
		+ "[b]DAILY BUDGETS[/b]\n"
		+ "Each day you spend three resources:\n"
		+ "  • [b]Moves[/b] — orthogonal or diagonal one cell at a time. Diagonals require a working rudder.\n"
		+ "  • [b]Finds[/b] — Fish Finder pings the current square. Reveals fish, empty, or treasure.\n"
		+ "  • [b]Casts[/b] — roll a d6 + nets bonus to catch from the current square. Each square accepts only one cast per day.\n\n"
		+ "[b]CASTING[/b]\n"
		+ "CAST consumes one of your casts AND one of the fish hole's remaining casts. When a hole hits 0, it's depleted and "
		+ "leaves a fish skeleton marker. Casting on a revealed-empty square wastes nothing; finder already proved it dry.\n\n"
		+ "[b]LIVE WELL & SPOILAGE[/b]\n"
		+ "Caught fish sit in your live well. Each day they age by 1. Once age passes your live well capacity, fish spoil at "
		+ "the next END DAY and are lost. The Live Well upgrade buys more days of freshness.\n\n"
		+ "[b]THE DOCKS[/b]\n"
		+ "Touch any of the three dock access squares to enter the docks. From the docks you can:\n"
		+ "  • SELL — empty the live well for market prices. Bonus: 10+ of a single species at once claims that trophy.\n"
		+ "  • HAGGLE — gamble the sale for a better or worse price.\n"
		+ "  • UPGRADE — spend money to permanently improve your boat.\n"
		+ "  • REPAIR — restore damaged systems.\n"
		+ "Leave through the same 3-wide mouth.\n\n"
		+ "[b]UPGRADES (base $50, +$50 per level)[/b]\n"
		+ "  • [b]Motor[/b] — more moves per day\n"
		+ "  • [b]Fish Finder[/b] — more find actions per day\n"
		+ "  • [b]Nets[/b] — bigger d6 catch bonus\n"
		+ "  • [b]Live Well[/b] — fish stay fresh longer\n"
		+ "  • [b]Cannons[/b] — required to ATTACK rivals in Pirate Battle\n"
		+ "  • [b]Defense[/b] — soaks incoming weapon and weather damage\n\n"
		+ "[b]BOAT CONDITION[/b]\n"
		+ "Four systems can be damaged: Hull, Propeller, Rudder, Nets. Effects when broken:\n"
		+ "  • [b]Hull[/b] at 0 — boat sinks, game over.\n"
		+ "  • [b]Propeller[/b] at 0 — half moves per day.\n"
		+ "  • [b]Rudder[/b] at 0 — no diagonals.\n"
		+ "  • [b]Nets[/b] at 0 — no nets bonus on the d6 cast.\n"
		+ "Pay at the docks to repair.\n\n"
		+ "[b]WEATHER[/b]\n"
		+ "Each evening the weather card is drawn: Clear, Storm (strength 2-5), or Hurricane (strength 2-5). Clear nights pass "
		+ "safely. Bad weather rolls a d6: if your roll is below the storm's strength, you take damage equal to the difference "
		+ "to random systems. Docked boats are safe.\n\n"
		+ "[b]COMBAT (PIRATE BATTLE)[/b]\n"
		+ "When both boats are at sea and within 2 squares of each other, the captain with Cannons can ATTACK. Damage rolls "
		+ "against the rival's hull and systems; Defense reduces the hit. Sinking your rival ends the contest.\n\n"
		+ "[b]TROPHIES[/b]\n"
		+ "Selling 10 or more of one species in a single dock visit locks in that trophy. Trophies persist for the rest of the "
		+ "game. The first captain to collect all five wins outright. If the season ends first, highest trophy count wins; "
		+ "ties broken by money.\n\n"
		+ "[b]SEASON END[/b]\n"
		+ "After day 14, any unsold fish at sea spoil. Final score is trophies and bankroll.\n\n"
		+ "[b]CONTROLS[/b]\n"
		+ "Tap adjacent water to move. Tap your own cell to FIND or CAST via the action bar. From a dock-access square tap "
		+ "the dock strip to enter. END DAY when you've used your moves or want to skip the rest.\n\n"
		+ "[b]TIPS[/b]\n"
		+ "  • Deep water is worth the risk only if your hull and live well can handle a setback.\n"
		+ "  • Sell often — spoiled fish are a wasted catch.\n"
		+ "  • In Pirate Battle, watch the rival's distance; Cannons are useless once they dock.\n"
		+ "  • Save a few casts for a known fish hole before END DAY in case weather damage strands you tomorrow.\n")


func _build_health_tab() -> Control:
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 16)
	pad.add_theme_constant_override("margin_bottom", 16)
	scroll.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 8)
	pad.add_child(col)

	ui["health_funds"] = _label("Funds: $0", 24, TEXT_PRIMARY)
	col.add_child(ui["health_funds"])

	for key in CONDITION_KEYS:
		var row := _segment_row(_condition_name(key), CONDITION_MAX, false, key, true)
		col.add_child(row)
		boat_segment_panels["cond_" + key] = row
		repair_tray_rows[key] = row

	return scroll


func _build_map_tab() -> Control:
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 12)
	pad.add_theme_constant_override("margin_right", 12)
	pad.add_theme_constant_override("margin_top", 12)
	pad.add_theme_constant_override("margin_bottom", 12)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 12)
	pad.add_child(col)

	_build_board(col)
	_build_action_bar(col)
	return pad


func _build_upgrades_tab() -> Control:
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 16)
	pad.add_theme_constant_override("margin_bottom", 16)
	scroll.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 8)
	pad.add_child(col)

	ui["upgrade_funds"] = _label("Funds: $0", 24, TEXT_PRIMARY)
	col.add_child(ui["upgrade_funds"])

	ui["upgrade_plan"] = _label("Plan: $0", FONT_BODY, TEXT_MUTED)
	col.add_child(ui["upgrade_plan"])

	var night_panel := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 1, 6, 4)
	night_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(night_panel)

	var night_pad := MarginContainer.new()
	night_pad.add_theme_constant_override("margin_left", 12)
	night_pad.add_theme_constant_override("margin_right", 12)
	night_pad.add_theme_constant_override("margin_top", 10)
	night_pad.add_theme_constant_override("margin_bottom", 10)
	night_panel.add_child(night_pad)

	var night_col := VBoxContainer.new()
	night_col.add_theme_constant_override("separation", 8)
	night_pad.add_child(night_col)

	var night_row := HBoxContainer.new()
	night_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	night_row.add_theme_constant_override("separation", 10)
	night_col.add_child(night_row)

	var night_copy := VBoxContainer.new()
	night_copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	night_copy.add_theme_constant_override("separation", 2)
	night_row.add_child(night_copy)
	night_copy.add_child(_label("Extra Night at Sea", 21, TEXT_PRIMARY))
	night_copy.add_child(_label("$250 each. Extends the season immediately on checkout.", FONT_SMALL, TEXT_MUTED))

	ui["extra_night_count"] = _label("+0", 26, GOLD, HORIZONTAL_ALIGNMENT_RIGHT)
	ui["extra_night_count"].custom_minimum_size = Vector2(62, 0)
	night_row.add_child(ui["extra_night_count"])

	var night_buttons := HBoxContainer.new()
	night_buttons.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	night_buttons.add_theme_constant_override("separation", 8)
	night_col.add_child(night_buttons)

	ui["extra_night_remove"] = _tactile_button("REMOVE NIGHT", 0, 44, BG_PANEL, BORDER_DARK, TEXT_MUTED)
	ui["extra_night_remove"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["extra_night_remove"].pressed.connect(_remove_extra_night_from_cart)
	night_buttons.add_child(ui["extra_night_remove"])

	ui["extra_night_add"] = _tactile_button("ADD NIGHT", 0, 44, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	ui["extra_night_add"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["extra_night_add"].pressed.connect(_add_extra_night_to_cart)
	night_buttons.add_child(ui["extra_night_add"])

	for key in UPGRADE_KEYS:
		var row := _segment_row(_upgrade_name(key), UPGRADE_MAX_LEVEL, true, key, true)
		col.add_child(row)
		boat_segment_panels["up_" + key] = row
		upgrade_tray_rows[key] = row

	var checkout_row := HBoxContainer.new()
	checkout_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	checkout_row.add_theme_constant_override("separation", 10)
	col.add_child(checkout_row)

	ui["upgrade_reset"] = _tactile_button("RESET PLAN", 0, 52, BG_PANEL, BORDER_DARK, TEXT_MUTED)
	ui["upgrade_reset"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_reset"].pressed.connect(_reset_upgrade_plan)
	checkout_row.add_child(ui["upgrade_reset"])

	ui["upgrade_checkout"] = _tactile_button("CHECKOUT", 0, 52, PURPLE_DEEP, PURPLE, TEXT_PRIMARY)
	ui["upgrade_checkout"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_checkout"].pressed.connect(_checkout_upgrade_cart)
	checkout_row.add_child(ui["upgrade_checkout"])

	return scroll


func _build_radio_tab() -> Control:
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 16)
	pad.add_theme_constant_override("margin_bottom", 16)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 12)
	pad.add_child(col)

	col.add_child(_label("Radio Chat", 24, TEXT_PRIMARY))

	var controls_row := HBoxContainer.new()
	controls_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	controls_row.add_theme_constant_override("separation", 10)
	col.add_child(controls_row)

	var mute_btn := _tactile_button("MUTE SOUND", 0, 50, BG_PANEL_LIGHT, CYAN_DEEP, TEXT_PRIMARY)
	mute_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mute_btn.pressed.connect(_toggle_audio_mute)
	controls_row.add_child(mute_btn)
	ui["mute_button"] = mute_btn

	var rules_btn := _tactile_button("RULES", 0, 50, BG_PANEL_LIGHT, GOLD_DEEP, TEXT_PRIMARY)
	rules_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rules_btn.pressed.connect(_show_rules_modal)
	controls_row.add_child(rules_btn)

	var trophies_panel := _panel(BG_PANEL_DARK, BORDER_DARK, 2, 3)
	trophies_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(trophies_panel)

	var trophies_pad := MarginContainer.new()
	trophies_pad.add_theme_constant_override("margin_left", 14)
	trophies_pad.add_theme_constant_override("margin_right", 14)
	trophies_pad.add_theme_constant_override("margin_top", 12)
	trophies_pad.add_theme_constant_override("margin_bottom", 12)
	trophies_panel.add_child(trophies_pad)

	var trophies_col := VBoxContainer.new()
	trophies_col.add_theme_constant_override("separation", 6)
	trophies_pad.add_child(trophies_col)
	trophies_col.add_child(_label("Trophies", FONT_HEADER, CYAN))
	ui["trophy_rows"] = VBoxContainer.new()
	ui["trophy_rows"].add_theme_constant_override("separation", 3)
	trophies_col.add_child(ui["trophy_rows"])

	var log_panel := _panel(BG_PANEL_DARK, BORDER_DARK, 2, 3)
	log_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(log_panel)

	var log_pad := MarginContainer.new()
	log_pad.add_theme_constant_override("margin_left", 14)
	log_pad.add_theme_constant_override("margin_right", 14)
	log_pad.add_theme_constant_override("margin_top", 12)
	log_pad.add_theme_constant_override("margin_bottom", 12)
	log_panel.add_child(log_pad)

	ui["radio_lines"] = VBoxContainer.new()
	ui["radio_lines"].add_theme_constant_override("separation", 5)
	log_pad.add_child(ui["radio_lines"])

	return pad


func _build_title_bar(parent: Container) -> void:
	var bar := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 1, 8, 4)
	bar.custom_minimum_size = Vector2(0, 66)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(bar)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 14)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 6)
	pad.add_theme_constant_override("margin_bottom", 6)
	bar.add_child(pad)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	pad.add_child(row)

	var left_spacer := Control.new()
	left_spacer.custom_minimum_size = Vector2(44, 44)
	left_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(left_spacer)

	var stack := VBoxContainer.new()
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stack.alignment = BoxContainer.ALIGNMENT_CENTER
	stack.add_theme_constant_override("separation", 0)
	row.add_child(stack)

	var title_row := HBoxContainer.new()
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	title_row.add_theme_constant_override("separation", 10)
	stack.add_child(title_row)

	var title := _label("RAIDER BAY", FONT_TITLE, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	title.add_theme_constant_override("outline_size", 2)
	title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.35))
	title_row.add_child(title)

	var sub := _label("FISH DEEP · DOCK RICHER", FONT_SUBTITLE, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stack.add_child(sub)

	var menu_btn := _tactile_button("↻", 44, 44, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	menu_btn.tooltip_text = "New game"
	menu_btn.add_theme_font_size_override("font_size", 20)
	menu_btn.pressed.connect(_show_start_screen)
	row.add_child(menu_btn)


func _build_hud(parent: Container) -> void:
	var hud := _panel_lifted(BG_PANEL, BORDER_FRAME, 1, 7, 4)
	hud.custom_minimum_size = Vector2(0, 96)
	parent.add_child(hud)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 10)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 8)
	pad.add_theme_constant_override("margin_bottom", 8)
	hud.add_child(pad)

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 7)
	pad.add_child(stack)

	# Top: Day · Money · Moves on one row. (Casts and Finds live on the
	# action buttons themselves now.)
	var top := HBoxContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_theme_constant_override("separation", 6)
	stack.add_child(top)
	ui["hud_day"]   = _pill("DAY 1/7",   CYAN)
	ui["hud_money"] = _pill("$ 0",       GOLD)
	ui["hud_moves"] = _pill("MOVES 0/0", BORDER_HI, TEXT_PRIMARY)
	top.add_child(ui["hud_day"])
	top.add_child(ui["hud_money"])
	top.add_child(ui["hud_moves"])

	# Bottom: weather forecast.
	var forecast_row := HBoxContainer.new()
	forecast_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	forecast_row.add_theme_constant_override("separation", 6)
	stack.add_child(forecast_row)

	ui["forecast_label"] = _label("TONIGHT", FONT_SMALL, TEXT_MUTED)
	ui["forecast_label"].size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	forecast_row.add_child(ui["forecast_label"])

	ui["forecast_chips"] = HBoxContainer.new()
	ui["forecast_chips"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["forecast_chips"].add_theme_constant_override("separation", 4)
	forecast_row.add_child(ui["forecast_chips"])


func _build_board(parent: Container) -> void:
	var board_wrap := Control.new()
	board_wrap.custom_minimum_size = Vector2(BOARD_WRAP_WIDTH, BOARD_WRAP_HEIGHT)
	board_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	board_wrap.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	parent.add_child(board_wrap)
	ui["board_wrap"] = board_wrap

	var pad := MarginContainer.new()
	pad.anchor_right = 1.0
	pad.anchor_bottom = 1.0
	pad.add_theme_constant_override("margin_left", 0)
	pad.add_theme_constant_override("margin_right", 0)
	pad.add_theme_constant_override("margin_top", 0)
	pad.add_theme_constant_override("margin_bottom", 0)
	board_wrap.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", BOARD_CARD_GAP)
	pad.add_child(col)

	var grid := GridContainer.new()
	grid.columns = GRID_COLS
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid.add_theme_constant_override("h_separation", BOARD_CARD_GAP)
	grid.add_theme_constant_override("v_separation", BOARD_CARD_GAP)
	col.add_child(grid)

	cell_buttons.clear()
	for row in range(GRID_ROWS):
		for cc in range(GRID_COLS):
			var cell := Vector2i(cc, row)
			var slot := Control.new()
			slot.custom_minimum_size = Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT)
			slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
			grid.add_child(slot)

			var btn := Button.new()
			_setup_board_card_button(btn, cell)
			btn.pressed.connect(_on_cell_pressed.bind(cell))
			btn.button_down.connect(_on_cell_button_down.bind(cell))
			btn.button_up.connect(_on_cell_button_up)
			slot.add_child(btn)
			btn.set_meta("board_slot", slot)
			_add_board_card_shell_layer(btn)
			_add_bot_boat_layer(btn)
			_add_player_boat_corner_layer(btn)
			_add_player_boat_reticle_layer(btn)
			_add_board_fish_icon_layer(btn)
			_add_board_dead_x_layer(btn)
			_add_cast_dot_layer(btn)
			cell_buttons.append(btn)

	# 3-wide dock, centered on DOCK_COL.
	var dock_row := HBoxContainer.new()
	dock_row.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	dock_row.add_theme_constant_override("separation", BOARD_CARD_GAP)
	col.add_child(dock_row)

	# Dotted left parking zone | the narrow dock | dotted right parking zone.
	# The dashed side zones are where up to four ships park in a 4-player game.
	if DOCK_COL > 0:
		dock_row.add_child(_dock_parking_zone(DOCK_COL))
	var dock_btn := Button.new()
	dock_btn.custom_minimum_size = Vector2(BOARD_CELL_WIDTH * DOCK_WIDTH_CELLS + BOARD_CARD_GAP * (DOCK_WIDTH_CELLS - 1), BOARD_CELL_HEIGHT)
	dock_btn.focus_mode = Control.FOCUS_NONE
	dock_btn.add_theme_font_override("font", FONT_BALATRO)
	dock_btn.add_theme_font_size_override("font_size", FONT_BODY)
	dock_btn.pressed.connect(_on_dock_strip_pressed)
	_decorate_dock_button(dock_btn)
	dock_row.add_child(dock_btn)
	ui["dock_strip"] = dock_btn
	var right_cells := GRID_COLS - DOCK_COL - DOCK_WIDTH_CELLS
	if right_cells > 0:
		dock_row.add_child(_dock_parking_zone(right_cells, true))

	# Depth reads from card color alone — no rail/markings.
	_build_board_toast(board_wrap)


func _setup_board_card_button(btn: Button, cell: Vector2i) -> void:
	btn.text = ""
	btn.icon = null
	btn.expand_icon = false
	btn.focus_mode = Control.FOCUS_NONE
	btn.clip_text = true
	btn.custom_minimum_size = Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT)
	btn.size = Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT)
	btn.pivot_offset = Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT) * 0.5
	btn.add_theme_font_override("font", FONT_BALATRO)
	btn.add_theme_font_size_override("font_size", FONT_CELL)
	btn.add_theme_color_override("font_color", TEXT_PRIMARY)
	btn.add_theme_constant_override("icon_max_width", 32)
	btn.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_apply_transparent_button_style(btn)
	_anchor_fill(btn)
	var tilt := _board_card_tilt(cell)
	btn.rotation_degrees = tilt
	btn.modulate = Color(1, 1, 1, 0)
	btn.set_meta("cell_pos", cell)
	btn.set_meta("card_tilt", tilt)


func _board_card_tilt(cell: Vector2i) -> float:
	var seed := (cell.x * 17 + cell.y * 31 + cell.x * cell.y * 7) % 9
	return (float(seed) - 4.0) * 0.28


func _deal_board_cards() -> void:
	if cell_buttons.is_empty():
		return
	# Deal trends top-left → bottom-right (by diagonal x+y), but each card's place in the order
	# gets a random nudge so it deals hand-shuffled rather than a rigid sweep.
	var order: Array[int] = []
	var deal_score: Dictionary = {}
	for i in range(cell_buttons.size()):
		var c: Vector2i = cell_buttons[i].get_meta("cell_pos", Vector2i.ZERO)
		deal_score[i] = float(c.x + c.y) + randf_range(-2.0, 2.0)
		order.append(i)
	order.sort_custom(func(a: int, b: int) -> bool:
		return float(deal_score[a]) < float(deal_score[b])
	)
	var per_card := 0.045
	for rank in range(order.size()):
		var btn := cell_buttons[order[rank]]
		if not is_instance_valid(btn):
			continue
		var old_tween: Tween = null
		if btn.has_meta("board_card_tween"):
			old_tween = btn.get_meta("board_card_tween") as Tween
		if old_tween:
			old_tween.kill()
		var shell := _board_card_shell(btn)
		var home := Vector2.ZERO
		# Fresh hand-dealt tilt each game (shuffled), about a degree either way.
		var tilt := randf_range(-1.2, 1.2)
		btn.set_meta("card_tilt", tilt)
		btn.z_index = 16 + rank
		btn.modulate = Color(1, 1, 1, 0)
		btn.position = home + Vector2(-64.0 + randf_range(-22.0, 22.0), -52.0 + randf_range(-16.0, 16.0))
		btn.scale = Vector2(0.46, 0.46)
		btn.rotation_degrees = tilt - 16.0
		if shell:
			shell.z_index = 15 + rank
			shell.modulate = btn.modulate
			shell.position = btn.position
			shell.scale = btn.scale
			shell.rotation_degrees = btn.rotation_degrees

		# The interval MUST be its own sequential step. set_parallel(true) right after
		# tween_interval() would run the props in parallel WITH the interval — ignoring the
		# stagger (that was the "all cards at once" bug). Use parallel() per-tweener instead.
		var tween := btn.create_tween()
		btn.set_meta("board_card_tween", tween)
		tween.tween_interval(float(rank) * per_card)
		tween.tween_property(btn, "modulate:a", 1.0, 0.14)
		tween.parallel().tween_property(btn, "position", home, 0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(btn, "scale", Vector2.ONE, 0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(btn, "rotation_degrees", tilt, 0.34).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		if shell:
			tween.parallel().tween_property(shell, "modulate:a", 1.0, 0.14)
			tween.parallel().tween_property(shell, "position", home, 0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(shell, "scale", Vector2.ONE, 0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(shell, "rotation_degrees", tilt, 0.34).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		var card_btn := btn
		var card_shell := shell
		tween.tween_callback(func():
			if is_instance_valid(card_btn):
				card_btn.z_index = 0
			if is_instance_valid(card_shell):
				card_shell.z_index = 0
	)


func _queue_board_deal() -> void:
	if cell_buttons.is_empty():
		return
	call_deferred("_deal_board_cards")


func _apply_transparent_button_style(button: Button) -> void:
	for state in ["normal", "hover", "pressed", "focus", "disabled"]:
		button.add_theme_stylebox_override(state, _transparent_style())


func _board_card_shell(btn: Button) -> Control:
	if not btn.has_meta("board_card_shell"):
		return null
	return btn.get_meta("board_card_shell") as Control


func _add_board_card_shell_layer(btn: Button) -> void:
	var shell := Control.new()
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shell.pivot_offset = Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT) * 0.5
	shell.rotation_degrees = btn.rotation_degrees
	shell.modulate = btn.modulate
	_anchor_fill(shell)
	var slot: Control = btn.get_meta("board_slot", null) as Control
	if slot:
		slot.add_child(shell)
		slot.move_child(shell, 0)
	else:
		btn.add_child(shell)
	btn.set_meta("board_card_shell", shell)


func _render_board_card_shell(btn: Button, fill: Color, dead_card: bool = false) -> void:
	var shell := _board_card_shell(btn)
	if shell == null:
		return
	for child in shell.get_children():
		child.queue_free()

	var card_size := Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT)
	var border_px := 4
	var steps := 2
	var step_px := 2
	_draw_squarestep_card(shell, card_size, fill, Color.WHITE, border_px, steps, step_px)

	if dead_card:
		var wash := ColorRect.new()
		wash.color = _with_alpha(Color("#020914"), 0.22)
		wash.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wash.position = Vector2(border_px + step_px, border_px + step_px)
		wash.size = card_size - Vector2(border_px + step_px, border_px + step_px) * 2.0
		shell.add_child(wash)


func _draw_squarestep_card(parent: Control, card_size: Vector2, fill: Color, border_color: Color, border_px: int, steps: int, step_px: int) -> void:
	var w := card_size.x
	var h := card_size.y
	_gallery_chunky_rrect(parent, 0.0, 0.0, w, h, border_color, steps, step_px)
	var inset := float(border_px)
	_gallery_chunky_rrect(parent, inset, inset, w - inset * 2.0, h - inset * 2.0, fill, steps, step_px)


# A dashed-outline parking placeholder spanning `width_cells` cells of the dock row.
func _dock_parking_zone(width_cells: int, with_boat: bool = false) -> Control:
	var zone := Control.new()
	var w := BOARD_CELL_WIDTH * width_cells + BOARD_CARD_GAP * (width_cells - 1)
	zone.custom_minimum_size = Vector2(w, BOARD_CELL_HEIGHT)
	zone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	zone.draw.connect(_draw_parking_zone.bind(zone))
	if with_boat:
		# The player's ship parks in the first dotted slot, right beside THE DOCKS.
		var boat := TextureRect.new()
		boat.texture = ICON_CARD_SHIP_TEXTURE
		boat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		boat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		boat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		boat.mouse_filter = Control.MOUSE_FILTER_IGNORE
		boat.visible = false
		boat.modulate = _with_alpha(TEXT_PRIMARY, 0.96)
		boat.anchor_top = 0.5
		boat.anchor_bottom = 0.5
		boat.offset_left = 12.0
		boat.offset_right = 66.0
		boat.offset_top = -34.0
		boat.offset_bottom = 28.0
		zone.add_child(boat)
		ui["dock_boat"] = boat
	return zone


func _draw_parking_zone(zone: Control) -> void:
	var sz := zone.size
	var col := _with_alpha(BORDER_HI, 0.5)
	var inset := 3.0
	var a := Vector2(inset, inset)
	var b := Vector2(sz.x - inset, inset)
	var c := Vector2(sz.x - inset, sz.y - inset)
	var d := Vector2(inset, sz.y - inset)
	zone.draw_dashed_line(a, b, col, 2.0, 7.0)
	zone.draw_dashed_line(b, c, col, 2.0, 7.0)
	zone.draw_dashed_line(c, d, col, 2.0, 7.0)
	zone.draw_dashed_line(d, a, col, 2.0, 7.0)


func _decorate_dock_button(dock_btn: Button) -> void:
	dock_btn.text = ""
	dock_btn.icon = null
	dock_btn.expand_icon = false
	dock_btn.clip_text = true
	_apply_transparent_button_style(dock_btn)
	_add_dock_card_shell_layer(dock_btn)

	var label := Label.new()
	label.text = "THE\nDOCKS"
	label.z_index = 10
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", FONT_BALATRO)
	label.add_theme_font_size_override("font_size", 20)
	label.add_theme_color_override("font_color", _with_alpha(TEXT_MUTED, 0.92))
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.46))
	_anchor_fill(label)
	dock_btn.add_child(label)
	dock_btn.set_meta("dock_label", label)


func _add_dock_card_shell_layer(dock_btn: Button) -> void:
	var shell := Control.new()
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shell.z_index = 0
	_anchor_fill(shell)
	dock_btn.add_child(shell)
	dock_btn.set_meta("dock_card_shell", shell)


func _render_dock_card_shell(dock_btn: Button, fill: Color) -> void:
	var shell: Control = dock_btn.get_meta("dock_card_shell", null) as Control
	if shell == null:
		return
	for child in shell.get_children():
		child.queue_free()
	var size := Vector2(BOARD_CELL_WIDTH * DOCK_WIDTH_CELLS + BOARD_CARD_GAP * (DOCK_WIDTH_CELLS - 1), BOARD_CELL_HEIGHT)
	_draw_squarestep_card(shell, size, fill, Color.WHITE, 4, 2, 2)


func _add_cast_dot_layer(btn: Button) -> void:
	var dots := VBoxContainer.new()
	dots.anchor_left = 1.0
	dots.anchor_right = 1.0
	dots.anchor_top = 0.5
	dots.anchor_bottom = 0.5
	dots.offset_left = -18
	dots.offset_right = -6
	dots.offset_top = -30
	dots.offset_bottom = 30
	dots.alignment = BoxContainer.ALIGNMENT_CENTER
	dots.add_theme_constant_override("separation", -2)
	dots.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dots.z_index = 4
	btn.add_child(dots)
	btn.set_meta("cast_dots", dots)


func _add_bot_boat_layer(btn: Button) -> void:
	var boat := TextureRect.new()
	boat.texture = ICON_CARD_SHIP_TEXTURE
	boat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	boat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boat.visible = false
	boat.modulate = Color(1.0, 0.24, 0.18, 0.96)
	boat.z_index = 8
	_position_boat_layer(boat, "full")
	btn.add_child(boat)
	btn.set_meta("bot_boat", boat)


func _add_player_boat_corner_layer(btn: Button) -> void:
	var boat := TextureRect.new()
	boat.texture = ICON_CARD_SHIP_TEXTURE
	boat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	boat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boat.visible = false
	boat.modulate = _with_alpha(TEXT_PRIMARY, 0.96)
	boat.z_index = 8
	_position_boat_layer(boat, "tl_half")
	btn.add_child(boat)
	btn.set_meta("player_boat_corner", boat)


func _add_player_boat_reticle_layer(btn: Button) -> void:
	var reticle := Control.new()
	reticle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reticle.visible = false
	reticle.z_index = 9
	_anchor_fill(reticle)
	btn.add_child(reticle)
	btn.set_meta("player_reticle", reticle)

	var beacon := PanelContainer.new()
	beacon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	beacon.size = Vector2(35, 35)
	beacon.position = Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT) * 0.5 - beacon.size * 0.5
	beacon.pivot_offset = beacon.size * 0.5
	var beacon_style := _styled(_with_alpha(GOLD, 0.0), _with_alpha(GOLD, 0.72), 2, 8)
	beacon_style.anti_aliasing = false
	beacon_style.content_margin_left = 0
	beacon_style.content_margin_right = 0
	beacon_style.content_margin_top = 0
	beacon_style.content_margin_bottom = 0
	beacon.add_theme_stylebox_override("panel", beacon_style)
	reticle.add_child(beacon)
	btn.set_meta("player_beacon", beacon)

	var corner_color := _with_alpha(GOLD, 0.92)
	_add_reticle_corner(reticle, Vector2(4, 4), false, false, corner_color)
	_add_reticle_corner(reticle, Vector2(BOARD_CELL_WIDTH - 4, 4), true, false, corner_color)
	_add_reticle_corner(reticle, Vector2(4, BOARD_CELL_HEIGHT - 4), false, true, corner_color)
	_add_reticle_corner(reticle, Vector2(BOARD_CELL_WIDTH - 4, BOARD_CELL_HEIGHT - 4), true, true, corner_color)


func _add_reticle_corner(parent: Control, anchor: Vector2, flip_x: bool, flip_y: bool, color: Color) -> void:
	var length := 13.0
	var thickness := 3.0
	var h := ColorRect.new()
	h.color = color
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.size = Vector2(length, thickness)
	h.position = Vector2(anchor.x - (length if flip_x else 0.0), anchor.y - (thickness if flip_y else 0.0))
	parent.add_child(h)

	var v := ColorRect.new()
	v.color = color
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.size = Vector2(thickness, length)
	v.position = Vector2(anchor.x - (thickness if flip_x else 0.0), anchor.y - (length if flip_y else 0.0))
	parent.add_child(v)


func _position_boat_layer(rect: TextureRect, mode: String) -> void:
	rect.anchor_left = 0.0
	rect.anchor_top = 0.0
	rect.anchor_right = 1.0
	rect.anchor_bottom = 1.0
	rect.offset_left = 0
	rect.offset_top = 0
	rect.offset_right = 0
	rect.offset_bottom = 0
	match mode:
		"tl_half":
			rect.anchor_right = 0.55
			rect.anchor_bottom = 0.55
			rect.offset_left = 2
			rect.offset_top = 2
		"br_half":
			rect.anchor_left = 0.45
			rect.anchor_top = 0.45
			rect.offset_right = -2
			rect.offset_bottom = -2
		_:
			rect.offset_left = 4
			rect.offset_top = 4
			rect.offset_right = -4
			rect.offset_bottom = -4


func _add_board_fish_icon_layer(btn: Button) -> void:
	var icon := TextureRect.new()
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.visible = false
	icon.z_index = 4
	icon.modulate = Color(1, 1, 1, 0.88)
	_anchor_fill(icon)
	icon.offset_left = 9
	icon.offset_top = 9
	icon.offset_right = -9
	icon.offset_bottom = -9
	btn.add_child(icon)
	btn.set_meta("fish_icon", icon)


func _add_board_dead_x_layer(btn: Button) -> void:
	var x_layer := Control.new()
	x_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	x_layer.visible = false
	x_layer.z_index = 6
	x_layer.clip_contents = true
	_anchor_fill(x_layer)
	var inset := 5.0
	x_layer.offset_left = inset
	x_layer.offset_top = inset
	x_layer.offset_right = -inset
	x_layer.offset_bottom = -inset
	btn.add_child(x_layer)

	var bounds := Vector2(BOARD_CELL_WIDTH - inset * 2.0, BOARD_CELL_HEIGHT - inset * 2.0)
	var angle := atan2(bounds.y, bounds.x)
	_add_board_dead_x_line(x_layer, angle, 8.0, _with_alpha(Color("#061426"), 0.58), 0, bounds)
	_add_board_dead_x_line(x_layer, -angle, 8.0, _with_alpha(Color("#061426"), 0.58), 0, bounds)
	_add_board_dead_x_line(x_layer, angle, 4.0, _with_alpha(Color.WHITE, 0.86), 1, bounds)
	_add_board_dead_x_line(x_layer, -angle, 4.0, _with_alpha(Color.WHITE, 0.86), 1, bounds)
	btn.set_meta("dead_x", x_layer)


func _add_board_dead_x_line(parent: Control, angle: float, thickness: float, color: Color, z: int, bounds: Vector2) -> void:
	var line := ColorRect.new()
	var length := bounds.length()
	line.color = color
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	line.size = Vector2(length, thickness)
	line.position = Vector2(bounds.x * 0.5 - length * 0.5, bounds.y * 0.5 - thickness * 0.5)
	line.pivot_offset = Vector2(length * 0.5, thickness * 0.5)
	line.rotation = angle
	line.z_index = z
	parent.add_child(line)


func _build_board_toast(board_wrap: Control) -> void:
	var toast := _panel_lifted(BG_PANEL_DARK, CYAN_DEEP, 2, 5, 8)
	toast.anchor_left = 0.5
	toast.anchor_right = 0.5
	toast.anchor_top = 0.5
	toast.anchor_bottom = 0.5
	toast.offset_left = -250
	toast.offset_right = 250
	toast.offset_top = -64
	toast.offset_bottom = 64
	toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast.visible = false
	toast.modulate = Color(1, 1, 1, 0)
	toast.z_index = 20
	board_wrap.add_child(toast)
	ui["board_toast"] = toast

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 16)
	pad.add_theme_constant_override("margin_bottom", 16)
	toast.add_child(pad)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 4)
	pad.add_child(col)

	ui["board_toast_fish"] = TextureRect.new()
	ui["board_toast_fish"].custom_minimum_size = Vector2(330, 186)
	ui["board_toast_fish"].expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ui["board_toast_fish"].stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ui["board_toast_fish"].texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	ui["board_toast_fish"].visible = false
	col.add_child(ui["board_toast_fish"])

	ui["board_toast_title"] = _label("", 28, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	ui["board_toast_title"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["board_toast_title"])

	ui["board_toast_detail"] = _label("", FONT_BODY, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	ui["board_toast_detail"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["board_toast_detail"])


func _build_catch_card_overlay() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.visible = false
	overlay.modulate = Color(1, 1, 1, 0)
	overlay.z_index = 150
	add_child(overlay)
	ui["catch_card_overlay"] = overlay

	var shade := ColorRect.new()
	shade.color = _with_alpha(Color("#020b15"), 0.68)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(shade)
	overlay.add_child(shade)
	ui["catch_card_shade"] = shade

	var streaks := Control.new()
	streaks.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(streaks)
	overlay.add_child(streaks)
	for i in range(9):
		var stripe := ColorRect.new()
		stripe.color = _with_alpha(CYAN if i % 2 == 0 else GOLD, 0.05)
		stripe.anchor_left = 0.56 + float(i) * 0.045
		stripe.anchor_right = stripe.anchor_left
		stripe.anchor_top = 0.0
		stripe.anchor_bottom = 1.0
		stripe.offset_left = -4
		stripe.offset_right = 4
		stripe.rotation = deg_to_rad(-16)
		stripe.mouse_filter = Control.MOUSE_FILTER_IGNORE
		streaks.add_child(stripe)

	var layer := Control.new()
	layer.anchor_right = 1.0
	layer.anchor_bottom = 1.0
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(layer)
	ui["catch_card_layer"] = layer


func _build_action_bar(parent: Container) -> void:
	var act := _bare_panel()
	act.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(act)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 10)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 8)
	pad.add_theme_constant_override("margin_bottom", 8)
	act.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	pad.add_child(col)

	var heading := HBoxContainer.new()
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(heading)
	ui["action_heading"] = _section_label("AT SEA")
	ui["action_heading"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.add_child(ui["action_heading"])

	var row := GridContainer.new()
	row.columns = 1
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("h_separation", 9)
	row.add_theme_constant_override("v_separation", 9)
	col.add_child(row)

	action_buttons["cast"]    = _action_button("CAST",        "cast",    _cast, true)
	action_buttons["find"]    = _action_button("FIND FISH",   "find",    _find_fish, true)
	action_buttons["attack"]  = _action_button("ATTACK",      "attack",  _attack)
	action_buttons["sell"]    = _action_button("SELL FISH",   "sell",    _sell_catch)
	action_buttons["upgrade"] = _action_button("UPGRADE",     "upgrade", _open_upgrade_tray)
	action_buttons["repair"]  = _action_button("REPAIR",      "repair",  _open_repair_tray)
	action_buttons["end_day"] = _action_button("END DAY",     "end",     _end_day)

	row.add_child(action_buttons["cast"])
	row.add_child(action_buttons["find"])
	row.add_child(action_buttons["attack"])
	row.add_child(action_buttons["sell"])
	row.add_child(action_buttons["upgrade"])
	row.add_child(action_buttons["repair"])
	row.add_child(action_buttons["end_day"])


func _build_bottom_panel(parent: Container) -> void:
	var panel := _panel_lifted(BG_PANEL, BORDER_FRAME, 1, 7, 4)
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(panel)
	panel.custom_minimum_size = Vector2(0, 220)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 10)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 8)
	pad.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 6)
	pad.add_child(col)

	var tabs := HBoxContainer.new()
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.add_theme_constant_override("separation", 5)
	col.add_child(tabs)

	tab_buttons["boat"]      = _tab_button("⚓  BOAT",      "boat")
	tab_buttons["live_well"] = _tab_button("◐  LIVE WELL", "live_well")
	tab_buttons["market"]    = _tab_button("$  MARKET",    "market")
	tabs.add_child(tab_buttons["boat"])
	tabs.add_child(tab_buttons["live_well"])
	tabs.add_child(tab_buttons["market"])

	var stack := Control.new()
	stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(stack)

	ui["tab_boat"]      = _build_boat_tab()
	ui["tab_live_well"] = _build_live_well_tab()
	ui["tab_market"]    = _build_market_tab()
	stack.add_child(ui["tab_boat"])
	stack.add_child(ui["tab_live_well"])
	stack.add_child(ui["tab_market"])

	for view_key in ["tab_boat", "tab_live_well", "tab_market"]:
		var view: Control = ui[view_key]
		view.anchor_right = 1.0
		view.anchor_bottom = 1.0


func _build_boat_tab() -> Control:
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 4)
	scroll.add_child(col)

	col.add_child(_label("◆  HULL & SYSTEMS", FONT_HEADER, CYAN))
	for key in CONDITION_KEYS:
		var row := _segment_row(_condition_name(key), CONDITION_MAX, false, key, false)
		col.add_child(row)
		boat_segment_panels["cond_" + key] = row

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 6)
	col.add_child(spacer)

	col.add_child(_label("▲  UPGRADES", FONT_HEADER, CYAN))
	for key in UPGRADE_KEYS:
		var row := _segment_row(_upgrade_name(key), UPGRADE_MAX_LEVEL, true, key, false)
		col.add_child(row)
		boat_segment_panels["up_" + key] = row

	return scroll


func _build_live_well_tab() -> Control:
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 30)
	pad.add_theme_constant_override("margin_right", 30)
	pad.add_theme_constant_override("margin_top", 18)
	pad.add_theme_constant_override("margin_bottom", 18)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	pad.add_child(col)

	var card := _panel(BG_PANEL_DARK, BORDER_DARK, 2, 3)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(card)

	var card_col := VBoxContainer.new()
	card_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card_col.add_theme_constant_override("separation", 0)
	card.add_child(card_col)

	var head_style := _styled(BG_PANEL_DARK, BORDER_DARK, 0, 0)
	head_style.content_margin_left = 28
	head_style.content_margin_right = 28
	head_style.content_margin_top = 18
	head_style.content_margin_bottom = 14
	var head := PanelContainer.new()
	head.add_theme_stylebox_override("panel", head_style)
	card_col.add_child(head)
	head.add_child(_label("Live Well", 23, TEXT_PRIMARY))

	ui["live_well_lines"] = VBoxContainer.new()
	ui["live_well_lines"].add_theme_constant_override("separation", 0)
	card_col.add_child(ui["live_well_lines"])

	ui["live_well_status"] = _label("Empty", FONT_SMALL, TEXT_MUTED)
	ui["live_well_status"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["live_well_status"])

	ui["live_well_sell"] = _action_button("SELL FISH", "sell", _sell_catch)
	ui["live_well_sell"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["live_well_sell"])

	return pad


func _build_market_tab() -> Control:
	var pad := MarginContainer.new()
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 4)
	pad.add_child(col)

	col.add_child(_label("$  FISH MARKET", FONT_HEADER, CYAN))

	ui["market_rows"] = VBoxContainer.new()
	ui["market_rows"].add_theme_constant_override("separation", 2)
	col.add_child(ui["market_rows"])

	return pad


func _build_log_strip(parent: Container) -> void:
	var p := _panel(BG_PANEL_DARK, BORDER_FRAME, 1, 6)
	p.custom_minimum_size = Vector2(0, 48)
	parent.add_child(p)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 10)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 4)
	pad.add_theme_constant_override("margin_bottom", 4)
	p.add_child(pad)

	ui["log_label"] = _label("Leave the docks, fish deep, get home before the weather turns.", FONT_BODY, TEXT_PRIMARY)
	ui["log_label"].clip_text = true
	pad.add_child(ui["log_label"])


# ────────────────────────────────────────────────────────────────────────
# Tray overlay (Upgrade / Repair)
# ────────────────────────────────────────────────────────────────────────

func _build_tray_overlay() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 90
	add_child(overlay)
	ui["tray_overlay"] = overlay

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.55)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	backdrop.gui_input.connect(_on_backdrop_input)
	overlay.add_child(backdrop)

	var tray := _panel_lifted(BG_PANEL, BORDER_HI, 2, 10, 10)
	tray.anchor_left = 0.08
	tray.anchor_right = 0.92
	tray.anchor_top = 0.07
	tray.anchor_bottom = 0.95
	tray.offset_left = 0
	tray.offset_right = 0
	tray.offset_top = 0
	tray.offset_bottom = 0
	overlay.add_child(tray)
	ui["tray_panel"] = tray

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 16)
	pad.add_theme_constant_override("margin_right", 16)
	pad.add_theme_constant_override("margin_top", 14)
	pad.add_theme_constant_override("margin_bottom", 14)
	tray.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	pad.add_child(col)

	var head := HBoxContainer.new()
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(head)

	ui["tray_title"] = _label("UPGRADE", 18, TEXT_PRIMARY)
	ui["tray_title"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(ui["tray_title"])

	ui["tray_money"] = _pill("$0", GOLD)
	ui["tray_money"].size_flags_horizontal = Control.SIZE_SHRINK_END
	ui["tray_money"].custom_minimum_size = Vector2(118, 0)
	head.add_child(ui["tray_money"])

	ui["tray_hint"] = _label("Tap an upgrade row to inspect the next card.", 11, TEXT_DIM)
	col.add_child(ui["tray_hint"])

	ui["upgrade_plan"] = _label("Plan: $0", FONT_SMALL, TEXT_MUTED)
	ui["upgrade_plan"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["upgrade_plan"])

	var body_scroll := ScrollContainer.new()
	body_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	body_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(body_scroll)

	ui["tray_body"] = VBoxContainer.new()
	ui["tray_body"].add_theme_constant_override("separation", 6)
	ui["tray_body"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["tray_body"].size_flags_vertical = Control.SIZE_EXPAND_FILL
	body_scroll.add_child(ui["tray_body"])

	var actions := HBoxContainer.new()
	actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions.add_theme_constant_override("separation", 8)
	col.add_child(actions)

	ui["upgrade_reset"] = _tactile_button("RESET", 0, 44, BG_PANEL, BORDER_DARK, TEXT_MUTED)
	ui["upgrade_reset"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_reset"].pressed.connect(_reset_upgrade_plan)
	actions.add_child(ui["upgrade_reset"])

	ui["upgrade_checkout"] = _tactile_button("CHECKOUT", 0, 44, PURPLE_DEEP, PURPLE, TEXT_PRIMARY)
	ui["upgrade_checkout"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_checkout"].pressed.connect(_checkout_upgrade_cart)
	actions.add_child(ui["upgrade_checkout"])

	var close := _tactile_button("CLOSE", 0, 44, BG_PANEL_LIGHT, BORDER_HI, TEXT_PRIMARY)
	close.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close.pressed.connect(_close_tray)
	actions.add_child(close)

	_build_tray_body_upgrade()
	_build_tray_body_repair()
	_show_tray_body("upgrade", false)
	_show_tray_body("repair", false)
	_build_upgrade_card_preview_overlay(overlay)


func _build_tray_body_upgrade() -> void:
	var body := VBoxContainer.new()
	body.name = "UpgradeBody"
	body.add_theme_constant_override("separation", 10)
	ui["tray_body"].add_child(body)
	ui["tray_body_upgrade"] = body

	var night_panel := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 1, 5, 3)
	night_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(night_panel)

	var night_pad := MarginContainer.new()
	night_pad.add_theme_constant_override("margin_left", 10)
	night_pad.add_theme_constant_override("margin_right", 10)
	night_pad.add_theme_constant_override("margin_top", 8)
	night_pad.add_theme_constant_override("margin_bottom", 8)
	night_panel.add_child(night_pad)

	var night_row := HBoxContainer.new()
	night_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	night_row.add_theme_constant_override("separation", 8)
	night_pad.add_child(night_row)

	var night_copy := VBoxContainer.new()
	night_copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	night_copy.add_theme_constant_override("separation", 0)
	night_row.add_child(night_copy)
	night_copy.add_child(_label("EXTRA NIGHT", FONT_BODY, TEXT_PRIMARY))
	night_copy.add_child(_label("$%d buys one more day." % EXTRA_NIGHT_COST, FONT_SMALL, TEXT_MUTED))

	ui["extra_night_count"] = _label("+0", 24, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	ui["extra_night_count"].custom_minimum_size = Vector2(50, 0)
	night_row.add_child(ui["extra_night_count"])

	ui["extra_night_remove"] = _tactile_button("-", 42, 40, BG_PANEL, BORDER_DARK, TEXT_MUTED)
	ui["extra_night_remove"].pressed.connect(_remove_extra_night_from_cart)
	night_row.add_child(ui["extra_night_remove"])

	ui["extra_night_add"] = _tactile_button("+", 42, 40, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	ui["extra_night_add"].pressed.connect(_add_extra_night_to_cart)
	night_row.add_child(ui["extra_night_add"])

	for key in UPGRADE_KEYS:
		var lane := _upgrade_store_lane(key)
		body.add_child(lane)
		upgrade_store_lanes[key] = lane


func _build_tray_body_repair() -> void:
	var body := VBoxContainer.new()
	body.name = "RepairBody"
	body.add_theme_constant_override("separation", 6)
	ui["tray_body"].add_child(body)
	ui["tray_body_repair"] = body

	for key in CONDITION_KEYS:
		var row := _segment_row(_condition_name(key), CONDITION_MAX, false, key, true)
		body.add_child(row)
		repair_tray_rows[key] = row


func _build_upgrade_card_preview_overlay(parent: Control) -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 60
	parent.add_child(overlay)
	ui["upgrade_card_preview_overlay"] = overlay

	var shade := ColorRect.new()
	shade.color = _with_alpha(Color("#020814"), 0.74)
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	shade.gui_input.connect(_on_upgrade_preview_backdrop_input)
	overlay.add_child(shade)

	var stage := HBoxContainer.new()
	stage.anchor_left = 0.5
	stage.anchor_right = 0.5
	stage.anchor_top = 0.5
	stage.anchor_bottom = 0.5
	stage.offset_left = -390
	stage.offset_right = 390
	stage.offset_top = -245
	stage.offset_bottom = 245
	stage.alignment = BoxContainer.ALIGNMENT_CENTER
	stage.add_theme_constant_override("separation", 26)
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(stage)
	ui["upgrade_card_preview_stage"] = stage

	var card_slot := Control.new()
	card_slot.custom_minimum_size = Vector2(316, 412)
	card_slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	card_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(card_slot)
	ui["upgrade_card_preview_slot"] = card_slot

	var info := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 2, 7, 8)
	info.custom_minimum_size = Vector2(310, 0)
	info.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	stage.add_child(info)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 18)
	pad.add_theme_constant_override("margin_right", 18)
	pad.add_theme_constant_override("margin_top", 16)
	pad.add_theme_constant_override("margin_bottom", 16)
	info.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	pad.add_child(col)

	ui["upgrade_card_preview_title"] = _label("UPGRADE", 28, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	ui["upgrade_card_preview_title"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["upgrade_card_preview_title"])

	ui["upgrade_card_preview_level"] = _label("CARD 1/5", FONT_BODY, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	ui["upgrade_card_preview_level"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["upgrade_card_preview_level"])

	ui["upgrade_card_preview_desc"] = _label("", FONT_BODY, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	ui["upgrade_card_preview_desc"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_card_preview_desc"].autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(ui["upgrade_card_preview_desc"])

	ui["upgrade_card_preview_effect"] = _label("", FONT_BODY, CYAN, HORIZONTAL_ALIGNMENT_CENTER)
	ui["upgrade_card_preview_effect"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_card_preview_effect"].autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	col.add_child(ui["upgrade_card_preview_effect"])

	ui["upgrade_card_preview_price"] = _label("$0", 34, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	ui["upgrade_card_preview_price"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["upgrade_card_preview_price"])

	ui["upgrade_card_preview_buy"] = _tactile_button("UPGRADE", 0, 58, PURPLE_DEEP, PURPLE, TEXT_PRIMARY)
	ui["upgrade_card_preview_buy"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_card_preview_buy"].pressed.connect(_purchase_selected_upgrade)
	col.add_child(ui["upgrade_card_preview_buy"])

	ui["upgrade_card_preview_close"] = _tactile_button("CLOSE", 0, 48, BG_PANEL_LIGHT, BORDER_HI, TEXT_PRIMARY)
	ui["upgrade_card_preview_close"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_card_preview_close"].pressed.connect(_close_upgrade_card_preview)
	col.add_child(ui["upgrade_card_preview_close"])


func _build_card_tooltip_overlay() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.visible = false
	overlay.z_index = 140
	add_child(overlay)
	ui["card_tooltip_overlay"] = overlay

	var panel := Panel.new()
	panel.visible = false
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	panel.gui_input.connect(_on_card_tooltip_panel_input)
	overlay.add_child(panel)
	ui["card_tooltip_panel"] = panel

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 14)
	pad.add_theme_constant_override("margin_right", 14)
	pad.add_theme_constant_override("margin_top", 12)
	pad.add_theme_constant_override("margin_bottom", 12)
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(pad)
	ui["card_tooltip_pad"] = pad

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	col.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	pad.add_child(col)
	ui["card_tooltip_col"] = col

	ui["card_tooltip_title"] = _label("", 25, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	ui["card_tooltip_title"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["card_tooltip_title"].size_flags_vertical = Control.SIZE_SHRINK_CENTER
	col.add_child(ui["card_tooltip_title"])

	var effect_box := PanelContainer.new()
	var effect_style := _styled(Color("#fafdff"), Color.WHITE, 2, 5)
	effect_style.content_margin_left = 12
	effect_style.content_margin_right = 12
	effect_style.content_margin_top = 8
	effect_style.content_margin_bottom = 8
	effect_box.add_theme_stylebox_override("panel", effect_style)
	effect_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	effect_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	col.add_child(effect_box)
	ui["card_tooltip_effect_box"] = effect_box

	ui["card_tooltip_effect"] = _label("", FONT_BODY, Color("#36494f"), HORIZONTAL_ALIGNMENT_CENTER)
	ui["card_tooltip_effect"].autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ui["card_tooltip_effect"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["card_tooltip_effect"].size_flags_vertical = Control.SIZE_SHRINK_CENTER
	effect_box.add_child(ui["card_tooltip_effect"])

	ui["card_tooltip_badge"] = PanelContainer.new()
	ui["card_tooltip_badge"].size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ui["card_tooltip_badge"].size_flags_vertical = Control.SIZE_SHRINK_CENTER
	col.add_child(ui["card_tooltip_badge"])

	ui["card_tooltip_badge_label"] = _label("", 21, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	ui["card_tooltip_badge_label"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["card_tooltip_badge_label"].size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ui["card_tooltip_badge"].add_child(ui["card_tooltip_badge_label"])


func _upgrade_store_lane(key: String) -> Button:
	var lane := Button.new()
	lane.text = ""
	lane.focus_mode = Control.FOCUS_NONE
	lane.custom_minimum_size = Vector2(0, 124)
	lane.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lane.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	lane.pressed.connect(_open_upgrade_card_preview.bind(key))

	var pad := MarginContainer.new()
	_anchor_fill(pad)
	pad.add_theme_constant_override("margin_left", 12)
	pad.add_theme_constant_override("margin_right", 12)
	pad.add_theme_constant_override("margin_top", 10)
	pad.add_theme_constant_override("margin_bottom", 10)
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lane.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pad.add_child(row)

	var copy := VBoxContainer.new()
	copy.custom_minimum_size = Vector2(180, 0)
	copy.size_flags_vertical = Control.SIZE_EXPAND_FILL
	copy.alignment = BoxContainer.ALIGNMENT_CENTER
	copy.add_theme_constant_override("separation", 3)
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(copy)

	var title := _label(_upgrade_name(key).to_upper(), 23, TEXT_PRIMARY)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(title)

	var desc := _label(_row_description(key, true), FONT_SMALL, TEXT_MUTED)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.custom_minimum_size = Vector2(172, 0)
	desc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(desc)

	var cost := _label("", FONT_SMALL, GOLD)
	cost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(cost)

	var slots := HBoxContainer.new()
	slots.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slots.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slots.alignment = BoxContainer.ALIGNMENT_CENTER
	slots.add_theme_constant_override("separation", 8)
	slots.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(slots)

	var slot_nodes: Array[Control] = []
	for i in range(UPGRADE_MAX_LEVEL):
		var slot := Control.new()
		slot.custom_minimum_size = _store_mini_card_size() + Vector2(8, 8)
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slot.mouse_filter = Control.MOUSE_FILTER_PASS
		slots.add_child(slot)
		slot_nodes.append(slot)

	var count := _label("0/%d" % UPGRADE_MAX_LEVEL, 27, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_RIGHT)
	count.custom_minimum_size = Vector2(76, 0)
	count.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(count)

	lane.set_meta("key", key)
	lane.set_meta("title_label", title)
	lane.set_meta("desc_label", desc)
	lane.set_meta("cost_label", cost)
	lane.set_meta("count_label", count)
	lane.set_meta("slots", slot_nodes)
	_refresh_upgrade_store_lane(lane)
	return lane


func _refresh_upgrade_store_lanes() -> void:
	for key in UPGRADE_KEYS:
		if upgrade_store_lanes.has(key):
			_refresh_upgrade_store_lane(upgrade_store_lanes[key])


func _refresh_upgrade_store_lane(lane: Control) -> void:
	if lane == null or not lane.has_meta("key"):
		return
	var key := str(lane.get_meta("key"))
	var current := int(upgrades.get(key, 0))
	var maxed := current >= UPGRADE_MAX_LEVEL
	var next_level := clampi(current + 1, 1, UPGRADE_MAX_LEVEL)
	var next_cost := _upgrade_cost(key, current) if not maxed else 0
	var accent := _upgrade_accent(key)

	if lane is Button:
		var button := lane as Button
		button.disabled = game_over or not _is_docked()
		_apply_upgrade_lane_style(button, accent, current, maxed)
		button.modulate = Color(1, 1, 1, 0.58) if button.disabled else Color(1, 1, 1, 1)

	var title: Label = lane.get_meta("title_label")
	var desc: Label = lane.get_meta("desc_label")
	var cost: Label = lane.get_meta("cost_label")
	var count: Label = lane.get_meta("count_label")
	title.add_theme_color_override("font_color", TEXT_PRIMARY if current > 0 else TEXT_MUTED)
	desc.add_theme_color_override("font_color", TEXT_MUTED)
	count.text = "%d/%d" % [current, UPGRADE_MAX_LEVEL]
	count.add_theme_color_override("font_color", GOLD if maxed else (accent if current > 0 else TEXT_DIM))
	if maxed:
		cost.text = "DECK COMPLETE"
		cost.add_theme_color_override("font_color", GOLD)
	else:
		cost.text = "NEXT CARD $%d" % next_cost
		cost.add_theme_color_override("font_color", GOLD if money >= next_cost and _is_docked() else TEXT_DIM)

	var slots: Array = lane.get_meta("slots")
	var mini_size := _store_mini_card_size()
	for i in range(slots.size()):
		var slot: Control = slots[i]
		for child in slot.get_children():
			slot.remove_child(child)
			child.queue_free()
		var level := i + 1
		var owned := level <= current
		var is_next := level == next_level and not maxed
		var card := _build_store_card_visual(key, level, owned, mini_size, {
			"mini": true,
			"show_shadow": false,
			"card_border_px": 4,
			"card_step_px": 2,
		})
		card.position = Vector2(4, 4)
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if owned:
			card.modulate = Color(1, 1, 1, 1)
		elif is_next:
			card.modulate = Color(1, 1, 1, 0.98)
			card.scale = Vector2(1.04, 1.04)
		else:
			card.modulate = Color(1, 1, 1, 0.34)
		slot.add_child(card)
		if is_next:
			_add_store_slot_badge(card, mini_size, "$%d" % next_cost, GOLD)
		elif owned:
			var hit := Button.new()
			hit.text = ""
			hit.focus_mode = Control.FOCUS_NONE
			hit.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			hit.tooltip_text = _upgrade_effect_text(key, level)
			_apply_transparent_button_style(hit)
			_anchor_fill(hit)
			hit.pressed.connect(_show_owned_upgrade_card_tooltip.bind(key, level, slot))
			slot.add_child(hit)


func _apply_upgrade_lane_style(button: Button, accent: Color, current: int, maxed: bool) -> void:
	var fill := BG_PANEL_DARK.lerp(accent, 0.10 if current > 0 else 0.035)
	var border := GOLD if maxed else (accent.darkened(0.14) if current > 0 else BORDER_DARK)
	var normal := _styled_shadow(fill, border, 2 if current > 0 else 1, 6, 3)
	normal.content_margin_left = 0
	normal.content_margin_right = 0
	normal.content_margin_top = 0
	normal.content_margin_bottom = 0
	var hover := _styled_shadow(fill.lightened(0.06), border.lightened(0.18), 2, 6, 3)
	hover.content_margin_left = 0
	hover.content_margin_right = 0
	hover.content_margin_top = 0
	hover.content_margin_bottom = 0
	var press := _styled(fill.darkened(0.10), border.darkened(0.08), 2, 6)
	press.content_margin_left = 0
	press.content_margin_right = 0
	press.content_margin_top = 2
	press.content_margin_bottom = 0
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", press)
	button.add_theme_stylebox_override("focus", hover)
	button.add_theme_stylebox_override("disabled", normal)


func _open_upgrade_card_preview(key: String) -> void:
	if not UPGRADE_KEYS.has(key) or game_over:
		return
	_hide_card_tooltip()
	selected_upgrade_card_key = key
	var current := int(upgrades.get(key, 0))
	selected_upgrade_card_level = clampi(current + 1, 1, UPGRADE_MAX_LEVEL)
	upgrade_card_purchase_locked = false
	if ui.has("upgrade_card_preview_overlay"):
		(ui["upgrade_card_preview_overlay"] as Control).visible = true
	_refresh_upgrade_card_preview()
	_rebuild_upgrade_preview_cards()
	_play_catch_plonk(0)


func _close_upgrade_card_preview() -> void:
	_hide_card_tooltip()
	selected_upgrade_card_key = ""
	selected_upgrade_card_level = 0
	upgrade_card_purchase_locked = false
	if ui.has("upgrade_card_preview_overlay"):
		(ui["upgrade_card_preview_overlay"] as Control).visible = false


func _on_upgrade_preview_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_close_upgrade_card_preview()


func _refresh_upgrade_card_preview() -> void:
	if selected_upgrade_card_key == "" or not ui.has("upgrade_card_preview_overlay"):
		return
	var overlay: Control = ui["upgrade_card_preview_overlay"]
	if not overlay.visible:
		return
	var key := selected_upgrade_card_key
	var current := int(upgrades.get(key, 0))
	var maxed := current >= UPGRADE_MAX_LEVEL
	var level := clampi(current + 1, 1, UPGRADE_MAX_LEVEL)
	if maxed:
		level = UPGRADE_MAX_LEVEL
	selected_upgrade_card_level = level
	var cost := _upgrade_cost(key, current) if not maxed else 0
	var can_buy := not maxed and _is_docked() and money >= cost and not upgrade_card_purchase_locked

	(ui["upgrade_card_preview_title"] as Label).text = _upgrade_name(key).to_upper()
	(ui["upgrade_card_preview_level"] as Label).text = "CARD %d/%d" % [level, UPGRADE_MAX_LEVEL]
	(ui["upgrade_card_preview_desc"] as Label).text = _row_description(key, true)
	(ui["upgrade_card_preview_effect"] as Label).text = _upgrade_effect_text(key, level)
	var price: Label = ui["upgrade_card_preview_price"]
	price.text = "MAXED" if maxed else "$%d" % cost
	price.add_theme_color_override("font_color", GOLD if can_buy or maxed else RED)
	var buy: Button = ui["upgrade_card_preview_buy"]
	buy.text = "MAXED" if maxed else "UPGRADE"
	buy.disabled = not can_buy
	var buy_text := TEXT_PRIMARY if can_buy else TEXT_DIM
	buy.add_theme_color_override("font_color", buy_text)
	buy.add_theme_color_override("font_hover_color", buy_text)
	buy.add_theme_color_override("font_pressed_color", buy_text)
	buy.add_theme_color_override("font_disabled_color", buy_text)
	_apply_tactile_style(buy, PURPLE_DEEP if can_buy else BG_PANEL, PURPLE if can_buy else BORDER_DARK)


func _set_upgrade_preview_purchased_state(level: int, cost: int) -> void:
	if not ui.has("upgrade_card_preview_price") or selected_upgrade_card_key == "":
		return
	(ui["upgrade_card_preview_level"] as Label).text = "UNLOCKED CARD %d/%d" % [level, UPGRADE_MAX_LEVEL]
	(ui["upgrade_card_preview_price"] as Label).text = "-$%d" % cost
	(ui["upgrade_card_preview_price"] as Label).add_theme_color_override("font_color", GOLD)
	var buy: Button = ui["upgrade_card_preview_buy"]
	buy.text = "UPGRADED"
	buy.disabled = true
	buy.add_theme_color_override("font_color", TEXT_DIM)
	buy.add_theme_color_override("font_disabled_color", TEXT_DIM)
	_apply_tactile_style(buy, BG_PANEL, BORDER_DARK)


func _rebuild_upgrade_preview_cards() -> void:
	if selected_upgrade_card_key == "" or not ui.has("upgrade_card_preview_slot"):
		return
	var slot: Control = ui["upgrade_card_preview_slot"]
	for child in slot.get_children():
		slot.remove_child(child)
		child.queue_free()

	var card_size := _store_preview_card_size()
	var slot_size := card_size + Vector2(48, 42)
	slot.custom_minimum_size = slot_size
	var level := clampi(selected_upgrade_card_level, 1, UPGRADE_MAX_LEVEL)
	var key := selected_upgrade_card_key
	var pos := (slot_size - card_size) * 0.5
	var options := {
		"show_shadow": true,
		"shadow_offset": Vector2(12, 16),
		"card_border_px": 8,
		"card_step_px": 4,
	}

	var back := _build_store_card_visual(key, level, false, card_size, options)
	back.position = pos
	back.pivot_offset = card_size * 0.5
	back.scale = Vector2(0.58, 0.58)
	back.rotation = deg_to_rad(-8.0)
	back.modulate = Color(1, 1, 1, 0)
	slot.add_child(back)

	var front := _build_store_card_visual(key, level, true, card_size, options)
	front.position = pos
	front.pivot_offset = card_size * 0.5
	front.scale = Vector2(0.04, 1.0)
	front.rotation = 0.0
	front.visible = false
	slot.add_child(front)

	ui["upgrade_card_preview_back"] = back
	ui["upgrade_card_preview_front"] = front

	var t := back.create_tween()
	t.set_parallel(true)
	t.tween_property(back, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(back, "rotation", 0.0, 0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(back, "modulate:a", 1.0, 0.12)


func _purchase_selected_upgrade() -> void:
	if upgrade_card_purchase_locked or selected_upgrade_card_key == "":
		return
	var key := selected_upgrade_card_key
	var result := _try_buy_upgrade(key, false)
	if not bool(result.get("ok", false)):
		_refresh_upgrade_card_preview()
		_refresh_upgrade_store_lanes()
		return

	upgrade_card_purchase_locked = true
	var level := int(result.get("level", selected_upgrade_card_level))
	var cost := int(result.get("cost", 0))
	selected_upgrade_card_level = level
	var buy: Button = ui["upgrade_card_preview_buy"]
	buy.disabled = true
	buy.add_theme_color_override("font_color", TEXT_DIM)
	buy.add_theme_color_override("font_disabled_color", TEXT_DIM)
	_apply_tactile_style(buy, BG_PANEL, BORDER_DARK)

	var back: Control = ui.get("upgrade_card_preview_back", null)
	var front: Control = ui.get("upgrade_card_preview_front", null)
	if back == null or front == null or not is_instance_valid(back) or not is_instance_valid(front):
		_finish_upgrade_card_purchase(level, cost)
		return

	_play_catch_plonk(1)
	var flip := back.create_tween()
	flip.tween_property(back, "scale:x", 0.035, 0.13).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	flip.tween_callback(func():
		if is_instance_valid(back):
			back.visible = false
		if is_instance_valid(front):
			front.visible = true
			front.scale = Vector2(0.035, 1.0)
		_play_catch_plonk(3)
	)
	flip.tween_property(front, "scale:x", 1.0, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	flip.parallel().tween_property(front, "rotation", deg_to_rad(1.8), 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	flip.tween_property(front, "rotation", 0.0, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	flip.tween_callback(_finish_upgrade_card_purchase.bind(level, cost))


func _finish_upgrade_card_purchase(level: int, cost: int) -> void:
	upgrade_card_purchase_locked = false
	_set_upgrade_preview_purchased_state(level, cost)
	_refresh_upgrade_store_lanes()
	_show_upgrade_purchase_fanfare(_upgrade_accent(selected_upgrade_card_key))
	if audio_catch:
		audio_catch.stop()
		audio_catch.play()
	_update_ui()


func _show_upgrade_purchase_fanfare(accent: Color) -> void:
	if not ui.has("upgrade_card_preview_slot"):
		return
	var slot: Control = ui["upgrade_card_preview_slot"]
	var center := slot.custom_minimum_size * 0.5
	for i in range(18):
		var spark := ColorRect.new()
		spark.color = accent if i % 3 != 0 else GOLD
		spark.size = Vector2(7, 7) if i % 2 == 0 else Vector2(10, 4)
		spark.position = center - spark.size * 0.5
		spark.rotation = deg_to_rad(float(i) * 17.0)
		spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
		spark.z_index = 40
		slot.add_child(spark)
		var angle := TAU * float(i) / 18.0
		var dist := 96.0 + float(i % 5) * 16.0
		var dest := center + Vector2(cos(angle), sin(angle)) * dist - spark.size * 0.5
		var t := spark.create_tween()
		t.set_parallel(true)
		t.tween_property(spark, "position", dest, 0.46).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(spark, "modulate:a", 0.0, 0.42).set_delay(0.06)
		t.tween_property(spark, "rotation", spark.rotation + deg_to_rad(80.0), 0.46)
		t.set_parallel(false)
		t.tween_callback(spark.queue_free)
	for p in range(3):
		var sched := slot.create_tween()
		sched.tween_interval(float(p) * 0.08)
		sched.tween_callback(_play_catch_plonk.bind(4 + p))


func _store_mini_card_size() -> Vector2:
	return Vector2(58, 78)


func _store_preview_card_size() -> Vector2:
	var viewport_size := get_viewport().get_visible_rect().size
	var width := clampf(viewport_size.x * 0.155, 216.0, 278.0)
	return Vector2(width, width * CATCH_CARD_ASPECT)


func _build_store_card_visual(key: String, level: int, face_up: bool, card_size: Vector2, options: Dictionary = {}) -> Control:
	var card := Control.new()
	card.custom_minimum_size = card_size
	card.size = card_size
	card.pivot_offset = card_size * 0.5
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var fill := Color("#011244")
	if face_up and _upgrade_art_texture(key, level) == null:
		fill = _upgrade_accent(key).darkened(0.64)
	var inner := _add_squarestep_card_shell(card, card_size, fill, options)
	var inner_size := Vector2(card_size.x - inner * 2.0, card_size.y - inner * 2.0)
	if face_up:
		var tex := _upgrade_art_texture(key, level)
		if tex:
			var face := _gallery_face(tex)
			face.position = Vector2(inner, inner)
			face.size = inner_size
			card.add_child(face)
		else:
			_add_generated_upgrade_card_face(card, key, level, Rect2(Vector2(inner, inner), inner_size), options)
	else:
		var back := _gallery_face(CARD_BACK_TEXTURE)
		back.position = Vector2(inner, inner)
		back.size = inner_size
		card.add_child(back)
	return card


func _add_squarestep_card_shell(card: Control, card_size: Vector2, fill: Color, options: Dictionary = {}) -> float:
	if bool(options.get("show_shadow", true)):
		_add_halftone_card_shadow(card, card_size, options)
	var w := card_size.x
	var h := card_size.y
	var steps := int(options.get("card_steps", 2))
	var sp := int(options.get("card_step_px", 4))
	var border := int(options.get("card_border_px", 8))
	_gallery_chunky_rrect(card, 0.0, 0.0, w, h, Color("#0a0e14"), steps, sp)
	_gallery_chunky_rrect(card, 2.0, 2.0, w - 4.0, h - 4.0, Color("#ffffff"), steps, sp)
	var ci := 2.0 + float(border)
	_gallery_chunky_rrect(card, ci, ci, w - 2.0 * ci, h - 2.0 * ci, fill, steps, sp)
	return ci + float(steps * sp)


func _add_generated_upgrade_card_face(card: Control, key: String, level: int, rect: Rect2, options: Dictionary = {}) -> void:
	var accent := _upgrade_accent(key)
	var mini := bool(options.get("mini", false))

	var header := ColorRect.new()
	header.color = accent.darkened(0.36)
	header.position = rect.position
	header.size = Vector2(rect.size.x, rect.size.y * (0.24 if mini else 0.22))
	header.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(header)

	for i in range(5):
		var stripe := ColorRect.new()
		stripe.color = _with_alpha(accent.lightened(0.16), 0.11)
		stripe.position = rect.position + Vector2(rect.size.x * (0.15 + float(i) * 0.18), rect.size.y * 0.18)
		stripe.size = Vector2(3 if mini else 5, rect.size.y * 0.66)
		stripe.rotation = deg_to_rad(-18.0)
		stripe.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(stripe)

	var title_text := _upgrade_short_label(key) if mini else _upgrade_name(key).to_upper()
	var title_size := int(clampf(rect.size.x * (0.16 if mini else 0.105), 11.0, 25.0))
	var title := _label(title_text, title_size, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	title.position = rect.position + Vector2(2, rect.size.y * (0.02 if mini else 0.035))
	title.size = Vector2(rect.size.x - 4, rect.size.y * 0.16)
	title.clip_text = true
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(title)

	var icon_size := rect.size.x * (0.54 if mini else 0.48)
	var icon := _icon_texture_rect(_upgrade_icon_texture(key), Vector2(icon_size, icon_size), accent.lightened(0.36))
	icon.position = rect.position + Vector2((rect.size.x - icon_size) * 0.5, rect.size.y * (0.34 if mini else 0.32))
	icon.size = Vector2(icon_size, icon_size)
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	card.add_child(icon)

	var level_size := int(clampf(rect.size.x * (0.18 if mini else 0.13), 12.0, 30.0))
	var level_label := _label("LVL %d" % level, level_size, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	level_label.position = rect.position + Vector2(2, rect.size.y * (0.78 if mini else 0.76))
	level_label.size = Vector2(rect.size.x - 4, rect.size.y * 0.16)
	level_label.clip_text = true
	level_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(level_label)

	if not mini:
		var effect := _label(_upgrade_effect_text(key, level), 16, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
		effect.position = rect.position + Vector2(rect.size.x * 0.08, rect.size.y * 0.88)
		effect.size = Vector2(rect.size.x * 0.84, rect.size.y * 0.10)
		effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		effect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(effect)


func _add_store_slot_badge(card: Control, card_size: Vector2, text: String, accent: Color) -> void:
	var badge := PanelContainer.new()
	badge.custom_minimum_size = Vector2(46, 22)
	badge.size = Vector2(46, 22)
	badge.position = Vector2(card_size.x - 43, -4)
	badge.z_index = 24
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := _styled(accent.darkened(0.24), Color("#fbfdff"), 1, 5)
	style.content_margin_left = 4
	style.content_margin_right = 4
	style.content_margin_top = 0
	style.content_margin_bottom = 1
	badge.add_theme_stylebox_override("panel", style)
	var label := _label(text, 13, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	badge.add_child(label)
	card.add_child(badge)


func _upgrade_art_texture(key: String, level: int) -> Texture2D:
	var idx := clampi(level, 1, UPGRADE_MAX_LEVEL) - 1
	match key:
		"motor":
			return CARD_MOTOR_TEXTURES[idx]
		"fish_finder":
			return CARD_FISH_FINDER_TEXTURES[idx]
		"nets":
			return CARD_NETS_TEXTURES[idx]
	return null


func _upgrade_accent(key: String) -> Color:
	match key:
		"motor":
			return CYAN
		"fish_finder":
			return PURPLE
		"nets":
			return GREEN
		"live_well":
			return GOLD
		"cannons":
			return RED
		"defense":
			return INDIGO
	return TEXT_PRIMARY


func _upgrade_icon_texture(key: String) -> Texture2D:
	match key:
		"motor":
			return ICON_CARD_SHIP_TEXTURE
		"fish_finder":
			return ICON_RADIO_TEXTURE
		"nets":
			return ICON_LIVE_WELL_TEXTURE
		"live_well":
			return ICON_HEALTH_TEXTURE
		"cannons":
			return ICON_STORM_TEXTURE
		"defense":
			return ICON_HURRICANE_TEXTURE
	return ICON_UPGRADES_TEXTURE


func _upgrade_effect_text(key: String, level: int) -> String:
	match key:
		"motor":
			return "%d moves per day" % (BASE_MOVES + level)
		"fish_finder":
			return "%d finder pings per day" % level
		"nets":
			return "+%d to every catch roll" % level
		"live_well":
			return "%d fresh days" % (BASE_LIVE_WELL_DAYS + level)
		"cannons":
			return "Attack roll max %d" % (5 + level)
		"defense":
			return "Defense roll max %d" % (6 + level)
	return "Level %d" % level


# ────────────────────────────────────────────────────────────────────────
# Segmented bar widget
# ────────────────────────────────────────────────────────────────────────

func _segment_row(title: String, total_segments: int, is_upgrade: bool, key: String, interactive: bool) -> Control:
	var wrap := PanelContainer.new()
	var wrap_style := _styled(BG_BODY, BORDER_DARK, 0, 0)
	wrap_style.content_margin_left = 10
	wrap_style.content_margin_right = 10
	wrap_style.content_margin_top = 12
	wrap_style.content_margin_bottom = 12
	wrap.add_theme_stylebox_override("panel", wrap_style)
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 0)
	pad.add_theme_constant_override("margin_right", 0)
	pad.add_theme_constant_override("margin_top", 0)
	pad.add_theme_constant_override("margin_bottom", 0)
	wrap.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	pad.add_child(col)

	var top := HBoxContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(top)

	var title_line := HBoxContainer.new()
	title_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_line.add_theme_constant_override("separation", 8)
	top.add_child(title_line)

	var name_label := _label("%s:" % title, 21, TEXT_PRIMARY)
	title_line.add_child(name_label)

	var desc := _label(_row_description(key, is_upgrade), FONT_BODY, TEXT_MUTED)
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_line.add_child(desc)

	var percent_label := _label("", 28, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_RIGHT)
	percent_label.custom_minimum_size = Vector2(70, 0)
	top.add_child(percent_label)

	var bar_line := HBoxContainer.new()
	bar_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar_line.add_theme_constant_override("separation", 10)
	col.add_child(bar_line)

	var cost_label := _label("", FONT_SMALL, TEXT_MUTED)
	cost_label.custom_minimum_size = Vector2(86, 0)
	cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	title_line.add_child(cost_label)

	# Recessed channel that holds the segment cells.
	var channel := _panel_inset(SEGMENT_EMPTY.darkened(0.25), BG_DEEP, 0)
	channel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar_line.add_child(channel)

	var segments_row := HBoxContainer.new()
	segments_row.add_theme_constant_override("separation", 5)
	segments_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	channel.add_child(segments_row)

	var seg_nodes: Array[Control] = []
	for i in range(total_segments):
		var seg_btn := Button.new()
		seg_btn.focus_mode = Control.FOCUS_NONE
		seg_btn.custom_minimum_size = Vector2(28, 24)
		seg_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		seg_btn.add_theme_font_size_override("font_size", 1)
		seg_btn.text = ""
		if interactive:
			if is_upgrade:
				seg_btn.pressed.connect(_on_buy_upgrade_segment.bind(key, i))
			else:
				seg_btn.pressed.connect(_on_buy_repair_segment.bind(key, i))
		else:
			seg_btn.disabled = true
		segments_row.add_child(seg_btn)
		seg_nodes.append(seg_btn)

	wrap.set_meta("title", title)
	wrap.set_meta("key", key)
	wrap.set_meta("segments", seg_nodes)
	wrap.set_meta("cost_label", cost_label)
	wrap.set_meta("name_label", name_label)
	wrap.set_meta("percent_label", percent_label)
	wrap.set_meta("is_upgrade", is_upgrade)
	wrap.set_meta("interactive", interactive)
	wrap.set_meta("total", total_segments)
	return wrap


func _refresh_segment_row(row: Control, value: int, is_upgrade: bool, key: String, actual_value: int = -1) -> void:
	var segments: Array = row.get_meta("segments")
	var total: int = row.get_meta("total")
	var interactive: bool = row.get_meta("interactive")
	var cost_label: Label = row.get_meta("cost_label")
	var percent_label: Label = row.get_meta("percent_label")
	var damaged := false
	if actual_value < 0:
		actual_value = value

	var next_cost := 0
	var can_afford := false
	if is_upgrade and value < total:
		next_cost = _upgrade_cost(key, value)
		can_afford = money >= _upgrade_cart_cost() + next_cost
	elif not is_upgrade:
		next_cost = REPAIR_COST_PER_SEGMENT
		can_afford = money >= REPAIR_COST_PER_SEGMENT

	for i in range(total):
		var seg: Button = segments[i]
		var filled := i < value
		var already_owned := i < actual_value
		var staged := is_upgrade and i >= actual_value and i < value
		var is_next := interactive and not filled and i == value
		var color: Color
		var border: Color

		if is_upgrade:
			if already_owned:
				color = CYAN_DEEP
				border = CYAN
			elif staged:
				color = PURPLE_DEEP
				border = GOLD
			else:
				color = SEGMENT_EMPTY
				border = BORDER_DARK
		else:
			var ratio := float(value) / float(total)
			var bar_color := GREEN
			if ratio < 0.4:
				bar_color = RED
			elif ratio < 0.7:
				bar_color = GOLD
			color = bar_color if filled else SEGMENT_EMPTY
			border = bar_color.lightened(0.18) if filled else BORDER_DARK
			if not filled:
				damaged = true

		if is_next:
			color = SEGMENT_EMPTY.lightened(0.35)
			border = GOLD if can_afford else CYAN

		var normal := _styled(color, border, 1, 3)
		var hover  := _styled(color.lightened(0.18), border.lightened(0.2), 1, 3)
		var press  := _styled(color.darkened(0.15), border, 1, 3)
		var disabled := _styled(color, border, 1, 3)

		seg.add_theme_stylebox_override("normal", normal)
		seg.add_theme_stylebox_override("hover", hover if interactive else normal)
		seg.add_theme_stylebox_override("pressed", press if interactive else normal)
		seg.add_theme_stylebox_override("disabled", disabled)
		seg.add_theme_stylebox_override("focus", normal)

		if interactive:
			if is_upgrade:
				seg.disabled = i < actual_value or not _is_docked()
			else:
				seg.disabled = filled or i != value or not _is_docked()

	if cost_label:
		if is_upgrade:
			var planned_cost := _upgrade_cost_between(key, actual_value, value)
			if planned_cost > 0:
				cost_label.text = "(PLAN $%d)" % planned_cost
				cost_label.add_theme_color_override("font_color", GOLD if money >= _upgrade_cart_cost() and _is_docked() else TEXT_DIM)
			elif actual_value >= total:
				cost_label.text = "(MAX)"
				cost_label.add_theme_color_override("font_color", TEXT_DIM)
			else:
				var cost := _upgrade_cost(key, actual_value)
				cost_label.text = "($%d)" % cost
				cost_label.add_theme_color_override("font_color", GOLD if money >= cost and _is_docked() else TEXT_DIM)
		else:
			if damaged:
				cost_label.text = "($%d)" % REPAIR_COST_PER_SEGMENT
				cost_label.add_theme_color_override("font_color", GOLD if money >= REPAIR_COST_PER_SEGMENT and _is_docked() else TEXT_DIM)
			else:
				cost_label.text = "($0)"
				cost_label.add_theme_color_override("font_color", TEXT_DIM)

	if percent_label:
		if is_upgrade:
			percent_label.text = "%d" % value
		else:
			percent_label.text = "%d%%" % int(round(float(value) / float(max(1, total)) * 100.0))


# ────────────────────────────────────────────────────────────────────────
# Tray open/close
# ────────────────────────────────────────────────────────────────────────

func _on_funds_pressed() -> void:
	if game_over or active_tray != "":
		return
	if _is_docked():
		_open_upgrade_tray()
	else:
		_log("Return to the docks to visit the ship card store.")


func _open_upgrade_tray() -> void:
	if game_over or not _is_docked():
		return
	_hide_card_tooltip()
	active_tray = "upgrade"
	if ui.has("tray_title"):
		(ui["tray_title"] as Label).text = "SHIP CARD STORE"
	if ui.has("tray_hint"):
		(ui["tray_hint"] as Label).text = "Tap a category row to reveal its next upgrade card."
	if ui.has("tray_overlay"):
		(ui["tray_overlay"] as Control).visible = true
	_show_tray_body("upgrade", true)
	_show_tray_body("repair", false)
	_update_ui()


func _open_repair_tray() -> void:
	if game_over or not _is_docked():
		return
	_hide_card_tooltip()
	active_tray = "repair"
	if ui.has("tray_title"):
		(ui["tray_title"] as Label).text = "SHIP REPAIRS"
	if ui.has("tray_hint"):
		(ui["tray_hint"] as Label).text = "Tap the next damaged segment to repair it."
	if ui.has("tray_overlay"):
		(ui["tray_overlay"] as Control).visible = true
	_show_tray_body("upgrade", false)
	_show_tray_body("repair", true)
	_update_ui()


func _close_tray() -> void:
	_hide_card_tooltip()
	_close_upgrade_card_preview()
	active_tray = ""
	if ui.has("tray_overlay"):
		(ui["tray_overlay"] as Control).visible = false


func _show_tray_body(name: String, show: bool) -> void:
	var node_key := "tray_body_" + name
	if ui.has(node_key):
		(ui[node_key] as Control).visible = show


func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_close_tray()


# ────────────────────────────────────────────────────────────────────────
# Segment purchase handlers
# ────────────────────────────────────────────────────────────────────────

func _clear_upgrade_cart() -> void:
	upgrade_cart.clear()
	extra_night_cart = 0


func _reset_upgrade_plan() -> void:
	_clear_upgrade_cart()
	_log("Upgrade plan cleared.")
	_update_ui()


func _stage_upgrade_segment(key: String, index: int) -> void:
	if game_over:
		return
	if not _is_docked():
		_log("Plan upgrades at the docks.")
		return
	if not UPGRADE_KEYS.has(key):
		return

	var current := int(upgrades.get(key, 0))
	var current_target := _upgrade_cart_target(key)
	var desired := clampi(index + 1, current, UPGRADE_MAX_LEVEL)
	if desired == current_target and desired > current:
		desired -= 1

	if desired <= current:
		upgrade_cart.erase(key)
	else:
		upgrade_cart[key] = desired
	_log_upgrade_cart_status()
	_update_ui()


func _add_extra_night_to_cart() -> void:
	if game_over:
		return
	if not _is_docked():
		_log("Buy extra nights at the docks.")
		return
	extra_night_cart += 1
	_log_upgrade_cart_status()
	_update_ui()


func _remove_extra_night_from_cart() -> void:
	if extra_night_cart <= 0:
		return
	extra_night_cart -= 1
	_log_upgrade_cart_status()
	_update_ui()


func _upgrade_cart_target(key: String) -> int:
	return clampi(int(upgrade_cart.get(key, int(upgrades.get(key, 0)))), int(upgrades.get(key, 0)), UPGRADE_MAX_LEVEL)


func _upgrade_cart_cost() -> int:
	var total := extra_night_cart * EXTRA_NIGHT_COST
	for key in UPGRADE_KEYS:
		var current := int(upgrades.get(key, 0))
		var target := _upgrade_cart_target(key)
		total += _upgrade_cost_between(key, current, target)
	return total


func _upgrade_cart_count() -> int:
	var total := extra_night_cart
	for key in UPGRADE_KEYS:
		total += max(0, _upgrade_cart_target(key) - int(upgrades.get(key, 0)))
	return total


func _upgrade_cost_between(key: String, from_level: int, to_level: int) -> int:
	var total := 0
	for level in range(from_level, to_level):
		total += _upgrade_cost(key, level)
	return total


func _log_upgrade_cart_status() -> void:
	var cost := _upgrade_cart_cost()
	if cost <= 0:
		_log("No upgrades selected.")
	else:
		_log("Upgrade plan: $%d. Remaining after checkout: $%d." % [cost, money - cost])


func _checkout_upgrade_cart() -> void:
	if game_over:
		return
	if not _is_docked():
		_log("Checkout upgrades at the docks.")
		return

	var cost := _upgrade_cart_cost()
	if cost <= 0:
		_log("No upgrades selected.")
		return
	if money < cost:
		_log("Upgrade plan costs $%d. You only have $%d." % [cost, money])
		return

	var moves_before := _daily_moves()
	var finder_before := int(upgrades.get("fish_finder", 0))
	var upgrade_count := 0
	for key in UPGRADE_KEYS:
		var current := int(upgrades.get(key, 0))
		var target := _upgrade_cart_target(key)
		if target > current:
			upgrades[key] = target
			upgrade_count += target - current

	var nights_bought := extra_night_cart
	money -= cost
	extra_nights += nights_bought
	_stat_add("upgrades_bought", upgrade_count)
	_stat_add("extra_nights_bought", nights_bought)

	var gained_moves: int = max(0, _daily_moves() - moves_before)
	moves_remaining += gained_moves
	var gained_finders: int = max(0, int(upgrades.get("fish_finder", 0)) - finder_before)
	finds_remaining += gained_finders

	_clear_upgrade_cart()

	var parts: Array[String] = []
	if upgrade_count > 0:
		parts.append("%d upgrade%s" % [upgrade_count, "" if upgrade_count == 1 else "s"])
	if nights_bought > 0:
		parts.append("%d extra night%s" % [nights_bought, "" if nights_bought == 1 else "s"])
	_log("Checkout complete: %s for $%d." % [", ".join(parts), cost])
	_update_ui()


func _on_buy_upgrade_segment(key: String, index: int) -> void:
	_stage_upgrade_segment(key, index)


func _on_buy_repair_segment(key: String, _index: int) -> void:
	_repair_segment(key)


# ────────────────────────────────────────────────────────────────────────
# Game start / reset
# ────────────────────────────────────────────────────────────────────────

func _new_game(enable_versus: bool = false) -> void:
	game_started = true
	versus_mode = enable_versus
	day = 1
	game_over = false
	_reset_game_stats()
	active_tab = "map"
	active_tray = ""
	boat_pos = Vector2i(DOCK_COL, GRID_ROWS)
	live_well.clear()
	board.clear()
	log_lines.clear()
	cast_holes_today.clear()
	extra_nights = 0
	_clear_upgrade_cart()

	money = START_MONEY
	upgrades = {
		"motor": 0,
		"fish_finder": 0,
		"nets": 0,
		"live_well": 0,
		"cannons": 0,
		"defense": 0,
	}
	conditions = {
		"hull": CONDITION_MAX,
		"propeller": CONDITION_MAX,
		"rudder": CONDITION_MAX,
		"nets": CONDITION_MAX,
	}
	sold_totals.clear()
	trophies.clear()
	for species in SPECIES:
		sold_totals[species] = 0
		trophies[species] = false

	_reset_bot_state()

	_roll_market()
	_generate_board()
	_build_weather_deck()
	current_weather = {"name": "Clear", "strength": 0}
	forecast.clear()
	for i in range(4):
		forecast.append(_draw_weather())
	_refresh_daily_actions()
	_close_tray()
	_hide_start_screen()
	_hide_game_over_screen()
	if versus_mode:
		_log("%s joins the contest. It will fish, sell, and raid if you get close." % BOT_NAME)
		_log("Leave the docks, fish deep, and watch the other captain.")
	else:
		_log("Leave the docks, fish deep, get home before the weather turns.")
	_update_ui()
	_queue_board_deal()


func _reset_bot_state() -> void:
	bot_pos = Vector2i(DOCK_COL, GRID_ROWS)
	bot_money = START_MONEY
	bot_moves_remaining = 0
	bot_finds_remaining = 0
	bot_casts_remaining = 0
	bot_live_well.clear()
	bot_cast_holes_today.clear()
	bot_upgrades = {
		"motor": 0,
		"fish_finder": 0,
		"nets": 0,
		"live_well": 0,
		"cannons": 1,
		"defense": 0,
	}
	bot_conditions = {
		"hull": CONDITION_MAX,
		"propeller": CONDITION_MAX,
		"rudder": CONDITION_MAX,
		"nets": CONDITION_MAX,
	}
	bot_sold_totals.clear()
	bot_trophies.clear()
	for species in SPECIES:
		bot_sold_totals[species] = 0
		bot_trophies[species] = false


func _has_save_game() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func _has_unfinished_solo_save() -> bool:
	if not _has_save_game():
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false

	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return false
	if not (parser.data is Dictionary):
		return false

	var data: Dictionary = parser.data
	var mode := str(data.get("mode", MODE_SOLO))
	return mode == MODE_SOLO and not bool(data.get("game_over", false))


func _save_game() -> void:
	if not game_started:
		return

	var data := {
		"version": SAVE_VERSION,
		"mode": MODE_VERSUS if versus_mode else MODE_SOLO,
		"day": day,
		"money": money,
		"moves_remaining": moves_remaining,
		"finds_remaining": finds_remaining,
		"casts_remaining": casts_remaining,
		"game_over": game_over,
		"game_stats": game_stats,
		"high_score_recorded": high_score_recorded,
		"last_high_score_rank": last_high_score_rank,
		"last_high_score_top_10": last_high_score_top_10,
		"active_tab": active_tab,
		"boat_pos": _serialize_pos(boat_pos),
		"board": board,
		"upgrades": upgrades,
		"conditions": conditions,
		"live_well": live_well,
		"market_prices": market_prices,
		"sold_totals": sold_totals,
		"trophies": trophies,
		"extra_nights": extra_nights,
		"weather_deck": weather_deck,
		"forecast": forecast,
		"current_weather": current_weather,
		"log_lines": log_lines,
		"cast_holes_today": _locks_to_array(cast_holes_today),
		"bot_pos": _serialize_pos(bot_pos),
		"bot_money": bot_money,
		"bot_moves_remaining": bot_moves_remaining,
		"bot_finds_remaining": bot_finds_remaining,
		"bot_casts_remaining": bot_casts_remaining,
		"bot_live_well": bot_live_well,
		"bot_upgrades": bot_upgrades,
		"bot_conditions": bot_conditions,
		"bot_sold_totals": bot_sold_totals,
		"bot_trophies": bot_trophies,
		"bot_cast_holes_today": _locks_to_array(bot_cast_holes_today),
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data))


func _load_game() -> bool:
	if not _has_save_game():
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false

	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return false
	if not (parser.data is Dictionary):
		return false

	var data: Dictionary = parser.data
	game_started = true
	versus_mode = str(data.get("mode", MODE_SOLO)) == MODE_VERSUS
	day = int(data.get("day", 1))
	money = int(data.get("money", START_MONEY))
	moves_remaining = int(data.get("moves_remaining", 0))
	finds_remaining = int(data.get("finds_remaining", 0))
	casts_remaining = int(data.get("casts_remaining", START_CASTS))
	game_over = bool(data.get("game_over", false))
	game_stats = _dict_copy(data.get("game_stats", {}))
	high_score_recorded = bool(data.get("high_score_recorded", false))
	last_high_score_rank = int(data.get("last_high_score_rank", -1))
	last_high_score_top_10 = bool(data.get("last_high_score_top_10", false))
	active_tab = str(data.get("active_tab", "map"))
	active_tray = ""
	boat_pos = _deserialize_pos(data.get("boat_pos", {}), Vector2i(DOCK_COL, GRID_ROWS))

	board = _dict_array(data.get("board", []))
	if board.size() != GRID_COLS * GRID_ROWS:
		return false

	upgrades = _dict_copy(data.get("upgrades", {}))
	conditions = _dict_copy(data.get("conditions", {}))
	_ensure_player_defaults()
	live_well = _dict_array(data.get("live_well", []))
	market_prices = _dict_copy(data.get("market_prices", {}))
	for species in SPECIES:
		if not market_prices.has(species):
			market_prices[species] = int(BASE_PRICES[species])
	sold_totals = _dict_copy(data.get("sold_totals", {}))
	trophies = _dict_copy(data.get("trophies", {}))
	extra_nights = int(data.get("extra_nights", 0))
	_clear_upgrade_cart()
	for species in SPECIES:
		if not sold_totals.has(species):
			sold_totals[species] = 0
		if not trophies.has(species):
			trophies[species] = false
	_ensure_game_stats_defaults()

	weather_deck = _dict_array(data.get("weather_deck", []))
	forecast = _dict_array(data.get("forecast", []))
	while forecast.size() < 4:
		forecast.append(_draw_weather())
	current_weather = _dict_copy(data.get("current_weather", {"name": "Clear", "strength": 0}))
	cast_holes_today = _locks_from_array(data.get("cast_holes_today", []))

	log_lines.clear()
	var saved_logs: Array = data.get("log_lines", [])
	for entry in saved_logs:
		log_lines.append(str(entry))
	if log_lines.is_empty():
		_log("Save loaded.")

	_reset_bot_state()
	bot_pos = _deserialize_pos(data.get("bot_pos", {}), Vector2i(DOCK_COL, GRID_ROWS))
	bot_money = int(data.get("bot_money", START_MONEY))
	bot_moves_remaining = int(data.get("bot_moves_remaining", 0))
	bot_finds_remaining = int(data.get("bot_finds_remaining", 0))
	bot_casts_remaining = int(data.get("bot_casts_remaining", START_CASTS))
	bot_live_well = _dict_array(data.get("bot_live_well", []))
	bot_upgrades = _dict_copy(data.get("bot_upgrades", bot_upgrades))
	bot_conditions = _dict_copy(data.get("bot_conditions", bot_conditions))
	bot_sold_totals = _dict_copy(data.get("bot_sold_totals", bot_sold_totals))
	bot_trophies = _dict_copy(data.get("bot_trophies", bot_trophies))
	bot_cast_holes_today = _locks_from_array(data.get("bot_cast_holes_today", []))

	_close_tray()
	_hide_start_screen()
	_update_ui()
	_queue_board_deal()
	return true


func _ensure_player_defaults() -> void:
	for key in UPGRADE_KEYS:
		if not upgrades.has(key):
			upgrades[key] = 0
	for key in CONDITION_KEYS:
		if not conditions.has(key):
			conditions[key] = CONDITION_MAX


func _reset_game_stats() -> void:
	game_stats = {
		"elapsed_seconds": 0.0,
		"move_actions": 0,
		"moves_used": 0,
		"finds_used": 0,
		"casts_made": 0,
		"empty_casts": 0,
		"fish_caught": 0,
			"fish_sold": 0,
			"treasures_found": 0,
			"treasure_money": 0,
			"paid_nights_found": 0,
			"upgrades_bought": 0,
		"extra_nights_bought": 0,
		"repairs_made": 0,
		"weather_hits": 0,
		"damage_taken": 0,
		"raids_won": 0,
		"raids_lost": 0,
	}
	high_score_recorded = false
	last_high_score_rank = -1
	last_high_score_top_10 = false


func _ensure_game_stats_defaults() -> void:
	var defaults := {
		"elapsed_seconds": 0.0,
		"move_actions": 0,
		"moves_used": 0,
		"finds_used": 0,
		"casts_made": 0,
		"empty_casts": 0,
		"fish_caught": 0,
			"fish_sold": _total_fish_sold(),
			"treasures_found": 0,
			"treasure_money": 0,
			"paid_nights_found": 0,
			"upgrades_bought": _upgrade_total(upgrades),
		"extra_nights_bought": extra_nights,
		"repairs_made": 0,
		"weather_hits": 0,
		"damage_taken": 0,
		"raids_won": 0,
		"raids_lost": 0,
	}
	for key in defaults.keys():
		if not game_stats.has(key):
			game_stats[key] = defaults[key]


func _stat_add(key: String, amount) -> void:
	if game_stats.is_empty():
		_ensure_game_stats_defaults()
	game_stats[key] = game_stats.get(key, 0) + amount


func _season_days() -> int:
	return MAX_DAYS + extra_nights


func _serialize_pos(pos: Vector2i) -> Dictionary:
	return {"x": pos.x, "y": pos.y}


func _deserialize_pos(value, fallback: Vector2i) -> Vector2i:
	if value is Dictionary:
		return Vector2i(int(value.get("x", fallback.x)), int(value.get("y", fallback.y)))
	if value is Array and value.size() >= 2:
		return Vector2i(int(value[0]), int(value[1]))
	return fallback


func _locks_to_array(locks: Dictionary) -> Array[int]:
	var values: Array[int] = []
	for key in locks.keys():
		values.append(int(key))
	return values


func _locks_from_array(values) -> Dictionary:
	var locks: Dictionary = {}
	if values is Array:
		for value in values:
			locks[int(value)] = true
	return locks


func _dict_copy(value) -> Dictionary:
	if value is Dictionary:
		return (value as Dictionary).duplicate(true)
	return {}


func _dict_array(value) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append((item as Dictionary).duplicate(true))
	return result


func _roll_market() -> void:
	market_prices.clear()
	for species in SPECIES:
		market_prices[species] = max(8, int(BASE_PRICES[species]) + rng.randi_range(-5, 8))


func _generate_board() -> void:
	board.clear()
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			board.append(_empty_tile(row))

	var shoal_hits := rng.randi_range(SHOAL_TARGET_RANGE.x, SHOAL_TARGET_RANGE.y)
	var mid_hits := rng.randi_range(MID_TARGET_RANGE.x, MID_TARGET_RANGE.y)
	var deep_hits := rng.randi_range(DEEP_TARGET_RANGE.x, DEEP_TARGET_RANGE.y)
	var fish_total := 0
	fish_total += max(0, shoal_hits - SHOAL_ITEM_COUNT)
	fish_total += max(0, mid_hits - MID_ITEM_COUNT)
	fish_total += max(0, deep_hits - DEEP_ITEM_COUNT)

	var fish_deck := _balanced_species_deck(fish_total)
	var cash_values: Array[int] = TREASURE_VALUES.duplicate()
	_shuffle_indices(cash_values)

	_seed_band_contents(4, 5, shoal_hits, SHOAL_ITEM_COUNT, SHOAL_CASH_ITEM_COUNT, fish_deck, cash_values)
	_seed_band_contents(2, 3, mid_hits, MID_ITEM_COUNT, MID_CASH_ITEM_COUNT, fish_deck, cash_values)
	_seed_band_contents(0, 1, deep_hits, DEEP_ITEM_COUNT, DEEP_CASH_ITEM_COUNT, fish_deck, cash_values)


func _empty_tile(row: int) -> Dictionary:
	var depth: Dictionary = _depth_info(row)
	return {
		"content": "empty",
		"species": "",
		"casts_total": 0,
			"casts_remaining": 0,
			"value": 0,
			"treasure_type": "",
			"found": false,
		"revealed": false,
		"depleted": false,
		"visited": false,
		"zone": depth["zone"],
		"rating": depth["rating"],
	}


func _seed_band_contents(row_start: int, row_end: int, target_count: int, item_count: int, cash_item_count: int, fish_deck: Array[String], cash_values: Array[int]) -> void:
	var candidates: Array[int] = []
	for row in range(row_start, row_end + 1):
		for col in range(GRID_COLS):
			candidates.append(row * GRID_COLS + col)

	_shuffle_indices(candidates)
	var hit_count: int = clampi(target_count, 0, candidates.size())
	var treasure_count: int = clampi(item_count, 0, hit_count)
	var treasures := _treasure_specs_for_band(treasure_count, cash_item_count, cash_values)

	for i in range(treasures.size()):
		_populate_treasure_tile(candidates[i], treasures[i])

	var fish_count := hit_count - treasures.size()
	for i in range(fish_count):
		var index := candidates[treasures.size() + i]
		_populate_fish_tile(index, _draw_species_from_deck(fish_deck))


func _treasure_specs_for_band(item_count: int, cash_item_count: int, cash_values: Array[int]) -> Array[Dictionary]:
	var specs: Array[Dictionary] = []
	var cash_count: int = clampi(cash_item_count, 0, item_count)
	for i in range(cash_count):
		var cash_value := 100
		if not cash_values.is_empty():
			cash_value = cash_values.pop_back()
		specs.append({"type": TREASURE_KIND_CASH, "value": cash_value})

	for i in range(item_count - cash_count):
		specs.append({"type": TREASURE_KIND_PAID_NIGHT, "value": 0})

	_shuffle_treasure_specs(specs)
	return specs


func _populate_treasure_tile(index: int, treasure: Dictionary) -> void:
	var tile: Dictionary = board[index]
	tile["content"] = "treasure"
	tile["treasure_type"] = str(treasure.get("type", TREASURE_KIND_CASH))
	tile["value"] = int(treasure.get("value", 0))
	board[index] = tile


func _balanced_species_deck(count: int) -> Array[String]:
	var deck: Array[String] = []
	if count <= 0:
		return deck

	# Guarantee every species lands on the board at least twice when there's room.
	var min_per := 2
	if count >= SPECIES.size() * min_per:
		for species in SPECIES:
			for j in range(min_per):
				deck.append(species)

	# Fill the rest with balanced, shuffled cycles of all species.
	while deck.size() < count:
		var species_cycle: Array[String] = SPECIES.duplicate()
		_shuffle_species(species_cycle)
		for species in species_cycle:
			if deck.size() >= count:
				break
			deck.append(species)

	_shuffle_species(deck)
	return deck


func _draw_species_from_deck(deck: Array[String]) -> String:
	if deck.is_empty():
		return SPECIES[rng.randi_range(0, SPECIES.size() - 1)]
	return deck.pop_back()


func _shuffle_indices(values: Array[int]) -> void:
	var i := values.size() - 1
	while i > 0:
		var j := rng.randi_range(0, i)
		var tmp := values[i]
		values[i] = values[j]
		values[j] = tmp
		i -= 1


func _shuffle_species(values: Array[String]) -> void:
	var i := values.size() - 1
	while i > 0:
		var j := rng.randi_range(0, i)
		var tmp := values[i]
		values[i] = values[j]
		values[j] = tmp
		i -= 1


func _shuffle_treasure_specs(values: Array[Dictionary]) -> void:
	var i := values.size() - 1
	while i > 0:
		var j := rng.randi_range(0, i)
		var tmp: Dictionary = values[i]
		values[i] = values[j]
		values[j] = tmp
		i -= 1


func _treasure_type(tile: Dictionary) -> String:
	var kind := str(tile.get("treasure_type", TREASURE_KIND_CASH))
	if kind == "":
		return TREASURE_KIND_CASH
	return kind


func _is_paid_night_treasure(tile: Dictionary) -> bool:
	return _treasure_type(tile) == TREASURE_KIND_PAID_NIGHT


func _treasure_board_label(tile: Dictionary) -> String:
	if _is_paid_night_treasure(tile):
		return "+1N"
	return "$%d" % int(tile.get("value", 0))


func _populate_fish_tile(index: int, species: String) -> void:
	var row := int(index / GRID_COLS)
	var tile: Dictionary = board[index]
	var rating: float = float(tile["rating"])
	tile["content"] = "fish"
	tile["species"] = species
	var casts := _roll_casts(rating)
	tile["casts_total"] = casts
	tile["casts_remaining"] = casts
	board[index] = tile


func _roll_casts(rating: float) -> int:
	# Deeper holes hold more casts. Pull from {1, 2, 3, 5}.
	var pool: Array[int] = []
	if rating >= 0.70:
		pool = [2, 3, 3, 5, 5]
	elif rating >= 0.60:
		pool = [1, 2, 3, 3, 5]
	elif rating >= 0.30:
		pool = [1, 2, 2, 3, 3]
	else:
		pool = [1, 1, 2, 2, 3]
	return pool[rng.randi_range(0, pool.size() - 1)]


func _depth_info(row: int) -> Dictionary:
	if row <= 1:
		return {"zone": "Deep", "rating": 0.71}
	if row <= 3:
		return {"zone": "Mid", "rating": 0.62}
	return {"zone": "Shoal", "rating": 0.33}


func _build_weather_deck() -> void:
	weather_deck = []
	for i in range(15):
		weather_deck.append({"name": "Clear", "strength": 0})
	weather_deck.append({"name": "Storm", "strength": 5})
	weather_deck.append({"name": "Storm", "strength": 4})
	weather_deck.append({"name": "Storm", "strength": 4})
	weather_deck.append({"name": "Storm", "strength": 3})
	weather_deck.append({"name": "Storm", "strength": 3})
	weather_deck.append({"name": "Storm", "strength": 2})
	weather_deck.append({"name": "Hurricane", "strength": 5})
	weather_deck.append({"name": "Hurricane", "strength": 4})
	weather_deck.append({"name": "Hurricane", "strength": 3})
	weather_deck.append({"name": "Hurricane", "strength": 2})
	weather_deck.shuffle()


func _draw_weather() -> Dictionary:
	if weather_deck.is_empty():
		_build_weather_deck()
	var w: Dictionary = weather_deck.pop_back()
	# Roll the catch multiplier fresh each draw: rain boosts, hurricanes cut.
	match str(w["name"]):
		"Storm":
			w["mult"] = rng.randf_range(1.0, 1.5)
		"Hurricane":
			w["mult"] = rng.randf_range(0.7, 0.9)
		_:
			w["mult"] = 1.0
	return w


func _refresh_daily_actions(reset_cast_locks: bool = false) -> void:
	moves_remaining = _daily_moves()
	finds_remaining = int(upgrades["fish_finder"])
	casts_remaining = START_CASTS
	if reset_cast_locks:
		cast_holes_today.clear()


func _daily_moves() -> int:
	var moves := BASE_MOVES + int(upgrades["motor"])
	if int(conditions["propeller"]) <= 0:
		moves = int(floor(float(moves) / 2.0))
	return max(0, moves)


func _live_well_days() -> int:
	return BASE_LIVE_WELL_DAYS + int(upgrades["live_well"])


func _move_cost(_delta: Vector2i) -> int:
	return 1


# ────────────────────────────────────────────────────────────────────────
# Player input / actions
# ────────────────────────────────────────────────────────────────────────

func _on_cell_pressed(cell: Vector2i) -> void:
	if game_over or active_tray != "":
		return
	# A long-press already showed this square's tooltip; don't also move/exit.
	if board_long_pressed:
		board_long_pressed = false
		return
	if _is_docked():
		if _is_dock_access_cell(cell):
			_exit_dock_to(cell)
		else:
			_log("Leave through the dock mouth.")
		return

	if cell == boat_pos:
		return
	var delta := cell - boat_pos
	if _is_adjacent_delta(delta):
		_move(delta)
	else:
		_log("Tap an adjacent square to move there.")


# Board-card tooltips only appear on a long press (and never for already-visited squares).
func _on_cell_button_down(cell: Vector2i) -> void:
	board_press_cell = cell
	board_press_time = 0.0
	board_long_fired = false
	board_long_pressed = false


func _on_cell_button_up() -> void:
	board_press_cell = Vector2i(-1, -1)


func _on_dock_strip_pressed() -> void:
	if game_over:
		return
	if _is_docked():
		_exit_dock_to(Vector2i(clampi(boat_pos.x, DOCK_START_COL, DOCK_END_COL), GRID_ROWS - 1))
	elif _is_dock_access_cell(boat_pos):
		_enter_dock_from(boat_pos)
	else:
		_log("Get beside the dock mouth to dock.")


func _move_to_docks() -> void:
	if game_over:
		return
	if _is_docked():
		_log("Already at the docks.")
		return
	if _is_dock_access_cell(boat_pos):
		_enter_dock_from(boat_pos)
	else:
		_log("Reach the dock mouth to dock.")


func _enter_dock_from(pos: Vector2i) -> void:
	var dock_x := clampi(pos.x, DOCK_START_COL, DOCK_END_COL)
	_move(Vector2i(dock_x - boat_pos.x, 1))


func _exit_dock_to(cell: Vector2i) -> void:
	_move(Vector2i(cell.x - boat_pos.x, -1))


func _move(delta: Vector2i) -> void:
	if game_over or active_tray != "":
		return

	var target := boat_pos
	if _is_docked():
		target = boat_pos + delta
		if target.y == GRID_ROWS - 1 and _is_dock_access_cell(target):
			pass
		else:
			_log("Leave through the dock mouth.")
			return
	else:
		target = boat_pos + delta

	var going_to_dock := false
	if target.y >= GRID_ROWS:
		if _is_dock_access_cell(boat_pos) and target.y == GRID_ROWS and _is_dock_col(target.x):
			going_to_dock = true
			target = Vector2i(target.x, GRID_ROWS)
		else:
			_log("The docks are only below the dock mouth.")
			return

	if not going_to_dock and (target.x < 0 or target.x >= GRID_COLS or target.y < 0 or target.y >= GRID_ROWS):
		_log("That course leaves Raider Bay.")
		return

	if abs(delta.x) == 1 and abs(delta.y) == 1 and int(conditions["rudder"]) <= 0:
		_log("The rudder is wrecked. Diagonal movement is unavailable.")
		return

	var cost := _move_cost(delta)
	if moves_remaining < cost:
		_log("No moves left.")
		return

	moves_remaining -= cost
	_stat_add("move_actions", 1)
	_stat_add("moves_used", cost)
	boat_pos = target
	if going_to_dock:
		cast_holes_today.clear()
		_log("Docked safely. Sell, repair, or upgrade before heading out.")
	else:
		var tile: Dictionary = board[_cell_index(boat_pos)]
		tile["visited"] = true
		_log("Moved into %s water." % str(tile["zone"]))
	_update_ui()


func _find_fish() -> void:
	if game_over or active_tray != "":
		return
	if _is_docked():
		_log("Fish finder cannot scan from the docks.")
		return
	if finds_remaining <= 0:
		_log("No fish-finder uses left.")
		return

	finds_remaining -= 1
	_stat_add("finds_used", 1)
	var tile: Dictionary = board[_cell_index(boat_pos)]
	tile["found"] = true
	if bool(tile["depleted"]) or str(tile["content"]) == "empty":
		_log("Finder reads empty water.")
		_show_board_toast("Empty Water", "Finder found no fish here.", TEXT_DIM)
	elif str(tile["content"]) == "treasure":
		if _is_paid_night_treasure(tile):
			_log("Finder pings a Paid Night below.")
			_show_board_toast("Paid Night", "+1 night below", GOLD)
		else:
			_log("Finder pings treasure below.")
			_show_board_toast("Treasure", "$%d below" % int(tile["value"]), GOLD)
	else:
		var species := str(tile["species"])
		var hole_casts := int(tile["casts_remaining"])
		_log("Finder pings %s — %d casts in this hole." % [species, hole_casts])
		_show_finder_card_fan(species, hole_casts, _board_card_global_center(boat_pos))
	_update_ui()
	_animate_board_card_reveal(boat_pos)


func _can_attempt_cast_here() -> bool:
	if _is_docked():
		return false
	var index := _cell_index(boat_pos)
	var tile: Dictionary = board[index]
	if bool(tile["depleted"]):
		return false
	if cast_holes_today.has(index):
		return false
	if bool(tile["found"]) and str(tile["content"]) == "empty":
		return false
	if casts_remaining > 0:
		return true
	return bool(tile["found"]) and str(tile["content"]) == "treasure"


func _should_prompt_end_day() -> bool:
	if game_over or active_tray != "" or _is_docked():
		return false
	if moves_remaining > 0:
		return false
	return casts_remaining <= 0 or not _can_attempt_cast_here()


func _cast() -> void:
	if game_over or active_tray != "":
		return
	if _is_docked():
		_log("Cast from the bay, not from the docks.")
		return

	var tile: Dictionary = board[_cell_index(boat_pos)]
	var hole_index := _cell_index(boat_pos)
	var known_treasure := bool(tile["found"]) and str(tile["content"]) == "treasure" and not bool(tile["depleted"])
	if casts_remaining <= 0 and not known_treasure:
		_log("No casts left.")
		return
	if bool(tile["depleted"]):
		_log("This square has already been fished out.")
		return
	if cast_holes_today.has(hole_index):
		_log("You already cast this hole. Return to the docks before fishing it again.")
		return
	if bool(tile["found"]) and str(tile["content"]) == "empty":
		_log("Finder already marked this water empty.")
		_show_board_toast("Empty Water", "Finder found no fish here.", TEXT_DIM)
		return

	tile["found"] = true
	tile["revealed"] = true

	var cast_outcome := ""
	if str(tile["content"]) == "empty":
		casts_remaining -= 1
		_stat_add("casts_made", 1)
		_stat_add("empty_casts", 1)
		cast_holes_today[hole_index] = true
		tile["depleted"] = true
		_log("Nothing but cold water.")
		_show_board_toast("Empty Water", "Nothing but cold water.", TEXT_DIM)
		cast_outcome = "empty"
	elif str(tile["content"]) == "treasure":
		tile["depleted"] = true
		_stat_add("treasures_found", 1)
		if _is_paid_night_treasure(tile):
			extra_nights += 1
			_stat_add("paid_nights_found", 1)
			_log("Recovered a Paid Night. The season extends by 1 night.")
		else:
			money += int(tile["value"])
			_stat_add("treasure_money", int(tile["value"]))
			_log("Recovered treasure worth $%d." % int(tile["value"]))
		var treasure_origin := _board_card_global_center(boat_pos)
		_show_treasure_card_fan(tile, treasure_origin)
		cast_outcome = "catch"
	else:
		var catch_origin := _board_card_global_center(boat_pos)
		casts_remaining -= 1
		_stat_add("casts_made", 1)
		cast_holes_today[hole_index] = true
		# Fish: roll d6 + nets, decrement casts on the hole.
		var nets_bonus: int = int(upgrades["nets"]) if int(conditions["nets"]) > 0 else 0
		var roll := rng.randi_range(1, CAST_DIE_SIDES)
		var weather_mult: float = float(current_weather.get("mult", 1.0))
		var amount: int = int(ceil(float(roll) * weather_mult)) + nets_bonus
		_stat_add("fish_caught", amount)
		live_well.append({"species": tile["species"], "quantity": amount, "age": 0})
		tile["casts_remaining"] = max(0, int(tile["casts_remaining"]) - 1)
		if int(tile["casts_remaining"]) <= 0:
			tile["depleted"] = true
		var bonus_text := "" if nets_bonus == 0 else " (rolled %d + nets %d)" % [roll, nets_bonus]
		if abs(weather_mult - 1.0) > 0.001:
			bonus_text += " · %s x%.1f" % [str(current_weather.get("name", "weather")), weather_mult]
		_log("Caught %d %s%s." % [amount, str(tile["species"]), bonus_text])
		_show_catch_card_fan(str(tile["species"]), amount, 1, catch_origin)
		cast_outcome = "catch"
	_update_ui()
	_animate_board_card_reveal(boat_pos)
	_play_cast_outcome(cast_outcome)


func _attack() -> void:
	if game_over or active_tray != "":
		return
	if _is_docked():
		_log("Attack only at sea.")
		return
	if not versus_mode:
		_log("No raider boats in range. (Combat needs an opponent.)")
		return
	if not _can_player_attack_bot():
		if int(upgrades["cannons"]) <= 0:
			_log("You need a Cannons upgrade before raiding.")
		else:
			_log("%s is out of cannon range." % BOT_NAME)
		return
	_player_attack_bot()


func _sell_catch() -> void:
	if game_over or active_tray != "":
		return
	if not _is_docked():
		_log("Return to the docks to sell.")
		return
	if live_well.is_empty():
		_log("No fish to sell.")
		return

	_open_sell_modal()


func _confirm_sale() -> void:
	if live_well.is_empty():
		_close_sell_modal()
		return
	if _selected_sale_count() <= 0:
		_refresh_sell_selection_summary(0)
		return
	var result := _complete_sale(0)
	_log_sale_result(result, "")
	_close_sell_modal()
	_update_ui()
	if game_over:
		_show_game_over_screen()


func _haggle_sale() -> void:
	if live_well.is_empty():
		_close_sell_modal()
		return
	if _selected_sale_count() <= 0:
		_refresh_sell_selection_summary(0)
		return

	var roll := rng.randi_range(1, 6)
	var delta_per_fish := 0
	if roll <= 2:
		delta_per_fish = -2
	elif roll >= 5:
		delta_per_fish = 2

	var result := _complete_sale(delta_per_fish)
	var adjustment_text := "$0"
	if delta_per_fish > 0:
		adjustment_text = "+$%d" % delta_per_fish
	elif delta_per_fish < 0:
		adjustment_text = "-$%d" % abs(delta_per_fish)
	var haggle_text := "Roll %d: %s per fish. Auto-accepted." % [roll, adjustment_text]
	if delta_per_fish == 0:
		haggle_text = "Roll %d: market price. Auto-accepted." % roll

	_populate_sell_rows(result["quantities"], delta_per_fish)
	(ui["sell_title"] as Label).text = "Haggle Result"
	(ui["sell_total"] as Label).text = "Sold for $%d" % int(result["total"])
	(ui["sell_result"] as Label).text = haggle_text
	(ui["sell_action_row"] as Control).visible = false
	(ui["sell_ok"] as Control).visible = true
	_log_sale_result(result, "Haggle roll %d. " % roll)
	_update_ui()
	if game_over:
		_show_game_over_screen()


func _open_sell_modal() -> void:
	_reset_sale_selection()
	_populate_sell_selection_rows(0)
	(ui["sell_title"] as Label).text = "Sell Catch"
	_refresh_sell_selection_summary(0)
	(ui["sell_result"] as Label).text = "Check fish to sell. Use +/- to split a batch. Haggle is auto-accepted."
	(ui["sell_action_row"] as Control).visible = true
	(ui["sell_ok"] as Control).visible = false
	(ui["sell_overlay"] as Control).visible = true


func _close_sell_modal() -> void:
	if ui.has("sell_overlay"):
		(ui["sell_overlay"] as Control).visible = false
	sale_selection.clear()


func _reset_sale_selection() -> void:
	sale_selection.clear()
	for i in range(live_well.size()):
		var batch: Dictionary = live_well[i]
		sale_selection[i] = max(0, int(batch.get("quantity", 0)))


func _selected_sale_quantities() -> Dictionary:
	var quantities: Dictionary = {}
	for i in range(live_well.size()):
		var batch: Dictionary = live_well[i]
		var selected := _selected_sale_quantity_for_batch(i)
		if selected <= 0:
			continue
		var species: String = str(batch.get("species", ""))
		quantities[species] = int(quantities.get(species, 0)) + selected
	return quantities


func _selected_sale_quantity_for_batch(batch_index: int) -> int:
	if batch_index < 0 or batch_index >= live_well.size():
		return 0
	var batch: Dictionary = live_well[batch_index]
	var quantity: int = max(0, int(batch.get("quantity", 0)))
	return min(quantity, max(0, int(sale_selection.get(batch_index, quantity))))


func _selected_sale_count() -> int:
	var total := 0
	for i in range(live_well.size()):
		total += _selected_sale_quantity_for_batch(i)
	return total


func _sale_total_for(quantities: Dictionary, delta_per_fish: int) -> int:
	var total := 0
	for species in quantities.keys():
		var unit_price: int = max(0, int(market_prices[str(species)]) + delta_per_fish)
		total += int(quantities[species]) * unit_price
	return total


func _complete_sale(delta_per_fish: int) -> Dictionary:
	var quantities := _selected_sale_quantities()
	var total := _sale_total_for(quantities, delta_per_fish)
	var earned_species: Array[String] = []

	for species in quantities.keys():
		var species_name := str(species)
		var quantity := int(quantities[species])
		sold_totals[species_name] = int(sold_totals[species_name]) + quantity
		_stat_add("fish_sold", quantity)
		if quantity >= TROPHY_REQUIRED and not bool(trophies[species_name]):
			trophies[species_name] = true
			earned_species.append(species_name)

	var kept: Array[Dictionary] = []
	for i in range(live_well.size()):
		var batch: Dictionary = live_well[i]
		var selected: int = _selected_sale_quantity_for_batch(i)
		var remaining: int = max(0, int(batch.get("quantity", 0)) - selected)
		if remaining <= 0:
			continue
		var kept_batch := batch.duplicate(true)
		kept_batch["quantity"] = remaining
		kept.append(kept_batch)
	live_well = kept
	sale_selection.clear()
	money += total
	if _trophy_count() >= TROPHY_WIN_COUNT:
		game_over = true
	return {
		"quantities": quantities,
		"total": total,
		"earned_species": earned_species,
		"delta_per_fish": delta_per_fish,
	}


func _log_sale_result(result: Dictionary, prefix: String) -> void:
	var total := int(result["total"])
	var earned_species: Array = result["earned_species"]
	if earned_species.is_empty():
		_log("%sSold fish for $%d." % [prefix, total])
	else:
		_log("%sSold fish for $%d. Trophy earned: %s." % [prefix, total, ", ".join(earned_species)])
	if _trophy_count() >= TROPHY_WIN_COUNT:
		_log("Contest won: %d trophies earned!" % TROPHY_WIN_COUNT)


func _populate_sell_selection_rows(delta_per_fish: int) -> void:
	var rows: VBoxContainer = ui["sell_rows"]
	for child in rows.get_children():
		child.queue_free()

	for i in range(live_well.size()):
		var batch: Dictionary = live_well[i]
		var batch_quantity: int = max(0, int(batch.get("quantity", 0)))
		if batch_quantity <= 0:
			continue

		var species := str(batch.get("species", ""))
		var selected := _selected_sale_quantity_for_batch(i)
		var unit_price: int = max(0, int(market_prices[species]) + delta_per_fish)
		var subtotal := selected * unit_price

		var wrap := PanelContainer.new()
		var style := _styled(BG_ROW, BORDER_DARK, 1, 3)
		style.content_margin_left = 8
		style.content_margin_right = 8
		style.content_margin_top = 7
		style.content_margin_bottom = 7
		wrap.add_theme_stylebox_override("panel", style)
		wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if selected <= 0:
			wrap.modulate = Color(1, 1, 1, 0.58)
		rows.add_child(wrap)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 8)
		wrap.add_child(row)

		var check := CheckBox.new()
		check.custom_minimum_size = Vector2(42, 42)
		check.focus_mode = Control.FOCUS_NONE
		check.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		check.set_pressed_no_signal(selected > 0)
		check.toggled.connect(_on_sell_batch_toggled.bind(i))
		row.add_child(check)

		var art := TextureRect.new()
		art.texture = _fish_texture(species)
		art.custom_minimum_size = Vector2(92, 66)
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		row.add_child(art)

		var info := VBoxContainer.new()
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		info.add_theme_constant_override("separation", 1)
		row.add_child(info)

		info.add_child(_label(species, FONT_BODY, TEXT_PRIMARY))
		info.add_child(_label("%s · %d aboard" % [_age_name(int(batch.get("age", 0))), batch_quantity], FONT_SMALL, TEXT_MUTED))
		info.add_child(_label("$%d each" % unit_price, FONT_SMALL, GOLD))

		var controls := HBoxContainer.new()
		controls.alignment = BoxContainer.ALIGNMENT_CENTER
		controls.add_theme_constant_override("separation", 5)
		row.add_child(controls)

		var minus := _tactile_button("-", 36, 38, BG_PANEL_LIGHT, BORDER_DARK, TEXT_PRIMARY)
		minus.disabled = selected <= 0
		minus.pressed.connect(_adjust_sale_batch_quantity.bind(i, -1))
		controls.add_child(minus)

		var count_lbl := _label("%d/%d" % [selected, batch_quantity], FONT_BODY, TEXT_PRIMARY if selected > 0 else TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
		count_lbl.custom_minimum_size = Vector2(56, 0)
		controls.add_child(count_lbl)

		var plus := _tactile_button("+", 36, 38, BG_PANEL_LIGHT, BORDER_DARK, TEXT_PRIMARY)
		plus.disabled = selected >= batch_quantity
		plus.pressed.connect(_adjust_sale_batch_quantity.bind(i, 1))
		controls.add_child(plus)

		var price := _label("$%d" % subtotal, FONT_BODY, GOLD if selected > 0 else TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
		price.custom_minimum_size = Vector2(76, 0)
		row.add_child(price)


func _refresh_sell_selection_summary(delta_per_fish: int) -> void:
	var selected_count := _selected_sale_count()
	var total := _sale_total_for(_selected_sale_quantities(), delta_per_fish)
	if selected_count <= 0:
		(ui["sell_total"] as Label).text = "Select fish to sell"
	else:
		(ui["sell_total"] as Label).text = "%d fish selected · Sale price: $%d" % [selected_count, total]
	if ui.has("sell_confirm"):
		var confirm: Button = ui["sell_confirm"]
		confirm.disabled = selected_count <= 0
	if ui.has("sell_haggle"):
		var haggle: Button = ui["sell_haggle"]
		haggle.disabled = selected_count <= 0


func _on_sell_batch_toggled(enabled: bool, batch_index: int) -> void:
	if batch_index < 0 or batch_index >= live_well.size():
		return
	var batch: Dictionary = live_well[batch_index]
	sale_selection[batch_index] = max(0, int(batch.get("quantity", 0))) if enabled else 0
	_populate_sell_selection_rows(0)
	_refresh_sell_selection_summary(0)


func _adjust_sale_batch_quantity(batch_index: int, delta: int) -> void:
	if batch_index < 0 or batch_index >= live_well.size():
		return
	var batch: Dictionary = live_well[batch_index]
	var batch_quantity: int = max(0, int(batch.get("quantity", 0)))
	var selected: int = _selected_sale_quantity_for_batch(batch_index)
	sale_selection[batch_index] = min(batch_quantity, max(0, selected + delta))
	_populate_sell_selection_rows(0)
	_refresh_sell_selection_summary(0)


func _populate_sell_rows(quantities: Dictionary, delta_per_fish: int) -> void:
	var rows: VBoxContainer = ui["sell_rows"]
	for child in rows.get_children():
		child.queue_free()

	for species in SPECIES:
		var quantity := int(quantities.get(species, 0))
		if quantity <= 0:
			continue

		var unit_price: int = max(0, int(market_prices[species]) + delta_per_fish)
		var subtotal := quantity * unit_price

		var wrap := PanelContainer.new()
		var style := _styled(BG_ROW, BORDER_DARK, 1, 3)
		style.content_margin_left = 10
		style.content_margin_right = 10
		style.content_margin_top = 8
		style.content_margin_bottom = 8
		wrap.add_theme_stylebox_override("panel", style)
		wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rows.add_child(wrap)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 10)
		wrap.add_child(row)

		var art := TextureRect.new()
		art.texture = _fish_texture(species)
		art.custom_minimum_size = Vector2(174, 126)
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		row.add_child(art)

		var name := _label(species, FONT_BODY, TEXT_PRIMARY)
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(name)

		row.add_child(_label("%d x $%d" % [quantity, unit_price], FONT_BODY, TEXT_MUTED, HORIZONTAL_ALIGNMENT_RIGHT))
		row.add_child(_label("$%d" % subtotal, FONT_BODY, GOLD, HORIZONTAL_ALIGNMENT_RIGHT))


func _repair_segment(key: String) -> void:
	if game_over:
		return
	if not _is_docked():
		_log("Repairs only at the docks.")
		return
	if not CONDITION_KEYS.has(key):
		return
	if int(conditions[key]) >= CONDITION_MAX:
		_log("%s already fully repaired." % _condition_name(key))
		return
	if money < REPAIR_COST_PER_SEGMENT:
		_log("Not enough money to repair (need $%d)." % REPAIR_COST_PER_SEGMENT)
		return

	money -= REPAIR_COST_PER_SEGMENT
	conditions[key] = min(CONDITION_MAX, int(conditions[key]) + 1)
	_stat_add("repairs_made", 1)
	_log("Repaired %s by 1 ($%d)." % [_condition_name(key), REPAIR_COST_PER_SEGMENT])
	_update_ui()


func _buy_upgrade(key: String) -> void:
	_try_buy_upgrade(key, true)


func _try_buy_upgrade(key: String, refresh_after: bool = true) -> Dictionary:
	if game_over:
		return {"ok": false}
	if not _is_docked():
		_log("Buy upgrades at the docks.")
		return {"ok": false}
	if not UPGRADE_KEYS.has(key):
		return {"ok": false}

	var current: int = int(upgrades[key])
	if current >= UPGRADE_MAX_LEVEL:
		_log("%s is already maxed." % _upgrade_name(key))
		return {"ok": false}

	var moves_before := _daily_moves()
	var cost := _upgrade_cost(key, current)
	if money < cost:
		_log("%s upgrade costs $%d." % [_upgrade_name(key), cost])
		return {"ok": false, "cost": cost}

	money -= cost
	upgrades[key] = current + 1
	_stat_add("upgrades_bought", 1)
	_apply_upgrade_to_current_turn(key, moves_before)
	_log("Upgraded %s to %d ($%d)." % [_upgrade_name(key), int(upgrades[key]), cost])
	if refresh_after:
		_update_ui()
	return {"ok": true, "key": key, "level": int(upgrades[key]), "cost": cost}


func _apply_upgrade_to_current_turn(key: String, moves_before: int) -> void:
	match key:
		"motor":
			var gained_moves: int = max(0, _daily_moves() - moves_before)
			moves_remaining += gained_moves
		"fish_finder":
			finds_remaining += 1


func _upgrade_cost(key: String, current: int) -> int:
	var base: int = int(UPGRADE_BASE_COST[key])
	var step: int = int(UPGRADE_COST_STEP[key])
	return base + current * step


func _upgrade_name(key: String) -> String:
	match key:
		"fish_finder":
			return "Fish Finder"
		"live_well":
			return "Live Well"
		_:
			return key.capitalize()


func _condition_name(key: String) -> String:
	match key:
		"hull":
			return "Hull"
		"propeller":
			return "Propeller"
		"rudder":
			return "Rudder"
		"nets":
			return "Nets"
		_:
			return key.capitalize()


func _row_description(key: String, is_upgrade: bool) -> String:
	if is_upgrade:
		match key:
			"motor":
				return "Base 3. Move one extra space per turn."
			"fish_finder":
				return "Use fish finder one extra time per turn."
			"nets":
				return "Add plus one to every catch roll."
			"live_well":
				return "Base 2 days. Fish stay alive for one extra day."
			"cannons":
				return "Max attack roll is one value larger."
			"defense":
				return "Max defense roll is one value larger."
	else:
		match key:
			"hull":
				return "Prevents your boat from sinking."
			"propeller":
				return "Broken propellers limit movement."
			"rudder":
				return "Wrecked rudders cannot move diagonally."
			"nets":
				return "Damaged nets catch fewer fish."
	return ""


func _end_day() -> void:
	if game_over or active_tray != "":
		return

	if versus_mode:
		await _run_bot_turn()
		if game_over:
			_update_ui()
			_show_game_over_screen()
			return

	_resolve_weather()
	if game_over:
		_update_ui()
		_show_game_over_screen()
		return
	_age_fish()
	if versus_mode:
		_age_bot_fish()

	day += 1
	if day > _season_days():
		game_over = true
		if not _is_docked() and not live_well.is_empty():
			_log("Season over. Unsold fish remain aboard.")
		_log("Final score: %d trophies, $%d." % [_trophy_count(), money])
		_update_ui()
		_show_game_over_screen()
		return

	current_weather = forecast.pop_front()
	forecast.append(_draw_weather())
	_refresh_daily_actions()
	_log("Day %d begins." % day)
	_update_ui()
	_show_day_transition()


func _resolve_weather() -> void:
	var strength: int = int(current_weather["strength"])
	if strength <= 0:
		_log("Clear night.")
		return

	_resolve_weather_for_player(strength)
	if versus_mode:
		_resolve_weather_for_bot(strength)


func _resolve_weather_for_player(strength: int) -> void:
	if _is_docked():
		_log("%s %d passed while you were safe at the docks." % [str(current_weather["name"]), strength])
		return

	var roll := rng.randi_range(1, 6)
	if roll >= strength:
		_log("Rolled %d and rode out %s %d." % [roll, str(current_weather["name"]), strength])
		return

	var damage := strength - roll + 1
	var systems: Array[String] = ["hull", "propeller", "rudder", "nets"]
	for i in range(damage):
		var system: String = systems[rng.randi_range(0, systems.size() - 1)]
		conditions[system] = max(0, int(conditions[system]) - 1)
	_stat_add("weather_hits", 1)
	_stat_add("damage_taken", damage)
	_log("%s %d hit for %d damage." % [str(current_weather["name"]), strength, damage])
	if int(conditions["hull"]) <= 0:
		game_over = true
		_log("The hull failed. Your boat sank.")
		_show_game_over_screen()


func _resolve_weather_for_bot(strength: int) -> void:
	if _bot_is_docked():
		_log("%s stayed safe at the docks." % BOT_NAME)
		return

	var roll := rng.randi_range(1, 6)
	if roll >= strength:
		_log("%s rode out %s %d." % [BOT_NAME, str(current_weather["name"]), strength])
		return

	var damage := strength - roll + 1
	var systems: Array[String] = ["hull", "propeller", "rudder", "nets"]
	for i in range(damage):
		var system: String = systems[rng.randi_range(0, systems.size() - 1)]
		bot_conditions[system] = max(0, int(bot_conditions[system]) - 1)
	_log("%s took %d storm damage." % [BOT_NAME, damage])
	if int(bot_conditions["hull"]) <= 0:
		_sink_bot("%s sank %s." % [str(current_weather["name"]), BOT_NAME])


func _age_fish() -> void:
	if live_well.is_empty():
		return

	var kept: Array[Dictionary] = []
	var spoiled := 0
	for batch in live_well:
		batch["age"] = int(batch["age"]) + 1
		if int(batch["age"]) > _live_well_days():
			spoiled += int(batch["quantity"])
		else:
			kept.append(batch)
	live_well = kept
	if spoiled > 0:
		_log("%d fish spoiled in the live well." % spoiled)


func _age_bot_fish() -> void:
	if bot_live_well.is_empty():
		return

	var kept: Array[Dictionary] = []
	var spoiled := 0
	for batch in bot_live_well:
		batch["age"] = int(batch["age"]) + 1
		if int(batch["age"]) > _bot_live_well_days():
			spoiled += int(batch["quantity"])
		else:
			kept.append(batch)
	bot_live_well = kept
	if spoiled > 0:
		_log("%s lost %d spoiled fish." % [BOT_NAME, spoiled])


# ────────────────────────────────────────────────────────────────────────
# Computer captain
# ────────────────────────────────────────────────────────────────────────

func _run_bot_turn() -> void:
	if not versus_mode or game_over:
		return

	var prior_tray := active_tray
	active_tray = "bot_turn"

	_bot_refresh_daily_actions()
	bot_cast_holes_today.clear()
	_log("%s takes its turn." % BOT_NAME)
	await _bot_step_pause()

	if _bot_is_docked():
		if _bot_should_sell() and _bot_sell_catch():
			await _bot_step_pause()
		if _bot_buy_upgrade():
			await _bot_step_pause()
		if _bot_total_fish() < TROPHY_REQUIRED or rng.randf() < 0.72:
			_bot_exit_dock()
			if not _bot_is_docked():
				await _bot_step_pause()

	var guard := 0
	while bot_moves_remaining > 0 and guard < 12 and not game_over:
		guard += 1
		if _bot_try_attack(0.70):
			await _bot_step_pause()
			break

		if not _bot_is_docked() and not _bot_should_return() and _bot_can_cast_here() and rng.randf() < 0.80:
			_bot_cast()
			await _bot_step_pause()

		if _bot_should_return():
			var dock_prev := bot_pos
			_bot_step_toward_dock()
			if bot_pos != dock_prev:
				await _bot_step_pause()
			if _bot_is_docked():
				if _bot_should_sell() and _bot_sell_catch():
					await _bot_step_pause()
				if _bot_buy_upgrade():
					await _bot_step_pause()
				break
		else:
			var step_prev := bot_pos
			_bot_step_toward(_bot_pick_target())
			if bot_pos != step_prev:
				await _bot_step_pause()
			else:
				break

	if not game_over and _bot_try_attack(0.35):
		await _bot_step_pause()

	active_tray = prior_tray
	_update_ui()


func _bot_step_pause() -> void:
	_update_ui()
	await get_tree().create_timer(BOT_STEP_SECONDS).timeout


func _bot_refresh_daily_actions() -> void:
	bot_moves_remaining = _bot_daily_moves()
	bot_finds_remaining = int(bot_upgrades.get("fish_finder", 0))
	bot_casts_remaining = START_CASTS


func _bot_daily_moves() -> int:
	var moves := BASE_MOVES + int(bot_upgrades.get("motor", 0))
	if int(bot_conditions.get("propeller", CONDITION_MAX)) <= 0:
		moves = int(floor(float(moves) / 2.0))
	return max(0, moves)


func _bot_live_well_days() -> int:
	return BASE_LIVE_WELL_DAYS + int(bot_upgrades.get("live_well", 0))


func _bot_is_docked() -> bool:
	return bot_pos.y == GRID_ROWS


func _bot_total_fish() -> int:
	var total := 0
	for batch in bot_live_well:
		total += int(batch["quantity"])
	return total


func _bot_oldest_fish_age() -> int:
	var oldest := 0
	for batch in bot_live_well:
		oldest = max(oldest, int(batch["age"]))
	return oldest


func _bot_should_sell() -> bool:
	if bot_live_well.is_empty():
		return false
	return _bot_total_fish() >= TROPHY_REQUIRED or _bot_oldest_fish_age() >= max(1, _bot_live_well_days() - 1)


func _bot_should_return() -> bool:
	if _bot_is_docked():
		return false
	if _bot_should_sell():
		return true
	if bot_casts_remaining <= 0 and _bot_total_fish() > 0:
		return true
	return false


func _bot_pick_target() -> Vector2i:
	if not _is_docked() and rng.randf() < 0.28:
		return Vector2i(clampi(boat_pos.x, 0, GRID_COLS - 1), clampi(boat_pos.y, 0, GRID_ROWS - 1))

	var target_y: int = max(0, bot_pos.y - 1)
	if bot_pos.y <= 1 and rng.randf() < 0.45:
		target_y = rng.randi_range(0, 1)
	var target_x: int = clampi(bot_pos.x + rng.randi_range(-2, 2), 0, GRID_COLS - 1)
	return Vector2i(target_x, target_y)


func _bot_exit_dock() -> void:
	if not _bot_is_docked() or bot_moves_remaining <= 0:
		return
	bot_pos = Vector2i(DOCK_COL, GRID_ROWS - 1)
	bot_moves_remaining -= 1
	_log("%s leaves the docks." % BOT_NAME)


func _bot_step_toward_dock() -> void:
	if _bot_is_docked() or bot_moves_remaining <= 0:
		return
	if _is_dock_access_cell(bot_pos):
		bot_pos = Vector2i(clampi(bot_pos.x, DOCK_START_COL, DOCK_END_COL), GRID_ROWS)
		bot_moves_remaining -= 1
		bot_cast_holes_today.clear()
		_log("%s docks with %d fish aboard." % [BOT_NAME, _bot_total_fish()])
		return
	_bot_step_toward(Vector2i(DOCK_COL, GRID_ROWS - 1))


func _bot_step_toward(target: Vector2i) -> void:
	if bot_moves_remaining <= 0:
		return
	if _bot_is_docked():
		_bot_exit_dock()
		return

	var dx := clampi(target.x - bot_pos.x, -1, 1)
	var dy := clampi(target.y - bot_pos.y, -1, 1)
	if dx == 0 and dy == 0:
		dx = rng.randi_range(-1, 1)
		dy = -1 if bot_pos.y > 0 else 1
	if dx != 0 and dy != 0 and int(bot_conditions.get("rudder", CONDITION_MAX)) <= 0:
		dy = 0

	var next := bot_pos + Vector2i(dx, dy)
	next.x = clampi(next.x, 0, GRID_COLS - 1)
	next.y = clampi(next.y, 0, GRID_ROWS - 1)
	if next == bot_pos:
		return
	bot_pos = next
	bot_moves_remaining -= 1


func _bot_can_cast_here() -> bool:
	if _bot_is_docked():
		return false
	var index := _cell_index(bot_pos)
	var tile: Dictionary = board[index]
	if bool(tile["depleted"]):
		return false
	if bot_cast_holes_today.has(index):
		return false
	if bot_casts_remaining > 0:
		return true
	return str(tile["content"]) == "treasure"


func _bot_cast() -> void:
	if not _bot_can_cast_here():
		return

	var index := _cell_index(bot_pos)
	var tile: Dictionary = board[index]
	tile["found"] = true
	tile["revealed"] = true

	if str(tile["content"]) == "empty":
		bot_casts_remaining -= 1
		bot_cast_holes_today[index] = true
		tile["depleted"] = true
		_log("%s casts and finds empty water." % BOT_NAME)
	elif str(tile["content"]) == "treasure":
		tile["depleted"] = true
		if _is_paid_night_treasure(tile):
			extra_nights += 1
			_log("%s recovers a Paid Night. The season extends by 1 night." % BOT_NAME)
		else:
			bot_money += int(tile["value"])
			_log("%s recovers $%d treasure." % [BOT_NAME, int(tile["value"])])
	else:
		bot_casts_remaining -= 1
		bot_cast_holes_today[index] = true
		var nets_bonus: int = int(bot_upgrades.get("nets", 0)) if int(bot_conditions.get("nets", CONDITION_MAX)) > 0 else 0
		var amount := rng.randi_range(1, CAST_DIE_SIDES) + nets_bonus
		bot_live_well.append({"species": tile["species"], "quantity": amount, "age": 0})
		tile["casts_remaining"] = max(0, int(tile["casts_remaining"]) - 1)
		if int(tile["casts_remaining"]) <= 0:
			tile["depleted"] = true
		_log("%s catches %d %s." % [BOT_NAME, amount, str(tile["species"])])

	board[index] = tile


func _bot_sell_catch() -> bool:
	if bot_live_well.is_empty():
		return false

	var quantities: Dictionary = {}
	for batch in bot_live_well:
		var species: String = str(batch["species"])
		quantities[species] = int(quantities.get(species, 0)) + int(batch["quantity"])

	var total := 0
	var earned: Array[String] = []
	for species in quantities.keys():
		var species_name := str(species)
		var quantity := int(quantities[species])
		total += quantity * int(market_prices.get(species_name, BASE_PRICES.get(species_name, 0)))
		bot_sold_totals[species_name] = int(bot_sold_totals.get(species_name, 0)) + quantity
		if quantity >= TROPHY_REQUIRED and not bool(bot_trophies.get(species_name, false)):
			bot_trophies[species_name] = true
			earned.append(species_name)

	bot_live_well.clear()
	bot_money += total
	if earned.is_empty():
		_log("%s sells fish for $%d." % [BOT_NAME, total])
	else:
		_log("%s sells for $%d and claims %s trophy." % [BOT_NAME, total, ", ".join(earned)])
	if _bot_trophy_count() >= TROPHY_WIN_COUNT:
		game_over = true
		_log("%s wins the contest with %d trophies." % [BOT_NAME, TROPHY_WIN_COUNT])
	return true


func _bot_buy_upgrade() -> bool:
	var preferences: Array[String] = ["motor", "nets", "fish_finder", "live_well", "cannons", "defense"]
	for key in preferences:
		var current := int(bot_upgrades.get(key, 0))
		if current >= UPGRADE_MAX_LEVEL:
			continue
		var cost := _upgrade_cost(key, current)
		if bot_money >= cost and rng.randf() < 0.55:
			bot_money -= cost
			bot_upgrades[key] = current + 1
			_log("%s upgrades %s." % [BOT_NAME, _upgrade_name(key)])
			return true
	return false


func _bot_try_attack(chance: float) -> bool:
	if not _can_bot_attack_player():
		return false
	if rng.randf() > chance:
		return false
	_bot_attack_player()
	return true


func _distance_to_bot() -> int:
	if _is_docked() or _bot_is_docked():
		return 99
	return maxi(abs(boat_pos.x - bot_pos.x), abs(boat_pos.y - bot_pos.y))


func _can_player_attack_bot() -> bool:
	return versus_mode and not _is_docked() and not _bot_is_docked() and _distance_to_bot() <= 2 and int(upgrades.get("cannons", 0)) > 0


func _can_bot_attack_player() -> bool:
	return versus_mode and not _is_docked() and not _bot_is_docked() and _distance_to_bot() <= 2 and int(bot_upgrades.get("cannons", 0)) > 0


func _player_attack_bot() -> void:
	var attack_roll := rng.randi_range(1, _attack_roll_max(upgrades))
	var defense_roll := rng.randi_range(1, _defense_roll_max(bot_upgrades))
	if attack_roll <= defense_roll:
		_log("Raid failed. You rolled %d, %s defended with %d." % [attack_roll, BOT_NAME, defense_roll])
		_update_ui()
		return

	var damage := clampi(attack_roll - defense_roll, 1, 3)
	_stat_add("raids_won", 1)
	_damage_bot(damage)
	if not bot_live_well.is_empty():
		for batch in bot_live_well:
			live_well.append(batch)
		bot_live_well.clear()
		_log("Raid success: stole %s's fish and dealt %d damage." % [BOT_NAME, damage])
	else:
		_log("Raid success: dealt %d damage to %s." % [damage, BOT_NAME])
	if int(bot_conditions.get("hull", 0)) <= 0:
		_sink_bot("You sank %s." % BOT_NAME)
	_update_ui()


func _bot_attack_player() -> void:
	var attack_roll := rng.randi_range(1, _attack_roll_max(bot_upgrades))
	var defense_roll := rng.randi_range(1, _defense_roll_max(upgrades))
	if attack_roll <= defense_roll:
		_log("%s raids and misses. Attack %d vs defense %d." % [BOT_NAME, attack_roll, defense_roll])
		return

	var damage := clampi(attack_roll - defense_roll, 1, 3)
	_stat_add("raids_lost", 1)
	_stat_add("damage_taken", damage)
	_damage_player(damage)
	if not live_well.is_empty():
		for batch in live_well:
			bot_live_well.append(batch)
		live_well.clear()
		_log("%s raids successfully, steals your fish, and deals %d damage." % [BOT_NAME, damage])
	else:
		_log("%s raids successfully and deals %d damage." % [BOT_NAME, damage])
	if int(conditions.get("hull", 0)) <= 0:
		game_over = true
		_log("%s sank your boat." % BOT_NAME)


func _attack_roll_max(upgrade_dict: Dictionary) -> int:
	var cannons := int(upgrade_dict.get("cannons", 0))
	if cannons <= 0:
		return 0
	return 5 + cannons


func _defense_roll_max(upgrade_dict: Dictionary) -> int:
	return 6 + int(upgrade_dict.get("defense", 0))


func _damage_player(amount: int) -> void:
	var systems: Array[String] = ["hull", "propeller", "rudder", "nets"]
	for i in range(amount):
		var system: String = systems[rng.randi_range(0, systems.size() - 1)]
		conditions[system] = max(0, int(conditions.get(system, CONDITION_MAX)) - 1)


func _damage_bot(amount: int) -> void:
	var systems: Array[String] = ["hull", "propeller", "rudder", "nets"]
	for i in range(amount):
		var system: String = systems[rng.randi_range(0, systems.size() - 1)]
		bot_conditions[system] = max(0, int(bot_conditions.get(system, CONDITION_MAX)) - 1)


func _sink_bot(message: String) -> void:
	_log(message)
	bot_live_well.clear()
	bot_money = int(floor(float(bot_money) * 0.5))
	bot_pos = Vector2i(DOCK_COL, GRID_ROWS)
	bot_conditions = {
		"hull": CONDITION_MAX,
		"propeller": CONDITION_MAX,
		"rudder": CONDITION_MAX,
		"nets": CONDITION_MAX,
	}


func _bot_trophy_count() -> int:
	var count := 0
	for species in SPECIES:
		if bool(bot_trophies.get(species, false)):
			count += 1
	return count


# ────────────────────────────────────────────────────────────────────────
# UI refresh
# ────────────────────────────────────────────────────────────────────────

func _update_ui() -> void:
	_update_hud()
	_update_forecast()
	_update_top_market()
	_update_compact_ship_cards()
	_update_board()
	_update_dock_strip()
	_update_action_buttons()
	_update_tabs()
	_update_log_label()
	_update_boat_tab()
	_update_upgrade_cart_ui()
	_update_live_well_tab()
	_update_radio_tab()
	_update_tray()
	_save_game()


func _update_hud() -> void:
	_counter_set("stat_day", "%d/%d" % [day, _season_days()], true)
	_counter_set("stat_funds", "$%d" % money, true)
	if moves_remaining > 0:
		_counter_set("stat_moves", "%d" % moves_remaining, true, "MOVES")
	else:
		_counter_set("stat_moves", "GO", true, "END DAY")
	_counter_set("stat_finds", "%d" % finds_remaining, finds_remaining > 0)
	_counter_set("stat_casts", "%d" % casts_remaining, casts_remaining > 0)
	if ui.has("top_where"):
		if _is_docked():
			(ui["top_where"] as Label).text = "Docks"
		else:
			var tile: Dictionary = board[_cell_index(boat_pos)]
			(ui["top_where"] as Label).text = "%s Water" % str(tile["zone"])
	if ui.has("health_funds"):
		(ui["health_funds"] as Label).text = "Funds: $%d" % money
	if ui.has("upgrade_funds"):
		(ui["upgrade_funds"] as Label).text = "Funds: $%d" % money


func _update_forecast() -> void:
	if ui.has("forecast_slots"):
		var slots: Array = ui["forecast_slots"]
		for i in range(slots.size()):
			var slot: Control = slots[i]
			for child in slot.get_children():
				child.queue_free()
			var weather := current_weather
			if i > 0 and forecast.size() > 0:
				weather = forecast[min(i - 1, forecast.size() - 1)]
			slot.add_child(_hud_forecast_chip(weather, i == 0))
		return

	var row: HBoxContainer = ui["forecast_chips"]
	for child in row.get_children():
		child.queue_free()

	row.add_child(_forecast_chip(current_weather, true))
	for i in range(min(3, forecast.size())):
		row.add_child(_forecast_chip(forecast[i], false))


func _update_top_market() -> void:
	if ui.has("top_market_slots"):
		var slots: Array = ui["top_market_slots"]
		for i in range(min(slots.size(), SPECIES.size())):
			var slot: Control = slots[i]
			for child in slot.get_children():
				child.queue_free()
			slot.add_child(_hud_market_row(SPECIES[i]))
		return

	if not ui.has("top_market_rows"):
		return
	var rows: VBoxContainer = ui["top_market_rows"]
	for child in rows.get_children():
		child.queue_free()

	for species in SPECIES:
		var earned := bool(trophies.get(species, false))
		var card := _panel(BG_PANEL_DARK, GOLD_DEEP if earned else BORDER_DARK, 1, 4)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rows.add_child(card)

		var pad := MarginContainer.new()
		pad.add_theme_constant_override("margin_left", 8)
		pad.add_theme_constant_override("margin_right", 9)
		pad.add_theme_constant_override("margin_top", 5)
		pad.add_theme_constant_override("margin_bottom", 5)
		card.add_child(pad)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 9)
		pad.add_child(row)

		# Trophy: gold filled when earned, muted outline otherwise.
		var trophy := _icon_texture_rect(ICON_TROPHY_SOLID if earned else ICON_TROPHY_OUTLINE, Vector2(17, 17), GOLD if earned else Color("#5b6480"))
		trophy.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(trophy)

		var name := _label(species.to_upper(), 14, TEXT_PRIMARY if earned else TEXT_MUTED)
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(name)

		row.add_child(_label("$%d" % int(market_prices[species]), 16, GOLD, HORIZONTAL_ALIGNMENT_RIGHT))


func _update_board() -> void:
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var pos := Vector2i(col, row)
			var index := _cell_index(pos)
			var tile: Dictionary = board[index]
			var btn: Button = cell_buttons[index]

			var player_here := boat_pos == pos
			var bot_here := versus_mode and not _bot_is_docked() and bot_pos == pos
			var sharing := player_here and bot_here

			var bot_boat: TextureRect = btn.get_meta("bot_boat") as TextureRect
			var player_corner: TextureRect = btn.get_meta("player_boat_corner") as TextureRect
			var player_reticle: Control = btn.get_meta("player_reticle") as Control

			btn.icon = null
			btn.expand_icon = false
			btn.text = _cell_text(pos, tile)

			if bot_boat:
				bot_boat.visible = bot_here
			if player_corner:
				player_corner.visible = player_here
				_position_boat_layer(player_corner, "tl_half" if sharing else "full")
			if player_reticle:
				player_reticle.visible = player_here
			if sharing:
				if bot_boat:
					bot_boat.visible = true
					_position_boat_layer(bot_boat, "br_half")
			else:
				if bot_boat:
					_position_boat_layer(bot_boat, "full")

			if player_here:
				btn.text = ""
			elif bot_here:
				btn.text = ""

			var base_color := _board_zone_card_color(row)
			var label_color := TEXT_PRIMARY

			var known := bool(tile["found"]) or bool(tile["revealed"])
			var content_str := str(tile["content"])
			var is_fish := content_str == "fish"
			var is_treasure := content_str == "treasure"
			var is_depleted := bool(tile["depleted"])
			var is_revealed_empty := known and content_str == "empty"
			var is_dead_card := is_depleted or is_revealed_empty
			var show_fish_icon := known and is_fish and not is_depleted

			if is_dead_card:
				base_color = base_color.darkened(0.46)
				label_color = TEXT_DIM
			elif known and is_treasure:
				base_color = base_color.lerp(GOLD_DEEP.lightened(0.12), 0.50)
				label_color = TEXT_PRIMARY
			elif known and is_fish:
				base_color = base_color.lightened(0.04)
				label_color = TEXT_PRIMARY

			if player_here:
				base_color = base_color.lightened(0.08)
				label_color = TEXT_PRIMARY
			elif bot_here:
				base_color = base_color.lerp(RED_DEEP, 0.34)
				label_color = TEXT_PRIMARY

			_render_board_card_shell(btn, base_color, is_dead_card)
			btn.add_theme_color_override("font_color", label_color)

			var font_size := 14
			if player_here:
				font_size = FONT_BOAT
			elif known and not is_dead_card:
				font_size = FONT_CELL_BIG if is_treasure else FONT_CELL
			btn.add_theme_font_size_override("font_size", font_size)
			_update_cell_cast_dots(btn, tile, known and is_fish and not is_depleted, player_here or bot_here, label_color)
			_update_cell_markers(btn, tile, show_fish_icon, is_dead_card, player_here, bot_here)


func _update_board_presence_fx() -> void:
	var ping := fposmod(board_fx_time * 1.15, 1.0)
	var corner_alpha := 0.74 + 0.18 * ((sin(board_fx_time * TAU * 0.95) + 1.0) * 0.5)
	for btn in cell_buttons:
		if not is_instance_valid(btn):
			continue
		var reticle: Control = btn.get_meta("player_reticle", null) as Control
		if reticle == null or not reticle.visible:
			continue
		reticle.modulate = Color(1, 1, 1, corner_alpha)
		var beacon: Control = btn.get_meta("player_beacon", null) as Control
		if beacon:
			var scale := lerpf(0.72, 1.22, ping)
			beacon.scale = Vector2(scale, scale)
			beacon.modulate = Color(1, 1, 1, lerpf(0.54, 0.04, ping))


func _update_dock_strip() -> void:
	var btn: Button = ui["dock_strip"]
	var docked := _is_docked()
	var can_dock := _is_dock_access_cell(boat_pos)
	var dock_label: Label = btn.get_meta("dock_label") as Label
	var dock_boat: TextureRect = ui.get("dock_boat", null) as TextureRect

	btn.icon = null
	btn.text = ""
	if dock_label:
		dock_label.visible = true
	if dock_boat:
		dock_boat.visible = docked

	var dock_fill := Color("#142449")
	if docked:
		dock_fill = Color("#1e355a")
	elif can_dock:
		dock_fill = Color("#102d47")
	_render_dock_card_shell(btn, dock_fill)
	if dock_label:
		dock_label.add_theme_color_override("font_color", _with_alpha(Color.WHITE, 0.96 if (docked or can_dock) else 0.68))


func _update_action_buttons() -> void:
	var docked := _is_docked()
	var at_sea_keys: Array[String] = ["find", "cast", "end_day"]
	if versus_mode and not docked and not _bot_is_docked() and _distance_to_bot() <= 2:
		at_sea_keys = ["find", "cast", "attack", "end_day"]
	var at_dock_keys: Array[String] = ["sell", "upgrade", "repair", "end_day"]
	var visible_keys: Array[String] = at_dock_keys if docked else at_sea_keys

	for k in action_buttons.keys():
		var b: Button = action_buttons[k]
		b.visible = visible_keys.has(k)
		b.disabled = game_over or active_tray != ""
		b.set_meta("action_prompt", false)
		b.set_meta("action_subdued", false)

	if action_buttons["sell"].visible:
		action_buttons["sell"].disabled = action_buttons["sell"].disabled or live_well.is_empty()

	if action_buttons["find"].visible:
		action_buttons["find"].disabled = action_buttons["find"].disabled or finds_remaining <= 0

	if action_buttons["cast"].visible:
		action_buttons["cast"].disabled = action_buttons["cast"].disabled or not _can_attempt_cast_here()

	if action_buttons["attack"].visible:
		action_buttons["attack"].disabled = action_buttons["attack"].disabled or not _can_player_attack_bot()

	if action_buttons["end_day"].visible:
		var prompt_end_day := _should_prompt_end_day()
		action_buttons["end_day"].set_meta("action_prompt", prompt_end_day)
		action_buttons["end_day"].set_meta("action_subdued", not prompt_end_day)

	_set_action_count(action_buttons["cast"], casts_remaining)
	_set_action_count(action_buttons["find"], finds_remaining)
	for k in action_buttons.keys():
		_apply_action_visual_state(action_buttons[k])

	if ui.has("live_well_sell"):
		var sell: Button = ui["live_well_sell"]
		sell.disabled = game_over or not _is_docked() or live_well.is_empty()
		_apply_action_visual_state(sell)

	(ui["action_heading"] as Label).text = "AT THE DOCKS" if docked else "AT SEA"
	(ui["action_heading"] as Label).add_theme_color_override("font_color", GOLD if docked else CYAN)


func _update_tabs() -> void:
	for k in tab_buttons.keys():
		var b: Button = tab_buttons[k]
		var active: bool = k == active_tab
		if b.has_meta("icon_rect"):
			_apply_bottom_nav_style(b, active)
		else:
			_apply_tab_style(b, active)

	if ui.has("tab_health"):
		(ui["tab_health"] as Control).visible = active_tab == "health"
	if ui.has("tab_live_well"):
		(ui["tab_live_well"] as Control).visible = active_tab == "live_well"
	if ui.has("tab_map"):
		(ui["tab_map"] as Control).visible = active_tab == "map"
	if ui.has("tab_upgrades"):
		(ui["tab_upgrades"] as Control).visible = active_tab == "upgrades"
	if ui.has("tab_radio"):
		(ui["tab_radio"] as Control).visible = active_tab == "radio"


func _update_log_label() -> void:
	if ui.has("log_label"):
		(ui["log_label"] as Label).text = log_lines[0] if log_lines.size() > 0 else ""


func _update_boat_tab() -> void:
	for key in CONDITION_KEYS:
		var row: Control = boat_segment_panels.get("cond_" + key)
		if row:
			_refresh_segment_row(row, int(conditions[key]), false, key)
	for key in UPGRADE_KEYS:
		var row: Control = boat_segment_panels.get("up_" + key)
		if row:
			var actual := int(upgrades[key])
			_refresh_segment_row(row, _upgrade_cart_target(key), true, key, actual)


func _update_upgrade_cart_ui() -> void:
	var cost := _upgrade_cart_cost()
	var remaining := money - cost
	var showing_upgrade_controls := active_tray == "" or active_tray == "upgrade"
	_refresh_upgrade_store_lanes()
	if ui.has("upgrade_funds"):
		var funds: Label = ui["upgrade_funds"]
		funds.text = "Funds: $%d" % money
		funds.add_theme_color_override("font_color", TEXT_PRIMARY)
	if ui.has("upgrade_plan"):
		var plan: Label = ui["upgrade_plan"]
		plan.visible = showing_upgrade_controls
		var extra_text := ""
		if extra_night_cart > 0:
			extra_text = " · +%d night%s" % [extra_night_cart, "" if extra_night_cart == 1 else "s"]
		if cost > 0:
			plan.text = "Plan: $%d · Remaining: $%d%s" % [cost, remaining, extra_text]
		else:
			plan.text = "Pick a card lane to inspect the next upgrade."
		plan.add_theme_color_override("font_color", RED if remaining < 0 else (GOLD if cost > 0 else TEXT_MUTED))
	if ui.has("extra_night_count"):
		var nights: Label = ui["extra_night_count"]
		nights.visible = showing_upgrade_controls
		nights.text = "+%d" % extra_night_cart
		nights.add_theme_color_override("font_color", GOLD if extra_night_cart > 0 else TEXT_DIM)
	if ui.has("extra_night_add"):
		var add_btn: Button = ui["extra_night_add"]
		add_btn.visible = showing_upgrade_controls
		add_btn.disabled = game_over or not _is_docked()
	if ui.has("extra_night_remove"):
		var remove_btn: Button = ui["extra_night_remove"]
		remove_btn.visible = showing_upgrade_controls
		remove_btn.disabled = game_over or not _is_docked() or extra_night_cart <= 0
	if ui.has("upgrade_checkout"):
		var checkout: Button = ui["upgrade_checkout"]
		checkout.visible = showing_upgrade_controls and cost > 0
		checkout.disabled = game_over or not _is_docked() or cost <= 0 or remaining < 0
	if ui.has("upgrade_reset"):
		var reset: Button = ui["upgrade_reset"]
		reset.visible = showing_upgrade_controls and cost > 0
		reset.disabled = game_over or not _is_docked() or cost <= 0


func _update_live_well_tab() -> void:
	var col: VBoxContainer = ui["live_well_lines"]
	for child in col.get_children():
		child.queue_free()

	var cap := _live_well_days()
	var total_fish := 0
	for batch in live_well:
		total_fish += int(batch["quantity"])

	for age in range(cap + 1):
		var wrap := PanelContainer.new()
		var row_style := _styled(BG_PANEL_DARK if age % 2 == 0 else BG_PANEL, BORDER_DARK, 0, 4)
		row_style.content_margin_left = 12
		row_style.content_margin_right = 12
		row_style.content_margin_top = 8
		row_style.content_margin_bottom = 8
		wrap.add_theme_stylebox_override("panel", row_style)
		wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(wrap)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 14)
		wrap.add_child(row)

		var age_color := TEXT_PRIMARY
		if age == cap:
			age_color = GOLD
		elif age >= cap - 1 and cap > 1:
			age_color = CYAN
		var age_lbl := _label(_age_name(age).to_upper(), FONT_BODY, age_color)
		age_lbl.custom_minimum_size = Vector2(86, 0)
		row.add_child(age_lbl)

		var batch_parts: Array[String] = []
		var count_today := 0
		for batch in live_well:
			if int(batch["age"]) == age:
				batch_parts.append("%d %s" % [int(batch["quantity"]), str(batch["species"])])
				count_today += int(batch["quantity"])

		var count_lbl := _label("%d" % count_today, FONT_BODY, age_color if count_today > 0 else TEXT_DIM)
		count_lbl.custom_minimum_size = Vector2(36, 0)
		count_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		row.add_child(count_lbl)

		var fish_text := ", ".join(batch_parts) if not batch_parts.is_empty() else "—"
		var fish_color := TEXT_PRIMARY if not batch_parts.is_empty() else TEXT_DIM
		var fish_lbl := _label(fish_text, FONT_BODY, fish_color)
		fish_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(fish_lbl)

	(ui["live_well_status"] as Label).text = "%d aboard · spoils after %d days" % [total_fish, cap]


func _update_radio_tab() -> void:
	if ui.has("trophy_rows"):
		var trophy_rows: VBoxContainer = ui["trophy_rows"]
		for child in trophy_rows.get_children():
			child.queue_free()

		for species in SPECIES:
			var row := HBoxContainer.new()
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_theme_constant_override("separation", 8)
			trophy_rows.add_child(row)

			var earned := bool(trophies.get(species, false))
			row.add_child(_label("★" if earned else "☆", FONT_BODY, GOLD if earned else TEXT_DIM))
			var name := _label(species, FONT_BODY, TEXT_PRIMARY if earned else TEXT_MUTED)
			name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(name)
			row.add_child(_label("sell %d at once" % TROPHY_REQUIRED, FONT_SMALL, TEXT_DIM))

	if ui.has("radio_lines"):
		var lines: VBoxContainer = ui["radio_lines"]
		for child in lines.get_children():
			child.queue_free()
		var log_limit := 6
		if versus_mode:
			var bot_place := "docks" if _bot_is_docked() else "%s water" % str(board[_cell_index(bot_pos)]["zone"])
			lines.add_child(_label("%s: $%d · %d fish · %d trophies · %s" % [BOT_NAME, bot_money, _bot_total_fish(), _bot_trophy_count(), bot_place], FONT_BODY, RED))
			log_limit = 5
		for i in range(min(log_limit, log_lines.size())):
			lines.add_child(_label(log_lines[i], FONT_BODY, TEXT_PRIMARY if i == 0 else TEXT_MUTED))


func _update_compact_ship_cards() -> void:
	if not ui.has("compact_ship_cards"):
		return
	var grid: GridContainer = ui["compact_ship_cards"]
	for child in grid.get_children():
		child.queue_free()

	# Upgrades first (motor, finder, nets, well, guns, defense), ship health below — all on a 5-blip scale.
	for key in UPGRADE_KEYS:
		var value := int(upgrades.get(key, 0))
		var accent := PURPLE if value > 0 else TEXT_DIM
		grid.add_child(_compact_system_card(_upgrade_short_label(key), float(value), float(UPGRADE_MAX_LEVEL), 5, "%d/%d" % [value, UPGRADE_MAX_LEVEL], accent))

	for key in CONDITION_KEYS:
		var value := int(conditions.get(key, CONDITION_MAX))
		var ratio := float(value) / float(CONDITION_MAX)
		var accent := GREEN
		if ratio < 0.4:
			accent = RED
		elif ratio < 0.7:
			accent = GOLD
		grid.add_child(_compact_system_card(_condition_short_label(key), float(value), float(CONDITION_MAX), 5, "%d%%" % int(round(ratio * 100.0)), accent))


func _compact_system_card(title: String, value: float, max_value: float, pips: int, value_text: String, accent: Color) -> Control:
	var card := _panel(BG_PANEL_DARK.lerp(accent, 0.07), accent.darkened(0.25), 1, 4)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := _styled(BG_PANEL_DARK.lerp(accent, 0.07), accent.darkened(0.25), 1, 4)
	style.content_margin_left = 9
	style.content_margin_right = 9
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	card.add_theme_stylebox_override("panel", style)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 8)
	card.add_child(row)

	var title_label := _label(title, 14, TEXT_PRIMARY)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(title_label)

	var meter := _pip_meter(value, max_value, pips, accent)
	meter.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(meter)

	var num := _label(value_text, 13, accent, HORIZONTAL_ALIGNMENT_RIGHT)
	num.custom_minimum_size = Vector2(40, 0)
	num.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(num)
	return card


# `pips` playing-card-shaped blips, filled bottom-up to value/max_value (supports half-fills).
func _pip_meter(value: float, max_value: float, pips: int, accent: Color) -> Control:
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var step := max_value / float(pips)
	for i in range(pips):
		box.add_child(_card_pip(clampf((value - float(i) * step) / step, 0.0, 1.0), accent))
	return box


# One portrait card-shaped blip, filled from the bottom up to `fraction` (0..1).
func _card_pip(fraction: float, accent: Color) -> Control:
	var pip := Panel.new()
	pip.custom_minimum_size = Vector2(11, 17)
	pip.clip_contents = true
	var lit := fraction > 0.001
	var frame := StyleBoxFlat.new()
	frame.bg_color = Color("#1d2937")
	frame.border_color = accent.lightened(0.1) if lit else Color("#313e4d")
	frame.set_border_width_all(1)
	frame.set_corner_radius_all(3)
	frame.anti_aliasing = false
	pip.add_theme_stylebox_override("panel", frame)
	if lit:
		var full := fraction >= 0.999
		var fs := StyleBoxFlat.new()
		fs.bg_color = accent
		fs.corner_radius_bottom_left = 2
		fs.corner_radius_bottom_right = 2
		fs.corner_radius_top_left = 2 if full else 0
		fs.corner_radius_top_right = 2 if full else 0
		fs.anti_aliasing = false
		var fill := Panel.new()
		fill.add_theme_stylebox_override("panel", fs)
		fill.anchor_left = 0.0
		fill.anchor_right = 1.0
		fill.anchor_top = 1.0 - fraction
		fill.anchor_bottom = 1.0
		fill.offset_left = 1.0
		fill.offset_right = -1.0
		fill.offset_top = 1.0 if full else 0.0
		fill.offset_bottom = -1.0
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pip.add_child(fill)
	return pip


func _update_tray() -> void:
	if active_tray == "":
		return
	_pill_set_text(ui["tray_money"], "$%d" % money)
	if active_tray == "upgrade":
		_refresh_upgrade_store_lanes()
	elif active_tray == "repair":
		for key in CONDITION_KEYS:
			if repair_tray_rows.has(key):
				_refresh_segment_row(repair_tray_rows[key], int(conditions[key]), false, key)


# ────────────────────────────────────────────────────────────────────────
# Small helpers / widgets
# ────────────────────────────────────────────────────────────────────────

func _fish_texture(species: String) -> Texture2D:
	match species:
		"Cod":
			return FISH_COD_TEXTURE
		"Swordfish":
			return FISH_SWORDFISH_TEXTURE
		"Salmon":
			return FISH_SALMON_TEXTURE
		"Grouper":
			return FISH_GROUPER_TEXTURE
		"Halibut":
			return FISH_HALIBUT_TEXTURE
		"Tuna":
			return FISH_TUNA_TEXTURE
	return FISH_SWORDFISH_TEXTURE


func _fish_card_texture(species: String) -> Texture2D:
	match species:
		"Salmon":
			return CARD_SALMON_TEXTURE
		"Grouper":
			return CARD_GROUPER_TEXTURE
		"Halibut":
			return CARD_HALIBUT_TEXTURE
		"Tuna":
			return CARD_TUNA_TEXTURE
		"Swordfish":
			return CARD_SWORDFISH_TEXTURE
	return CARD_SWORDFISH_TEXTURE


func _board_fish_icon_texture(species: String) -> Texture2D:
	match species:
		"Salmon":
			return ICON_CARD_SALMON_TEXTURE
		"Grouper":
			return ICON_CARD_GROUPER_TEXTURE
		"Halibut":
			return ICON_CARD_HALIBUT_TEXTURE
		"Tuna":
			return ICON_CARD_TUNA_TEXTURE
		"Swordfish":
			return ICON_CARD_SWORDFISH_TEXTURE
	return ICON_CARD_SWORDFISH_TEXTURE


func _treasure_card_texture(value: int) -> Texture2D:
	if value >= 200:
		return CARD_TREASURE_200_TEXTURE
	return CARD_TREASURE_100_TEXTURE


func _species_accent(species: String) -> Color:
	match species:
		"Swordfish":
			return CYAN
		"Salmon":
			return RED
		"Grouper":
			return GREEN
		"Halibut":
			return GOLD
		"Tuna":
			return PURPLE
	return CYAN


func _species_from_key(key: String) -> String:
	match key.to_lower():
		"salmon", "sal":
			return "Salmon"
		"grouper", "grp":
			return "Grouper"
		"halibut", "hal":
			return "Halibut"
		"tuna", "tun":
			return "Tuna"
		"swordfish", "sword", "swd", "cod":
			return "Swordfish"
	return "Salmon"


func _weather_icon_texture(weather_name: String) -> Texture2D:
	match weather_name:
		"Storm":
			return ICON_STORM_TEXTURE
		"Hurricane":
			return ICON_HURRICANE_TEXTURE
	return ICON_CLEAR_TEXTURE


func _cell_text(pos: Vector2i, tile: Dictionary) -> String:
	if boat_pos == pos:
		return ""
	var known := bool(tile["found"]) or bool(tile["revealed"])
	if not known:
		return ""
	if bool(tile["depleted"]) or str(tile["content"]) == "empty":
		return ""
	if str(tile["content"]) == "treasure":
		return _treasure_board_label(tile)
	# Fish species are shown by the specific board-card fish icon.
	return ""


func _is_adjacent_to_boat(pos: Vector2i) -> bool:
	if _is_docked():
		return _is_dock_access_cell(pos)
	var d := pos - boat_pos
	return _is_adjacent_delta(d)


func _can_move_to_cell(pos: Vector2i) -> bool:
	if game_over or active_tray != "" or moves_remaining <= 0:
		return false
	if _is_docked():
		return _is_dock_access_cell(pos) and moves_remaining >= 1
	var delta := pos - boat_pos
	if not _is_adjacent_delta(delta):
		return false
	if abs(delta.x) == 1 and abs(delta.y) == 1 and int(conditions.get("rudder", CONDITION_MAX)) <= 0:
		return false
	return moves_remaining >= _move_cost(delta)


func _is_adjacent_delta(delta: Vector2i) -> bool:
	return delta != Vector2i.ZERO and abs(delta.x) <= 1 and abs(delta.y) <= 1


func _is_dock_col(col: int) -> bool:
	return col >= DOCK_START_COL and col <= DOCK_END_COL


func _is_dock_access_cell(pos: Vector2i) -> bool:
	return pos.y == GRID_ROWS - 1 and pos.x >= DOCK_ACCESS_START_COL and pos.x <= DOCK_ACCESS_END_COL


func _abbr(species: String) -> String:
	match species:
		"Cod":
			return "COD"
		"Salmon":
			return "SAL"
		"Grouper":
			return "GRP"
		"Halibut":
			return "HAL"
		"Tuna":
			return "TUN"
		"Swordfish":
			return "SWD"
	return species.substr(0, 3).to_upper()


func _cell_index(pos: Vector2i) -> int:
	return pos.y * GRID_COLS + pos.x


func _board_card_global_center(pos: Vector2i) -> Vector2:
	if pos.x < 0 or pos.x >= GRID_COLS or pos.y < 0 or pos.y >= GRID_ROWS:
		return Vector2(-1, -1)
	var index := _cell_index(pos)
	if index < 0 or index >= cell_buttons.size():
		return Vector2(-1, -1)
	var btn := cell_buttons[index]
	if not is_instance_valid(btn):
		return Vector2(-1, -1)
	return btn.get_global_rect().get_center()


func _animate_board_card_reveal(pos: Vector2i) -> void:
	if pos.x < 0 or pos.x >= GRID_COLS or pos.y < 0 or pos.y >= GRID_ROWS:
		return
	var index := _cell_index(pos)
	if index < 0 or index >= cell_buttons.size():
		return
	var btn := cell_buttons[index]
	if not is_instance_valid(btn):
		return
	var old_tween: Tween = null
	if btn.has_meta("board_card_tween"):
		old_tween = btn.get_meta("board_card_tween") as Tween
	if old_tween:
		old_tween.kill()
	var shell := _board_card_shell(btn)
	var tilt := float(btn.get_meta("card_tilt", 0.0))
	btn.pivot_offset = btn.size * 0.5
	btn.z_index = 24
	if shell:
		shell.z_index = 23
	var tween := btn.create_tween()
	btn.set_meta("board_card_tween", tween)
	tween.tween_property(btn, "scale", Vector2(0.18, 1.08), 0.08).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(btn, "rotation_degrees", tilt + 3.4, 0.08).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	if shell:
		tween.parallel().tween_property(shell, "scale", Vector2(0.18, 1.08), 0.08).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(shell, "rotation_degrees", tilt + 3.4, 0.08).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(btn, "scale", Vector2(1.10, 1.06), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(btn, "rotation_degrees", tilt - 1.2, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if shell:
		tween.parallel().tween_property(shell, "scale", Vector2(1.10, 1.06), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(shell, "rotation_degrees", tilt - 1.2, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "scale", Vector2.ONE, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(btn, "rotation_degrees", tilt, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if shell:
		tween.parallel().tween_property(shell, "scale", Vector2.ONE, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(shell, "rotation_degrees", tilt, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var card_shell := shell
	tween.tween_callback(func():
		if is_instance_valid(btn):
			btn.z_index = 0
		if is_instance_valid(card_shell):
			card_shell.z_index = 0
	)


func _is_docked() -> bool:
	return boat_pos.y == GRID_ROWS


func _trophy_count() -> int:
	var count := 0
	for species in SPECIES:
		if bool(trophies.get(species, false)):
			count += 1
	return count


func _log(message: String) -> void:
	log_lines.push_front(message)
	while log_lines.size() > 6:
		log_lines.pop_back()


func _age_name(age: int) -> String:
	if age == 0:
		return "Fresh"
	if age == 1:
		return "1 day"
	return "%d days" % age


# ────────────────────────────────────────────────────────────────────────
# Styled widget builders
# ────────────────────────────────────────────────────────────────────────

func _label(text: String, size: int, color: Color = TEXT_PRIMARY, align: int = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = align
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_font_override("font", FONT_BALATRO)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l


func _hud_label(text: String, size: int, color: Color = TEXT_PRIMARY, align: int = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := _label(text, size, color, align)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.add_theme_constant_override("outline_size", 2)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.72))
	return l


func _hud_count_label(text: String) -> Label:
	var l := _hud_label(text, 30, NEON_COMPUTER_YELLOW, HORIZONTAL_ALIGNMENT_CENTER)
	l.add_theme_constant_override("outline_size", 2)
	l.add_theme_color_override("font_outline_color", Color("#2a2100"))
	return l


func _hud_day_count() -> HBoxContainer:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 0)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var current := _hud_count_part_label("", NEON_COMPUTER_YELLOW)
	var total := _hud_count_part_label("", Color(NEON_COMPUTER_YELLOW.r, NEON_COMPUTER_YELLOW.g, NEON_COMPUTER_YELLOW.b, 0.30))
	row.add_child(current)
	row.add_child(total)
	row.set_meta("current_label", current)
	row.set_meta("total_label", total)
	return row


func _hud_count_part_label(text: String, color: Color) -> Label:
	var l := _label(text, 30, color, HORIZONTAL_ALIGNMENT_CENTER)
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.add_theme_constant_override("outline_size", 2)
	l.add_theme_color_override("font_outline_color", Color("#2a2100"))
	return l


func _hud_count_caption_label(text: String, size: int) -> Label:
	var l := _hud_label(text, size, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	return l


func _icon_texture_rect(texture: Texture2D, size: Vector2, tint: Color) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = texture
	icon.custom_minimum_size = size
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	icon.modulate = tint
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return icon


func _anchor_fill(node: Control, inset: float = 0.0) -> void:
	node.anchor_left = inset
	node.anchor_top = inset
	node.anchor_right = 1.0 - inset
	node.anchor_bottom = 1.0 - inset
	node.offset_left = 0
	node.offset_top = 0
	node.offset_right = 0
	node.offset_bottom = 0


func _place_hud_zone(parent: Control, node: Control, zone: Rect2) -> void:
	var source_size := Vector2(1633, 831)
	node.anchor_left = zone.position.x / source_size.x
	node.anchor_top = zone.position.y / source_size.y
	node.anchor_right = (zone.position.x + zone.size.x) / source_size.x
	node.anchor_bottom = (zone.position.y + zone.size.y) / source_size.y
	node.offset_left = 0
	node.offset_top = 0
	node.offset_right = 0
	node.offset_bottom = 0
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(node)


func _nudge_hud_zone(node: Control, delta: Vector2) -> void:
	node.offset_left += delta.x
	node.offset_right += delta.x
	node.offset_top += delta.y
	node.offset_bottom += delta.y


func _section_label(text: String) -> Label:
	var l := _label(text, FONT_HEADER, TEXT_MUTED)
	l.add_theme_constant_override("line_spacing", 0)
	return l


func _panel(fill: Color, border: Color, border_w: int, radius: int) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _styled(fill, border, border_w, radius))
	return p


func _styled(fill: Color, border: Color, border_w: int, radius: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fill
	s.border_color = border
	s.set_border_width_all(border_w)
	s.set_corner_radius_all(radius)
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	s.anti_aliasing = false
	s.anti_aliasing_size = 0.0
	return s


func _transparent_style() -> StyleBoxFlat:
	var s := _styled(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0, 0)
	s.content_margin_left = 0
	s.content_margin_right = 0
	s.content_margin_top = 0
	s.content_margin_bottom = 0
	return s


# A layout container with no visible chrome — its content sits flat on the app background.
func _bare_panel() -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	return p


func _with_alpha(color: Color, alpha: float) -> Color:
	var c := color
	c.a = alpha
	return c


func _styled_shadow(fill: Color, border: Color, border_w: int, radius: int, shadow_size: int) -> StyleBoxFlat:
	var s := _styled(fill, border, border_w, radius)
	s.shadow_color = SHADOW
	s.shadow_size = shadow_size
	s.shadow_offset = Vector2(0, max(1, shadow_size / 3))
	return s


# Panels meant to sit one layer above the canvas with a modest contact shadow.
func _panel_lifted(fill: Color, border: Color, border_w: int, radius: int, shadow_size: int = 6) -> PanelContainer:
	var p := PanelContainer.new()
	var s := _styled_shadow(fill, border, border_w, radius, shadow_size)
	s.shadow_color = Color(0, 0, 0, 0.36)
	s.shadow_offset = Vector2(0, max(1, shadow_size / 3))
	p.add_theme_stylebox_override("panel", s)
	return p


# Recessed "channel" — content reads as inset into the panel. Darker fill,
# bright thin top border simulates a lip.
func _panel_inset(fill: Color, border: Color, radius: int) -> PanelContainer:
	var p := PanelContainer.new()
	var s := _styled(fill, border, 1, radius)
	s.bg_color = fill
	s.border_color = Color(0, 0, 0, 0.55)
	s.border_width_top = 2
	s.border_width_bottom = 0
	s.border_width_left = 1
	s.border_width_right = 1
	s.content_margin_left = 6
	s.content_margin_right = 6
	s.content_margin_top = 5
	s.content_margin_bottom = 5
	p.add_theme_stylebox_override("panel", s)
	return p


func _divider(color: Color, height: int = 1) -> ColorRect:
	var r := ColorRect.new()
	r.color = color
	r.custom_minimum_size = Vector2(0, height)
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


# Per-row water color in three discrete depth bands.
func _row_water_color(row: int) -> Color:
	if row <= 1:
		return _with_alpha(Color("#062f44"), 0.72)
	if row <= 3:
		return _with_alpha(Color("#0a4a66"), 0.44)
	return _with_alpha(Color("#000000"), 0.0)


func _board_zone_card_color(row: int) -> Color:
	if row <= 1:
		return Color("#0f4fa8")
	if row <= 3:
		return Color("#2f79d8")
	return Color("#6b9bd8")


func _water_cell_style(fill: Color, border: Color, border_w: int, highlight: bool, padding: int = -1, pos: Vector2i = Vector2i(-1, -1)) -> StyleBoxFlat:
	var s := _styled(fill, border, 0, 0)
	s.shadow_size = 0
	s.anti_aliasing = false
	if pos.x >= 0:
		s.border_width_left = border_w
		s.border_width_top = border_w
		s.border_width_right = border_w if pos.x == GRID_COLS - 1 else 0
		s.border_width_bottom = border_w if pos.y == GRID_ROWS - 1 else 0
	if highlight:
		s.border_color = border.lightened(0.16)
	if padding >= 0:
		s.content_margin_left = padding
		s.content_margin_right = padding
		s.content_margin_top = padding
		s.content_margin_bottom = padding
	return s


func _update_cell_markers(btn: Button, tile: Dictionary, show_fish: bool, dead_card: bool, player_here: bool, bot_here: bool) -> void:
	var fish_icon: TextureRect = null
	if btn.has_meta("fish_icon"):
		fish_icon = btn.get_meta("fish_icon") as TextureRect
	var dead_x: Control = null
	if btn.has_meta("dead_x"):
		dead_x = btn.get_meta("dead_x") as Control

	if dead_x:
		dead_x.visible = dead_card

	if fish_icon:
		var show_fish_icon := show_fish and not dead_card and not player_here and not bot_here
		if show_fish_icon:
			fish_icon.texture = _board_fish_icon_texture(str(tile.get("species", "")))
			fish_icon.modulate = Color(1, 1, 1, 0.96)
			fish_icon.visible = true
		else:
			fish_icon.visible = false


func _update_cell_cast_dots(btn: Button, tile: Dictionary, show: bool, has_boat: bool, color: Color) -> void:
	if not btn.has_meta("cast_dots"):
		return

	var dots: VBoxContainer = btn.get_meta("cast_dots")
	for child in dots.get_children():
		child.queue_free()

	var total := int(tile.get("casts_total", 0))
	if not show or total <= 0:
		dots.visible = false
		return

	dots.visible = true
	var remaining := clampi(int(tile.get("casts_remaining", 0)), 0, total)
	var spent := total - remaining
	var dot_color := BG_DEEP if has_boat else color

	for i in range(total):
		var dot := _label("●", 14, dot_color, HORIZONTAL_ALIGNMENT_CENTER)
		dot.custom_minimum_size = Vector2(8, 10)
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if i < spent:
			dot.modulate = Color(1, 1, 1, 0.3)
		dots.add_child(dot)


# The lab now showcases the single settled Bloom motion across the different result /
# label types: a normal catch, a special "effect" card (e.g. "+2 Luck"), a multiplier,
# and treasure. Each merges its content over the shared Bloom options.
# origin_viewport_* fakes a board cell so you can see cards launch from a specific point.
func _catch_fan_preview_variant(key: String) -> Dictionary:
	var content: Dictionary = {}
	match key:
		"b":
			# Effect / scoring card — distinct indigo accent.
			content = {
				"texture_kind": "effect",
				"label": "+2 LUCK",
				"quantity": 2,
				"total_accent": INDIGO,
				"unit_accent": INDIGO,
				"origin_viewport_x": 0.34,
				"origin_viewport_y": 0.86,
			}
		"c":
			# Multiplier catch — purple "special scoring" accent.
			content = {
				"species": "Grouper",
				"quantity": 4,
				"multiplier": 2,
				"label": "+4 GROUPER",
				"mult_label": "X2 MULT",
				"mult_accent": GOLD,
				"total_accent": _species_accent("Grouper"),
				"unit_accent": GREEN,
				"origin_viewport_x": 0.66,
				"origin_viewport_y": 0.80,
			}
		"d":
			# Treasure — gold accent, single card.
			content = {
				"texture_kind": "treasure",
				"label": "+$200 TREASURE",
				"quantity": 1,
				"total_accent": GOLD,
				"unit_accent": GOLD,
				"origin_viewport_x": 0.5,
				"origin_viewport_y": 0.9,
			}
		_:
			# Normal fish catch.
			content = {
				"species": "Tuna",
				"quantity": 5,
				"label": "+5 TUNA",
				"total_accent": _species_accent("Tuna"),
				"unit_accent": GREEN,
				"origin_viewport_x": 0.5,
				"origin_viewport_y": 0.82,
			}
	var opts := _bloom_fan_options()
	opts.merge(content, true)
	return opts


func _show_fan_preview_variant(config: Dictionary) -> void:
	var species := str(config.get("species", "Salmon"))
	var quantity: int = clampi(int(config.get("quantity", 4)), 1, CATCH_CARD_MAX_DRAW)
	var total_accent: Color = config.get("total_accent", _species_accent(species))
	var unit_accent: Color = config.get("unit_accent", GREEN)
	var total_label := str(config.get("label", ""))
	if total_label == "":
		var multiplier: int = max(1, int(config.get("multiplier", 1)))
		total_label = "+%d %s" % [quantity, species.to_upper()]
		if multiplier > 1:
			total_label += "  X%d MULT" % multiplier
	var texture: Texture2D = _fish_card_texture(species)
	match str(config.get("texture_kind", "fish")):
		"treasure":
			texture = CARD_TREASURE_200_TEXTURE
		"effect":
			texture = CARD_TREASURE_NIGHT_TEXTURE
	var card_badge_text := str(config.get("card_badge_text", ""))
	var card_badge_accent: Color = config.get("card_badge_accent", total_accent)
	# The lab has no real cast cell, so fake a board origin from a viewport fraction
	# to demonstrate cards launching from a specific point. Gameplay passes the real cell.
	var vp := get_viewport().get_visible_rect().size
	var origin := Vector2(vp.x * float(config.get("origin_viewport_x", 0.5)), vp.y * float(config.get("origin_viewport_y", 0.82)))
	_show_card_result_fan(texture, quantity, total_label, total_accent, unit_accent, card_badge_text, card_badge_accent, origin, config)


# Seconds from the start of the cascade until the big total label slams in.
# Shared by the playback (to time the total/exit) and the lab (to pace variants).
func _catch_total_appear_delay(quantity: int, options: Dictionary) -> float:
	var card_count: int = mini(clampi(quantity, 1, CATCH_CARD_MAX_DRAW), CATCH_CARD_MAX_DRAW)
	if card_count <= 1:
		return float(options.get("single_total_delay", 0.12))
	var draw_stagger := float(options.get("draw_stagger", CATCH_CARD_DRAW_STAGGER))
	var draw_seconds := float(options.get("draw_seconds", CATCH_CARD_DRAW_SECONDS))
	var total := float(card_count - 1) * draw_stagger + draw_seconds
	if str(options.get("style", "")) == "stack_spread":
		total += float(options.get("spread_delay", 0.2)) + float(options.get("spread_seconds", 0.46))
	return total + float(options.get("total_pop_delay", CATCH_TOTAL_POP_DELAY))


func _catch_fan_sequence_seconds(config: Dictionary) -> float:
	var total_delay := _catch_total_appear_delay(int(config.get("quantity", 4)), config)
	return total_delay + float(config.get("exit_hold", 2.0)) + float(config.get("overlay_hide_pad", 0.26)) + 0.32


# The one canonical card-fan motion (Bloom) — used by every gameplay result and the
# lab. Cards rise in an arc and unfurl into a deep, widening fan. Single source of
# truth for the whole bloom aesthetic (timing, shape, card/label styling).
func _bloom_fan_options() -> Dictionary:
	return {
		"style": "bloom",
		"draw_stagger": CATCH_CARD_DRAW_STAGGER,
		"draw_seconds": CATCH_CARD_DRAW_SECONDS,
		"total_pop_delay": CATCH_TOTAL_POP_DELAY,
		"unit_pop_pause": 0.14,
		"widen_seconds": 0.34,
		"arc_height": 72.0,
		"spread_step": 80.0,
		"spread_max": 86.0,
		"spread_viewport": 0.64,
		"fan_rotation": 9.4,
		"fan_sag": 13.0,
		"start_scale": 0.5,
		"start_rotation": -22.0,
		"label_hold": 1.6,
		"exit_hold": 1.68,
		"card_border": 1,
		"card_radius": 18,
		"card_inner_margin": 7,
		"corner_style": "none",
		"shadow_offset": Vector2(10, 16),
		"shadow_alpha_min": 0.12,
		"shadow_alpha_max": 0.38,
		"shadow_spacing": 11,
		"label_font_size": 36,
		"label_border": 2,
		"label_radius": 10,
	}


func _show_catch_card_fan(species: String, quantity: int, multiplier: int = 1, origin_center: Vector2 = Vector2(-1, -1)) -> void:
	var label := "+%d %s" % [quantity, species]
	var opts := _bloom_fan_options()
	if multiplier > 1:
		opts["mult_label"] = "X%d MULT" % multiplier
		opts["mult_accent"] = GOLD
	_show_card_result_fan(_fish_card_texture(species), quantity, label, _species_accent(species), GREEN, "", Color(0, 0, 0, 0), origin_center, opts)


# Forward-looking: special / scoring cards (e.g. "+2 Luck") render like a catch but
# in a distinct accent. Texture defaults to a placeholder until real effect art exists.
func _show_effect_card_fan(label: String, amount: int = 1, accent: Color = INDIGO, origin_center: Vector2 = Vector2(-1, -1), texture: Texture2D = CARD_TREASURE_NIGHT_TEXTURE) -> void:
	_show_card_result_fan(texture, max(1, amount), label, accent, accent, "", Color(0, 0, 0, 0), origin_center, _bloom_fan_options())


func _show_finder_card_fan(species: String, casts: int, origin_center: Vector2 = Vector2(-1, -1)) -> void:
	var cast_count: int = max(1, casts)
	var noun := "CAST" if cast_count == 1 else "CASTS"
	var label := "%s X%d %s" % [species.to_upper(), cast_count, noun]
	var opts := _bloom_fan_options()
	opts["plonk"] = false
	_show_card_result_fan(_fish_card_texture(species), 1, label, _species_accent(species), PURPLE, "X%d" % cast_count, PURPLE, origin_center, opts)


func _show_treasure_card_fan(tile: Dictionary, origin_center: Vector2 = Vector2(-1, -1)) -> void:
	if _is_paid_night_treasure(tile):
		_show_card_result_fan(CARD_TREASURE_NIGHT_TEXTURE, 1, "+1 Paid Night", GOLD, CYAN, "", Color(0, 0, 0, 0), origin_center, _bloom_fan_options())
		return
	var value: int = int(tile.get("value", 0))
	_show_card_result_fan(_treasure_card_texture(value), 1, "+$%d Treasure" % value, GOLD, GOLD, "", Color(0, 0, 0, 0), origin_center, _bloom_fan_options())


func _show_card_result_fan(card_texture: Texture2D, quantity: int, total_label: String, total_accent: Color, unit_accent: Color, card_badge_text: String = "", card_badge_accent: Color = Color(0, 0, 0, 0), origin_center: Vector2 = Vector2(-1, -1), options: Dictionary = {}) -> void:
	if quantity <= 0 or not ui.has("catch_card_overlay") or not ui.has("catch_card_layer"):
		return

	catch_card_token += 1
	var token := catch_card_token
	if ui.has("catch_card_overlay_tween"):
		var old_tween: Tween = ui["catch_card_overlay_tween"]
		if old_tween:
			old_tween.kill()
	if ui.has("catch_card_hide_tween"):
		var old_hide: Tween = ui["catch_card_hide_tween"]
		if old_hide:
			old_hide.kill()
	if ui.has("catch_card_driver_tween"):
		var old_driver: Tween = ui["catch_card_driver_tween"]
		if old_driver:
			old_driver.kill()

	var overlay: Control = ui["catch_card_overlay"]
	var layer: Control = ui["catch_card_layer"]
	_clear_catch_card_layer()
	overlay.visible = true
	overlay.modulate = Color(1, 1, 1, 0)
	layer.modulate = Color(1, 1, 1, 1)

	var overlay_tween := overlay.create_tween()
	ui["catch_card_overlay_tween"] = overlay_tween
	overlay_tween.tween_property(overlay, "modulate:a", 1.0, float(options.get("overlay_fade_seconds", 0.10)))

	var viewport_size := get_viewport().get_visible_rect().size
	var card_size := _catch_card_size(viewport_size) * float(options.get("card_size_scale", 1.0))
	var card_count: int = mini(quantity, CATCH_CARD_MAX_DRAW)
	var style := str(options.get("style", "bloom"))
	var growth_mode := "stack" if style == "stack_spread" else "fan"
	var center := Vector2(viewport_size.x * 0.5, viewport_size.y * float(options.get("center_y", 0.50)))

	# Every card launches from a single spawn point. With a valid origin (the cast
	# cell) the cards spit out of that board square and the fan blooms just above it.
	var has_origin := origin_center.x >= 0.0 and origin_center.y >= 0.0
	var spawn := Vector2(viewport_size.x + card_size.x * 0.75, viewport_size.y * float(options.get("start_y", 0.30)))
	if str(options.get("start_side", "right")) == "left":
		spawn.x = -card_size.x * 0.75
	if has_origin:
		# Cards launch from the cast cell, but the fan always assembles dead-center of the screen.
		spawn = origin_center

	var draw_stagger := float(options.get("draw_stagger", CATCH_CARD_DRAW_STAGGER))
	var draw_seconds := float(options.get("draw_seconds", CATCH_CARD_DRAW_SECONDS))
	var widen_seconds := float(options.get("widen_seconds", 0.24))
	var start_scale := float(options.get("start_scale", 0.72))
	var start_rotation := float(options.get("start_rotation", 12.0))
	var stack_rise := float(options.get("stack_rise", 4.5))
	var stack_jitter := float(options.get("stack_jitter", 7.0))
	var stack_rot := float(options.get("stack_rot", 5.0))

	# Build every card up front, stacked invisibly at the spawn point.
	var cards: Array[Control] = []
	var card_anims: Array = []  # Array[Array[Tween]] — live tweens per card, killed on retarget.
	for i in range(card_count):
		var card := _build_result_card(card_texture, card_size, card_badge_text, card_badge_accent, options)
		var jitter := Vector2(_fan_jitter(i, 0) * 5.0, -float(i % 3) * 3.0)
		card.position = (spawn + jitter) - card_size * 0.5
		card.rotation = deg_to_rad(start_rotation + _fan_jitter(i, 1) * 4.0)
		card.scale = Vector2(start_scale, start_scale)
		card.modulate = Color(1, 1, 1, 0)
		card.z_index = i
		layer.add_child(card)
		cards.append(card)
		card_anims.append([])

	var total_center := center + Vector2(0, card_size.y * float(options.get("total_label_card_y", -0.86)))

	# Deals card m: animate it in, widen the cards already down, pop its own "+1", plonk.
	var deal_card := func(m: int) -> void:
		if token != catch_card_token:
			return
		var n := m + 1
		if growth_mode == "stack":
			var spos := center + Vector2(_fan_jitter(m, 2) * stack_jitter, -float(m) * stack_rise)
			var stack_target := {"pos": spos - card_size * 0.5, "rot": deg_to_rad(_fan_jitter(m, 3) * stack_rot), "scale": 1.0}
			_animate_card_entry(cards, card_anims, m, stack_target, style, draw_seconds, options)
		else:
			var layout := _fan_layout(n, center, card_size, viewport_size, options)
			_animate_card_entry(cards, card_anims, m, layout[m], style, draw_seconds, options)
			for i in range(m):
				_retarget_fan_card(cards, card_anims, i, layout[i], widen_seconds, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		# Count this card once it has settled: a "+1" attached to the card pops after a beat, with its plonk.
		var count_at := draw_seconds + float(options.get("unit_pop_pause", 0.14))
		if card_count > 1:
			_attach_card_unit_pop(cards[m], unit_accent, count_at, options)
		if bool(options.get("plonk", true)):
			var pidx := m
			var plonk_sched := layer.create_tween()
			plonk_sched.tween_interval(count_at)
			plonk_sched.tween_callback(func():
				if token == catch_card_token:
					_play_catch_plonk(pidx)
			)

	# Drive the cascade: one card per stagger beat.
	var driver := layer.create_tween()
	ui["catch_card_driver_tween"] = driver
	driver.tween_callback(deal_card.bind(0))
	for m in range(1, card_count):
		driver.tween_interval(draw_stagger)
		driver.tween_callback(deal_card.bind(m))

	# Stack concept: after the suspense beat, the whole pile fans open at once.
	if growth_mode == "stack" and card_count > 1:
		var spread_delay := float(options.get("spread_delay", 0.2))
		var spread_seconds := float(options.get("spread_seconds", 0.46))
		var spread_stagger := float(options.get("spread_stagger", 0.022))
		var spread_at := float(card_count - 1) * draw_stagger + draw_seconds + spread_delay
		var spread_sched := layer.create_tween()
		spread_sched.tween_interval(spread_at)
		spread_sched.tween_callback(func():
			if token != catch_card_token:
				return
			var layout := _fan_layout(card_count, center, card_size, viewport_size, options)
			for i in range(card_count):
				_retarget_fan_card(cards, card_anims, i, layout[i], spread_seconds, Tween.TRANS_BACK, Tween.EASE_OUT, float(i) * spread_stagger)
		)

	# The big species total slams in; a multiplier (if any) is its own colored pill below it.
	var total_delay := _catch_total_appear_delay(card_count, options)
	_schedule_catch_total_bug(layer, total_label, total_accent, total_center, total_delay, token, options)
	var mult_label := str(options.get("mult_label", ""))
	if mult_label != "":
		var mult_accent: Color = options.get("mult_accent", GOLD)
		var mult_center := total_center + Vector2(0, float(options.get("label_height", 74.0)) * 0.5 + 34.0)
		var mult_opts := options.duplicate()
		mult_opts["label_font_size"] = int(options.get("mult_font_size", 30))
		mult_opts["label_height"] = float(options.get("mult_height", 54.0))
		mult_opts["label_width_base"] = 90.0
		mult_opts["label_width_min"] = float(options.get("mult_width_min", 150.0))
		mult_opts["label_scale_peak"] = 1.14
		mult_opts["label_rotation_degrees"] = 2.4
		_schedule_catch_total_bug(layer, mult_label, mult_accent, mult_center, total_delay + 0.1, token, mult_opts)

	var exit_delay := total_delay + float(options.get("exit_hold", 2.00))
	_schedule_catch_cards_exit(layer, cards, exit_delay, token, options)
	_schedule_catch_overlay_hide(overlay, exit_delay + float(options.get("overlay_hide_pad", 0.26)), token)


# Positions/rotations for an n-card fan centered on `center`. Recomputed each time
# a card lands so the spread visibly widens as the catch grows.
func _fan_layout(n: int, center: Vector2, card_size: Vector2, viewport_size: Vector2, options: Dictionary) -> Array:
	var spread_step := float(options.get("spread_step", 74.0))
	var spread_width: float = minf(viewport_size.x * float(options.get("spread_viewport", 0.60)), card_size.x + float(maxi(0, n - 1)) * spread_step)
	var spread := 0.0
	if n > 1:
		spread = minf(float(options.get("spread_max", 76.0)), (spread_width - card_size.x) / float(n - 1))
	var mid := float(n - 1) * 0.5
	var fan_sag := float(options.get("fan_sag", 8.0))
	var fan_rotation := float(options.get("fan_rotation", 7.6))
	var max_rotation := float(options.get("max_rotation", 30.0))
	var out: Array = []
	for i in range(n):
		var offset := float(i) - mid
		var c := center + Vector2(offset * spread, absf(offset) * fan_sag)
		out.append({
			"pos": c - card_size * 0.5,
			"rot": deg_to_rad(clampf(offset * fan_rotation, -max_rotation, max_rotation)),
			"scale": 1.0,
			"center": c,
		})
	return out


# Deterministic pseudo-random in [-1, 1) so jitter is stable across runs (no RNG state).
func _fan_jitter(i: int, salt: int) -> float:
	var v := sin(float(i) * 12.9898 + float(salt) * 78.233) * 43758.5453
	return (v - floor(v)) * 2.0 - 1.0


func _kill_card_anim(card_anims: Array, i: int) -> void:
	if i < 0 or i >= card_anims.size():
		return
	var arr: Array = card_anims[i]
	for t in arr:
		if t is Tween and t.is_valid():
			t.kill()
	arr.clear()


# Animates card i from wherever it is into `target`, with motion specific to the concept.
func _animate_card_entry(cards: Array, card_anims: Array, i: int, target: Dictionary, style: String, seconds: float, options: Dictionary) -> void:
	if i < 0 or i >= cards.size():
		return
	var card: Control = cards[i]
	if not is_instance_valid(card):
		return
	_kill_card_anim(card_anims, i)
	var dest: Vector2 = target["pos"]
	var rot: float = target["rot"]
	var sc := float(target.get("scale", 1.0))
	match style:
		"bloom":
			var apex := card.position.lerp(dest, 0.5) + Vector2(0, -float(options.get("arc_height", 66.0)))
			var t := card.create_tween()
			t.tween_property(card, "position", apex, seconds * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			t.tween_property(card, "position", dest, seconds * 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			var t2 := card.create_tween()
			t2.tween_property(card, "scale", Vector2(sc, sc), seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			t2.parallel().tween_property(card, "rotation", rot, seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			t2.parallel().tween_property(card, "modulate:a", 1.0, seconds * 0.5)
			card_anims[i].append(t)
			card_anims[i].append(t2)
		"toss":
			var apex := dest + Vector2(_fan_jitter(i, 4) * 10.0, -float(options.get("toss_height", 52.0)))
			var t := card.create_tween()
			t.tween_property(card, "position", apex, seconds * 0.42).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			t.tween_property(card, "position", dest, seconds * 0.58).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			var t2 := card.create_tween()
			t2.tween_property(card, "scale", Vector2(sc, sc), seconds).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			t2.parallel().tween_property(card, "rotation", rot, seconds).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			t2.parallel().tween_property(card, "modulate:a", 1.0, seconds * 0.4)
			card_anims[i].append(t)
			card_anims[i].append(t2)
		_:
			# "deal" and "stack_spread" both fly straight in with a crisp settle.
			var t := card.create_tween()
			t.tween_property(card, "position", dest, seconds).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			t.parallel().tween_property(card, "rotation", rot, seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			t.parallel().tween_property(card, "scale", Vector2(sc, sc), seconds).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			t.parallel().tween_property(card, "modulate:a", 1.0, seconds * 0.45)
			card_anims[i].append(t)


# Smoothly slides an already-placed card to a new slot (the "widen" as the fan grows,
# or the "spread" when the stack opens). pre_delay staggers the spread outward.
func _retarget_fan_card(cards: Array, card_anims: Array, i: int, target: Dictionary, seconds: float, pos_trans: int, pos_ease: int, pre_delay: float = 0.0) -> void:
	if i < 0 or i >= cards.size():
		return
	var card: Control = cards[i]
	if not is_instance_valid(card):
		return
	_kill_card_anim(card_anims, i)
	var sc := float(target.get("scale", 1.0))
	var t := card.create_tween()
	if pre_delay > 0.0:
		t.tween_interval(pre_delay)
	t.tween_property(card, "position", target["pos"], seconds).set_trans(pos_trans).set_ease(pos_ease)
	t.parallel().tween_property(card, "rotation", target["rot"], seconds).set_trans(Tween.TRANS_CUBIC).set_ease(pos_ease)
	t.parallel().tween_property(card, "scale", Vector2(sc, sc), seconds).set_trans(Tween.TRANS_CUBIC).set_ease(pos_ease)
	t.parallel().tween_property(card, "modulate:a", 1.0, minf(seconds, 0.12))
	card_anims[i].append(t)


# The running "+N" counter that builds the catch above the fan.
## A "+1" attached as a child of its card — pops once the card has settled (after `delay`), then
## fades. Living on the card, it moves and tilts with it, so it reads as that card's count (not loose).
func _attach_card_unit_pop(card: Control, accent: Color, delay: float, options: Dictionary = {}) -> void:
	if not is_instance_valid(card):
		return
	var pop_opts := options.duplicate()
	pop_opts["label_border"] = int(options.get("unit_label_border", 2))
	pop_opts["label_radius"] = int(options.get("unit_label_radius", 8))
	pop_opts["label_shadow_size"] = int(options.get("unit_label_shadow_size", 6))
	pop_opts["label_outline_size"] = int(options.get("unit_label_outline_size", 3))
	var size := Vector2(float(options.get("unit_width", 70.0)), float(options.get("unit_height", 46.0)))
	var pop := _catch_label_bug("+1", int(options.get("unit_font_size", 30)), accent, size, pop_opts)
	# Centered just above the card's top edge, in the card's local space (rides along with the card).
	pop.position = Vector2(card.size.x * 0.5 - size.x * 0.5, -size.y * 0.78)
	pop.pivot_offset = size * 0.5
	pop.scale = Vector2(0.3, 0.3)
	pop.modulate = Color(1, 1, 1, 0)
	pop.z_index = 40
	card.add_child(pop)
	var t := pop.create_tween()
	t.tween_interval(delay)
	t.tween_property(pop, "scale", Vector2(1.14, 1.14), 0.11).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(pop, "modulate:a", 1.0, 0.08)
	t.tween_property(pop, "scale", Vector2.ONE, 0.09).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_interval(0.16)
	t.tween_property(pop, "modulate:a", 0.0, 0.16)
	t.tween_callback(pop.queue_free)
	var drift := pop.create_tween()
	drift.tween_interval(delay)
	drift.tween_property(pop, "position:y", pop.position.y - 12.0, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _clear_catch_card_layer() -> void:
	if not ui.has("catch_card_layer"):
		return
	var layer: Control = ui["catch_card_layer"]
	for child in layer.get_children():
		child.queue_free()


func _catch_card_size(viewport_size: Vector2) -> Vector2:
	var width := clampf(viewport_size.x * 0.105, 104.0, 154.0)
	return Vector2(width, width * CATCH_CARD_ASPECT)


func _build_result_card(card_texture: Texture2D, card_size: Vector2, badge_text: String = "", badge_accent: Color = Color(0, 0, 0, 0), options: Dictionary = {}) -> Control:
	var card := Control.new()
	card.custom_minimum_size = card_size
	card.size = card_size
	card.pivot_offset = card_size * 0.5
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var fill: Color = options.get("card_fill", Color("#011244"))
	var m := _add_squarestep_card_shell(card, card_size, fill, options)
	var face := _gallery_face(card_texture)
	face.position = Vector2(m, m)
	face.size = Vector2(card_size.x - 2.0 * m, card_size.y - 2.0 * m)
	card.add_child(face)

	if badge_text != "":
		_add_card_badge(card, card_size, badge_text, badge_accent, options)
	return card


# ── Card-edge gallery ──────────────────────────────────────────────────────
# Four techniques for a lightly-rounded, pixel-square full card with an inner
# white edge that follows the rounding. Preview via ?catch_preview=cardgallery.

func _gallery_face(tex: Texture2D) -> TextureRect:
	var face := TextureRect.new()
	face.texture = tex
	face.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	face.stretch_mode = TextureRect.STRETCH_SCALE
	face.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	face.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	face.size_flags_vertical = Control.SIZE_EXPAND_FILL
	return face


func _gallery_card_base(card_size: Vector2) -> Control:
	var card := Control.new()
	card.custom_minimum_size = card_size
	card.size = card_size
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return card


func _gallery_rect(parent: Control, x: float, y: float, w: float, h: float, color: Color) -> void:
	var rect := ColorRect.new()
	rect.color = color
	rect.position = Vector2(x, y)
	rect.size = Vector2(w, h)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(rect)


# A — nested StyleBoxFlat panels: dark outline → white fill ring → art backing.
func _gallery_chunky_rrect(parent: Control, ox: float, oy: float, w: float, h: float, color: Color, steps: int, sp: int) -> void:
	var total := float(steps * sp)
	_gallery_rect(parent, ox, oy + total, w, h - 2.0 * total, color)
	for s in range(steps):
		var inset := float((steps - s) * sp)
		var yt := float(s * sp)
		_gallery_rect(parent, ox + inset, oy + yt, w - 2.0 * inset, float(sp), color)
		_gallery_rect(parent, ox + inset, oy + h - yt - float(sp), w - 2.0 * inset, float(sp), color)


# A clearly-staggered pixel card: near-black 2px outline + thick cream border, both following a
# chunky steps×sp-pixel staircase corner. The art sits inside, past the steps.
func _gallery_card_stepped(tex: Texture2D, card_size: Vector2, steps: int, sp: int, border: int) -> Control:
	var card := _gallery_card_base(card_size)
	var w := card_size.x
	var h := card_size.y
	# Three concentric staircases: dark outline → solid-white border → card-bg fill. Because every
	# layer follows the same step shape, BOTH edges of the white border step. (#011244 = the card
	# art's background, so the inner fill is seamless. border is a multiple of sp to stay uniform.)
	_gallery_chunky_rrect(card, 0.0, 0.0, w, h, Color("#0a0e14"), steps, sp)
	_gallery_chunky_rrect(card, 2.0, 2.0, w - 4.0, h - 4.0, Color("#ffffff"), steps, sp)
	var ci := 2.0 + float(border)
	_gallery_chunky_rrect(card, ci, ci, w - 2.0 * ci, h - 2.0 * ci, Color("#011244"), steps, sp)
	var m := ci + float(steps * sp)
	var face := _gallery_face(tex)
	face.position = Vector2(m, m)
	face.size = Vector2(w - 2.0 * m, h - 2.0 * m)
	card.add_child(face)
	return card


func _run_card_gallery() -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false
	await get_tree().create_timer(0.35).timeout
	if not ui.has("catch_card_overlay") or not ui.has("catch_card_layer"):
		return
	catch_card_token += 1
	var overlay: Control = ui["catch_card_overlay"]
	var layer: Control = ui["catch_card_layer"]
	_clear_catch_card_layer()
	overlay.visible = true
	overlay.modulate = Color(1, 1, 1, 1)
	var vp := get_viewport().get_visible_rect().size
	var tex := _fish_card_texture("Tuna")
	var card_size := Vector2(210, 284)
	var captions := ["A — 2x4 (your pick)", "B — bigger 2x5", "C — thicker border", "D — 3 steps"]
	var gap := 50.0
	var total_w := card_size.x * 4.0 + gap * 3.0
	var start_x := (vp.x - total_w) * 0.5
	var cy := vp.y * 0.5
	for i in range(4):
		var made: Control
		match i:
			0:
				made = _gallery_card_stepped(tex, card_size, 2, 4, 8)
			1:
				made = _gallery_card_stepped(tex, card_size, 2, 5, 10)
			2:
				made = _gallery_card_stepped(tex, card_size, 2, 4, 12)
			_:
				made = _gallery_card_stepped(tex, card_size, 3, 4, 8)
		var cx := start_x + float(i) * (card_size.x + gap)
		made.position = Vector2(cx, cy - card_size.y * 0.5)
		layer.add_child(made)
		var lbl := _label(captions[i], 18, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
		lbl.position = Vector2(cx, cy - card_size.y * 0.5 - 38.0)
		lbl.size = Vector2(card_size.x, 28)
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer.add_child(lbl)


func _schedule_catch_cards_exit(layer: Control, cards: Array[Control], delay: float, token: int, options: Dictionary = {}) -> void:
	var scheduler := layer.create_tween()
	scheduler.tween_interval(delay)
	scheduler.tween_callback(func():
		if token != catch_card_token or not is_instance_valid(layer):
			return
		var exit_stagger := float(options.get("exit_stagger", 0.018))
		var exit_seconds := float(options.get("exit_seconds", 0.28))
		var exit_fade_seconds := float(options.get("exit_fade_seconds", 0.22))
		var exit_lift := float(options.get("exit_lift", 72.0))
		var exit_scale := float(options.get("exit_scale", 0.86))
		for i in range(cards.size()):
			var card := cards[i]
			if not is_instance_valid(card):
				continue
			var exit_tween := card.create_tween()
			exit_tween.tween_interval(float(i) * exit_stagger)
			exit_tween.tween_property(card, "position:y", card.position.y - exit_lift, exit_seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			exit_tween.parallel().tween_property(card, "scale", Vector2(exit_scale, exit_scale), exit_seconds).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			exit_tween.parallel().tween_property(card, "modulate:a", 0.0, exit_fade_seconds)
	)


func _schedule_catch_overlay_hide(overlay: Control, delay: float, token: int) -> void:
	var scheduler := overlay.create_tween()
	ui["catch_card_hide_tween"] = scheduler
	scheduler.tween_interval(delay)
	scheduler.tween_callback(func():
		if token != catch_card_token or not is_instance_valid(overlay):
			return
		var fade := overlay.create_tween()
		ui["catch_card_hide_tween"] = fade
		fade.tween_property(overlay, "modulate:a", 0.0, 0.22)
		fade.tween_callback(func():
			if token == catch_card_token:
				overlay.visible = false
				_clear_catch_card_layer()
		)
	)


func _add_halftone_card_shadow(card: Control, card_size: Vector2, options: Dictionary = {}) -> void:
	var shadow := Control.new()
	shadow.position = options.get("shadow_offset", Vector2(13, 15))
	shadow.size = card_size
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(shadow)

	var spacing := int(options.get("shadow_spacing", 12))
	var dot_size := int(options.get("shadow_dot_size", 4))
	var alpha_min := float(options.get("shadow_alpha_min", 0.18))
	var alpha_max := float(options.get("shadow_alpha_max", 0.52))
	for y in range(10, int(card_size.y) + 28, spacing):
		for x in range(10, int(card_size.x) + 26, spacing):
			var grid_sum := int(x / spacing) + int(y / spacing)
			if grid_sum % 2 != 0:
				continue
			var diagonal := (float(x) / maxf(card_size.x, 1.0) + float(y) / maxf(card_size.y, 1.0)) * 0.5
			if diagonal < 0.25:
				continue
			var dot := ColorRect.new()
			dot.color = _with_alpha(Color("#00152d"), lerpf(alpha_min, alpha_max, clampf(diagonal, 0.0, 1.0)))
			dot.position = Vector2(x, y)
			dot.size = Vector2(dot_size, dot_size)
			dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
			shadow.add_child(dot)


func _add_card_badge(card: Control, card_size: Vector2, text: String, accent: Color, options: Dictionary = {}) -> void:
	var badge_size := Vector2(clampf(38.0 + float(text.length()) * 8.0, 48.0, 76.0), 30.0)
	var badge := PanelContainer.new()
	badge.custom_minimum_size = badge_size
	badge.size = badge_size
	badge.position = Vector2(card_size.x - badge_size.x - float(options.get("badge_inset", 10.0)), float(options.get("badge_inset", 10.0)))
	badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	badge.z_index = 14
	var style := _styled_shadow(accent.darkened(0.24), Color("#fbfdff"), int(options.get("badge_border", 2)), int(options.get("badge_radius", 8)), 5)
	style.anti_aliasing = bool(options.get("badge_antialias", true))
	style.anti_aliasing_size = 0.6
	style.content_margin_left = 7
	style.content_margin_right = 7
	style.content_margin_top = 1
	style.content_margin_bottom = 2
	style.shadow_color = _with_alpha(Color("#00152d"), 0.74)
	style.shadow_offset = Vector2(3, 4)
	badge.add_theme_stylebox_override("panel", style)

	var label := _label(text, 17, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color("#071829"))
	badge.add_child(label)
	card.add_child(badge)


func _schedule_catch_total_bug(layer: Control, label: String, accent: Color, center: Vector2, delay: float, _token: int, options: Dictionary = {}) -> void:
	var width := clampf(float(options.get("label_width_base", 170.0)) + float(label.length()) * float(options.get("label_width_per_char", 17.0)), float(options.get("label_width_min", 320.0)), float(options.get("label_width_max", 590.0)))
	var bug := _catch_label_bug(label, int(options.get("label_font_size", 38)), accent, Vector2(width, float(options.get("label_height", 74.0))), options)
	bug.position = center - bug.size * 0.5
	bug.pivot_offset = bug.size * 0.5
	bug.scale = Vector2(0.48, 0.48)
	bug.modulate = Color(1, 1, 1, 0)
	bug.z_index = 80
	layer.add_child(bug)

	var alpha_tween := bug.create_tween()
	alpha_tween.tween_interval(delay)
	alpha_tween.tween_property(bug, "modulate:a", 1.0, 0.08)
	alpha_tween.tween_interval(float(options.get("label_hold", 2.05)))
	alpha_tween.tween_property(bug, "modulate:a", 0.0, 0.20)
	alpha_tween.tween_callback(bug.queue_free)

	var scale_tween := bug.create_tween()
	scale_tween.tween_interval(delay)
	var scale_peak := float(options.get("label_scale_peak", 1.08))
	scale_tween.tween_property(bug, "scale", Vector2(scale_peak, scale_peak), float(options.get("label_scale_seconds", 0.18))).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(bug, "scale", Vector2.ONE, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	var rotation_tween := bug.create_tween()
	rotation_tween.tween_interval(delay)
	rotation_tween.tween_property(bug, "rotation", deg_to_rad(float(options.get("label_rotation_degrees", -1.8))), 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	var drift_tween := bug.create_tween()
	drift_tween.tween_interval(delay + float(options.get("label_hold", 2.05)) + 0.08)
	drift_tween.tween_property(bug, "position:y", bug.position.y - float(options.get("label_exit_lift", 34.0)), 0.20).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)


func _catch_label_bug(text: String, font_size: int, accent: Color, bug_size: Vector2, options: Dictionary = {}) -> PanelContainer:
	var bug := PanelContainer.new()
	bug.custom_minimum_size = bug_size
	bug.size = bug_size
	bug.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := _styled_shadow(accent.darkened(float(options.get("label_darken", 0.32))), Color("#fbfdff"), int(options.get("label_border", 2)), int(options.get("label_radius", 8)), int(options.get("label_shadow_size", 10)))
	style.anti_aliasing = bool(options.get("label_antialias", false))
	style.anti_aliasing_size = 0.6
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 3
	style.content_margin_bottom = 5
	style.shadow_color = _with_alpha(Color("#00152d"), 0.72)
	style.shadow_offset = options.get("label_shadow_offset", Vector2(7, 9))
	bug.add_theme_stylebox_override("panel", style)

	var label := _label(text, font_size, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_constant_override("outline_size", int(options.get("label_outline_size", 3)))
	label.add_theme_color_override("font_outline_color", Color("#071829"))
	bug.add_child(label)
	return bug


func _show_card_tooltip(title: String, effect: String, badge: String, accent: Color, anchor_global: Vector2, badge_accent: Color = Color(0, 0, 0, 0)) -> void:
	if not ui.has("card_tooltip_overlay") or not ui.has("card_tooltip_panel"):
		return
	card_tooltip_token += 1
	var token := card_tooltip_token
	var overlay: Control = ui["card_tooltip_overlay"]
	var panel: Panel = ui["card_tooltip_panel"]
	var pad: MarginContainer = ui["card_tooltip_pad"]
	var col: VBoxContainer = ui["card_tooltip_col"]
	var title_label: Label = ui["card_tooltip_title"]
	var effect_box: PanelContainer = ui["card_tooltip_effect_box"]
	var effect_label: Label = ui["card_tooltip_effect"]
	var badge_panel: PanelContainer = ui["card_tooltip_badge"]
	var badge_label: Label = ui["card_tooltip_badge_label"]

	if badge_accent.a == 0.0:
		badge_accent = accent

	title_label.text = title
	title_label.add_theme_color_override("font_color", TEXT_PRIMARY)
	effect_label.text = effect
	badge_label.text = badge

	var panel_style := _styled_shadow(Color("#3f4b4f"), Color("#fbfdff"), 3, 7, 10)
	panel_style.content_margin_left = 0
	panel_style.content_margin_right = 0
	panel_style.content_margin_top = 0
	panel_style.content_margin_bottom = 0
	panel_style.shadow_color = _with_alpha(Color("#00152d"), 0.68)
	panel_style.shadow_offset = Vector2(7, 8)
	panel.add_theme_stylebox_override("panel", panel_style)

	var effect_style := _styled(Color("#fafdff"), Color.WHITE, 2, 5)
	effect_style.content_margin_left = 12
	effect_style.content_margin_right = 12
	effect_style.content_margin_top = 8
	effect_style.content_margin_bottom = 8
	effect_box.add_theme_stylebox_override("panel", effect_style)

	var badge_style := _styled_shadow(badge_accent.darkened(0.16), badge_accent.darkened(0.34), 1, 8, 4)
	badge_style.content_margin_left = 18
	badge_style.content_margin_right = 18
	badge_style.content_margin_top = 4
	badge_style.content_margin_bottom = 5
	badge_style.shadow_color = _with_alpha(Color("#00152d"), 0.48)
	badge_style.shadow_offset = Vector2(4, 5)
	badge_panel.add_theme_stylebox_override("panel", badge_style)
	badge_label.add_theme_color_override("font_color", TEXT_PRIMARY)

	var viewport_size := get_viewport().get_visible_rect().size
	var effect_chars := int(ceil(float(effect.length()) * 0.52))
	var widest_chars: int = maxi(title.length(), effect_chars)
	var overflow_chars: int = maxi(0, effect.length() - 58)
	var width := clampf(286.0 + float(widest_chars) * 5.4, 330.0, 500.0)
	var height := clampf(138.0 + float(overflow_chars) * 0.46, 138.0, 198.0)
	var panel_size := Vector2(width, height)
	title_label.custom_minimum_size = Vector2(width - 28.0, 30.0)
	effect_box.custom_minimum_size = Vector2(width - 28.0, 44.0)
	effect_label.custom_minimum_size = Vector2(width - 56.0, 30.0)
	badge_panel.custom_minimum_size = Vector2(clampf(128.0 + float(badge.length()) * 8.0, 190.0, width - 84.0), 36.0)
	panel.custom_minimum_size = panel_size
	panel.size = panel_size
	panel.pivot_offset = Vector2(panel_size.x * 0.5, panel_size.y)
	pad.position = Vector2.ZERO
	pad.custom_minimum_size = panel_size
	pad.size = panel_size
	col.custom_minimum_size = Vector2(width - 28.0, maxf(0.0, height - 24.0))
	col.size = col.custom_minimum_size

	var anchor := anchor_global
	if anchor.x < 0.0 or anchor.y < 0.0:
		anchor = viewport_size * 0.5
	else:
		anchor = overlay.get_global_transform().affine_inverse() * anchor_global

	var pos := anchor + Vector2(-panel_size.x * 0.5, -panel_size.y - 20.0)
	if pos.y < 14.0:
		pos.y = anchor.y + 24.0
	pos.x = clampf(pos.x, 14.0, viewport_size.x - panel_size.x - 14.0)
	pos.y = clampf(pos.y, 14.0, viewport_size.y - panel_size.y - 14.0)

	if ui.has("card_tooltip_tween"):
		var old_tween: Tween = ui["card_tooltip_tween"]
		if old_tween:
			old_tween.kill()

	overlay.visible = true
	panel.visible = true
	panel.position = pos + Vector2(0, 8)
	panel.scale = Vector2(0.92, 0.92)
	panel.modulate = Color(1, 1, 1, 0)

	var tween := panel.create_tween()
	ui["card_tooltip_tween"] = tween
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.12)
	tween.tween_property(panel, "position", pos, 0.16).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.set_parallel(false)
	tween.tween_interval(3.45)
	tween.tween_callback(_hide_card_tooltip.bind(token))


func _hide_card_tooltip(expected_token: int = -1) -> void:
	if expected_token >= 0 and expected_token != card_tooltip_token:
		return
	if expected_token < 0:
		card_tooltip_token += 1
	if ui.has("card_tooltip_tween"):
		var old_tween: Tween = ui["card_tooltip_tween"]
		if old_tween:
			old_tween.kill()
	if not ui.has("card_tooltip_overlay") or not ui.has("card_tooltip_panel"):
		return
	var overlay: Control = ui["card_tooltip_overlay"]
	var panel: Panel = ui["card_tooltip_panel"]
	if not overlay.visible or not panel.visible:
		overlay.visible = false
		panel.visible = false
		return
	var fade := panel.create_tween()
	ui["card_tooltip_tween"] = fade
	fade.tween_property(panel, "modulate:a", 0.0, 0.10)
	fade.parallel().tween_property(panel, "position:y", panel.position.y - 8.0, 0.10)
	fade.tween_callback(func():
		panel.visible = false
		overlay.visible = false
	)


func _on_card_tooltip_panel_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_hide_card_tooltip()


func _show_owned_upgrade_card_tooltip(key: String, level: int, anchor_node: Control) -> void:
	if not UPGRADE_KEYS.has(key) or level <= 0:
		return
	var anchor := Vector2(-1, -1)
	if is_instance_valid(anchor_node):
		anchor = anchor_node.get_global_rect().get_center()
	var accent := _upgrade_accent(key)
	_show_card_tooltip(
		_upgrade_name(key).to_upper(),
		_upgrade_effect_text(key, level),
		"OWNED CARD %d/%d" % [level, UPGRADE_MAX_LEVEL],
		accent,
		anchor,
		GREEN
	)
	_play_catch_plonk(0)


func _show_board_card_tooltip(pos: Vector2i) -> bool:
	var payload := _board_card_tooltip_payload(pos)
	if payload.is_empty():
		return false
	_show_card_tooltip(
		str(payload.get("title", "")),
		str(payload.get("effect", "")),
		str(payload.get("badge", "")),
		payload.get("accent", CYAN),
		_board_card_global_center(pos),
		payload.get("badge_accent", payload.get("accent", CYAN))
	)
	return true


func _board_card_tooltip_payload(pos: Vector2i) -> Dictionary:
	if pos.x < 0 or pos.x >= GRID_COLS or pos.y < 0 or pos.y >= GRID_ROWS:
		return {}
	var tile: Dictionary = board[_cell_index(pos)]
	var known := bool(tile.get("found", false)) or bool(tile.get("revealed", false)) or bool(tile.get("depleted", false))
	if not known:
		return {}
	# Squares the boat has already visited don't need a tooltip — they get in the way.
	if bool(tile.get("visited", false)):
		return {}

	var content := str(tile.get("content", "empty"))
	if content == "fish":
		var species := str(tile.get("species", "Fish"))
		var total := int(tile.get("casts_total", 0))
		var remaining := int(tile.get("casts_remaining", 0))
		var cast_word := "cast" if total == 1 else "casts"
		var badge := "%d REMAINING" % remaining
		var badge_color := CYAN if remaining > 1 else RED
		if bool(tile.get("depleted", false)):
			badge = "DEPLETED"
			badge_color = RED
		return {
			"title": species.to_upper(),
			"effect": "%s hole: %d %s total. %d remaining." % [species, total, cast_word, remaining],
			"badge": badge,
			"accent": _species_accent(species),
			"badge_accent": badge_color,
		}

	if content == "treasure":
		var recovered := bool(tile.get("depleted", false))
		if _is_paid_night_treasure(tile):
			return {
				"title": "PAID NIGHT",
				"effect": "+1 night at sea%s." % (" recovered" if recovered else " hidden here"),
				"badge": "RECOVERED" if recovered else "ITEM",
				"accent": CYAN,
				"badge_accent": CYAN if not recovered else GOLD,
			}
		var value := int(tile.get("value", 0))
		return {
			"title": "TREASURE",
			"effect": "$%d cash%s." % [value, " recovered" if recovered else " hidden here"],
			"badge": "RECOVERED" if recovered else "ITEM",
			"accent": GOLD,
			"badge_accent": GOLD,
		}

	var empty_badge := "USED" if bool(tile.get("depleted", false)) else "EMPTY"
	return {
		"title": "EMPTY WATER",
		"effect": "No fish or item in this card.",
		"badge": empty_badge,
		"accent": TEXT_MUTED,
		"badge_accent": RED if bool(tile.get("depleted", false)) else TEXT_DIM,
	}


func _show_board_toast(title: String, detail: String, accent: Color = CYAN, fish_texture: Texture2D = null) -> void:
	if not ui.has("board_toast"):
		return

	var toast: PanelContainer = ui["board_toast"]
	var fish_art: TextureRect = ui["board_toast_fish"]
	var title_label: Label = ui["board_toast_title"]
	var detail_label: Label = ui["board_toast_detail"]
	fish_art.texture = fish_texture
	fish_art.visible = fish_texture != null
	title_label.text = title
	title_label.add_theme_color_override("font_color", TEXT_PRIMARY)
	detail_label.text = detail
	detail_label.add_theme_color_override("font_color", TEXT_MUTED)

	var style := _styled_shadow(BG_PANEL_DARK, accent, 2, 5, 8)
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	toast.add_theme_stylebox_override("panel", style)

	if ui.has("board_toast_tween"):
		var old_tween: Tween = ui["board_toast_tween"]
		if old_tween:
			old_tween.kill()

	toast.visible = true
	toast.modulate = Color(1, 1, 1, 0)
	toast.offset_top = -135 if fish_texture != null else -42
	toast.offset_bottom = 195 if fish_texture != null else 86

	var tween := create_tween()
	ui["board_toast_tween"] = tween
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(toast, "modulate:a", 1.0, 0.18)
	tween.tween_property(toast, "offset_top", -165.0 if fish_texture != null else -64.0, 0.18)
	tween.tween_property(toast, "offset_bottom", 165.0 if fish_texture != null else 64.0, 0.18)
	tween.set_parallel(false)
	tween.tween_interval(1.15)
	tween.tween_property(toast, "modulate:a", 0.0, 0.28)
	tween.tween_callback(func(): toast.visible = false)


func _show_day_transition() -> void:
	var days_left: int = max(0, _season_days() - day + 1)
	var detail := "%d days remain" % days_left
	if days_left == 1:
		detail = "Final day"
	_show_board_toast("DAY %d" % day, detail.to_upper(), GOLD)


func _tactile_button(text: String, min_w: int, min_h: int, fill: Color, border: Color, label_color: Color) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT_BALATRO)
	b.add_theme_font_size_override("font_size", FONT_BODY)
	b.add_theme_color_override("font_color", label_color)
	b.add_theme_color_override("font_hover_color", label_color)
	b.add_theme_color_override("font_pressed_color", label_color)
	b.add_theme_color_override("font_disabled_color", TEXT_DIM)
	b.custom_minimum_size = Vector2(min_w, min_h)
	_add_button_chrome(b, border)
	_apply_tactile_style(b, fill, border)
	return b


func _add_button_chrome(b: Button, border: Color) -> void:
	var shine := ColorRect.new()
	shine.color = Color(1, 1, 1, 0.10)
	shine.anchor_left = 0.0
	shine.anchor_right = 1.0
	shine.anchor_top = 0.0
	shine.anchor_bottom = 0.0
	shine.offset_left = 2
	shine.offset_right = -2
	shine.offset_top = 2
	shine.offset_bottom = 4
	shine.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(shine)

	var lip := ColorRect.new()
	lip.color = border.darkened(0.28)
	lip.anchor_left = 0.0
	lip.anchor_right = 1.0
	lip.anchor_top = 1.0
	lip.anchor_bottom = 1.0
	lip.offset_left = 2
	lip.offset_right = -2
	lip.offset_top = -5
	lip.offset_bottom = -2
	lip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(lip)

	b.set_meta("button_shine", shine)
	b.set_meta("button_lip", lip)


func _apply_tactile_style(b: Button, fill: Color, border: Color) -> void:
	var normal := _styled_shadow(fill, border, 2, 4, 4)
	normal.shadow_color = Color(0, 0, 0, 0.42)
	normal.shadow_offset = Vector2(0, 3)
	normal.content_margin_top = 6
	normal.content_margin_bottom = 8

	var hover := _styled_shadow(fill.lightened(0.07), border.lightened(0.16), 2, 4, 4)
	hover.shadow_color = Color(0, 0, 0, 0.42)
	hover.shadow_offset = Vector2(0, 3)
	hover.content_margin_top = 6
	hover.content_margin_bottom = 8

	var press := _styled(fill.darkened(0.14), border.darkened(0.08), 2, 4)
	press.content_margin_top = 9
	press.content_margin_bottom = 5

	var disabled := _styled(fill.darkened(0.42), Color(TEXT_DIM.r, TEXT_DIM.g, TEXT_DIM.b, 0.24), 2, 4)
	disabled.content_margin_top = 6
	disabled.content_margin_bottom = 8

	var focus := _styled_shadow(fill.lightened(0.04), BORDER_HI, 2, 4, 4)
	focus.shadow_color = Color(CYAN.r, CYAN.g, CYAN.b, 0.22)
	focus.shadow_offset = Vector2(0, 0)
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", press)
	b.add_theme_stylebox_override("disabled", disabled)
	b.add_theme_stylebox_override("focus", focus)

	if b.has_meta("button_lip"):
		var lip: ColorRect = b.get_meta("button_lip")
		lip.color = border.darkened(0.30)
	if b.has_meta("button_shine"):
		var shine: ColorRect = b.get_meta("button_shine")
		shine.color = Color(1, 1, 1, 0.11)


func _action_button(text: String, kind: String, callback: Callable, has_count: bool = false) -> Button:
	var palette := _action_palette(kind)
	var fill: Color = palette["fill"]
	var border: Color = palette["border"]
	var label_color: Color = palette["text"]
	var b := _tactile_button("", 0, 76, fill, border, label_color)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_font_size_override("font_size", FONT_ACTION)
	b.pressed.connect(callback)
	b.set_meta("action_fill", fill)
	_apply_block_action_style(b, fill, border)
	if b.has_meta("button_shine"):
		(b.get_meta("button_shine") as ColorRect).visible = false
	if b.has_meta("button_lip"):
		(b.get_meta("button_lip") as ColorRect).visible = false

	b.set_meta("action_border", border)
	b.set_meta("action_text_color", label_color)

	# Custom content: label + optional count pill, both ignoring mouse so the
	# parent Button still receives clicks.
	var content := HBoxContainer.new()
	content.anchor_right = 1.0
	content.anchor_bottom = 1.0
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 10)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(content)

	var lbl := _label(text, FONT_ACTION, label_color)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(lbl)
	b.set_meta("action_label", lbl)

	if has_count:
		var badge := PanelContainer.new()
		var badge_style := _styled(label_color.darkened(0.05), label_color.darkened(0.3), 1, 14)
		badge_style.content_margin_left = 16
		badge_style.content_margin_right = 16
		badge_style.content_margin_top = 5
		badge_style.content_margin_bottom = 5
		badge.add_theme_stylebox_override("panel", badge_style)
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		badge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var count_lbl := _label("0", FONT_PILL, fill.darkened(0.6), HORIZONTAL_ALIGNMENT_CENTER)
		count_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		count_lbl.custom_minimum_size = Vector2(16, 0)
		badge.add_child(count_lbl)
		badge.set_meta("count_label", count_lbl)
		b.set_meta("count_badge", badge)
		content.add_child(badge)

	return b


func _apply_block_action_style(b: Button, fill: Color, border: Color) -> void:
	# Chunky rounded style with a thick border, matching the left-rail counter buttons.
	var normal := _styled_shadow(fill, border, 4, 9, 5)
	normal.shadow_color = Color(0, 0, 0, 0.5)
	normal.shadow_offset = Vector2(0, 4)
	normal.content_margin_top = 11
	normal.content_margin_bottom = 12

	var hover := _styled_shadow(fill.lightened(0.06), border.lightened(0.16), 4, 9, 5)
	hover.shadow_color = Color(0, 0, 0, 0.5)
	hover.shadow_offset = Vector2(0, 4)
	hover.content_margin_top = 11
	hover.content_margin_bottom = 12

	# Pressed state: drop the shadow + nudge content so the button "settles down".
	var press := _styled(fill.darkened(0.12), border.darkened(0.08), 4, 9)
	press.content_margin_top = 14
	press.content_margin_bottom = 9

	var disabled := _styled(fill.darkened(0.32), Color(BORDER_DARK.r, BORDER_DARK.g, BORDER_DARK.b, 0.90), 4, 9)
	disabled.content_margin_top = 11
	disabled.content_margin_bottom = 12

	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", press)
	b.add_theme_stylebox_override("disabled", disabled)
	b.add_theme_stylebox_override("focus", normal)


func _set_action_count(b: Button, count: int) -> void:
	if not b.has_meta("count_badge"):
		return
	var badge: PanelContainer = b.get_meta("count_badge")
	if not badge:
		return
	var lbl: Label = badge.get_meta("count_label")
	if lbl:
		lbl.text = str(count)


func _apply_action_visual_state(b: Button) -> void:
	var text_color := TEXT_PRIMARY
	var border_color := BORDER_FRAME
	if b.has_meta("action_text_color"):
		text_color = b.get_meta("action_text_color")
	if b.has_meta("action_border"):
		border_color = b.get_meta("action_border")
	if b.disabled:
		text_color = TEXT_DIM
		border_color = Color(TEXT_DIM.r, TEXT_DIM.g, TEXT_DIM.b, 0.28)
		b.modulate = Color(1, 1, 1, 1)
	elif bool(b.get_meta("action_prompt", false)):
		text_color = NEON_COMPUTER_YELLOW
		border_color = GOLD
		b.modulate = Color(1, 1, 1, 1)
	elif bool(b.get_meta("action_subdued", false)):
		b.modulate = Color(1, 1, 1, 0.48)
	else:
		b.modulate = Color(1, 1, 1, 1)

	if b.has_meta("action_fill"):
		_apply_block_action_style(b, b.get_meta("action_fill"), border_color)

	if b.has_meta("action_label"):
		var lbl: Label = b.get_meta("action_label")
		lbl.add_theme_color_override("font_color", text_color)

	if b.has_meta("button_lip"):
		(b.get_meta("button_lip") as ColorRect).visible = false
	if b.has_meta("button_shine"):
		(b.get_meta("button_shine") as ColorRect).visible = false

	if b.has_meta("count_badge"):
		var badge: PanelContainer = b.get_meta("count_badge")
		var badge_style := _styled(text_color.darkened(0.08), text_color.darkened(0.35), 1, 9)
		badge_style.content_margin_left = 8
		badge_style.content_margin_right = 8
		badge_style.content_margin_top = 1
		badge_style.content_margin_bottom = 1
		badge.add_theme_stylebox_override("panel", badge_style)
		var count_lbl: Label = badge.get_meta("count_label")
		count_lbl.add_theme_color_override("font_color", BG_DEEP if not b.disabled else BG_PANEL_DARK)


func _action_palette(kind: String) -> Dictionary:
	var fill := Color("#06425f")
	var border := Color("#0b5675")
	match kind:
		"cast":
			return {"fill": fill, "border": border, "text": TEXT_PRIMARY}
		"find":
			return {"fill": fill, "border": border, "text": TEXT_PRIMARY}
		"attack":
			return {"fill": fill, "border": RED_DEEP, "text": RED}
		"sell":
			return {"fill": fill, "border": border, "text": TEXT_PRIMARY}
		"upgrade":
			return {"fill": fill, "border": PURPLE_DEEP, "text": PURPLE}
		"repair":
			return {"fill": fill, "border": CYAN_DEEP, "text": CYAN}
		"end":
			return {"fill": fill, "border": border, "text": TEXT_PRIMARY}
	return {"fill": fill, "border": border, "text": TEXT_PRIMARY}


func _bottom_nav_button(icon: Texture2D, label_text: String, tab_key: String) -> Button:
	var b := Button.new()
	b.text = ""
	b.focus_mode = Control.FOCUS_NONE
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(0, 92)
	b.pressed.connect(func(): _switch_tab(tab_key))

	var active_bar := ColorRect.new()
	active_bar.color = TEXT_PRIMARY
	active_bar.anchor_left = 0.24
	active_bar.anchor_right = 0.76
	active_bar.anchor_top = 0.0
	active_bar.anchor_bottom = 0.0
	active_bar.offset_top = 0
	active_bar.offset_bottom = 3
	active_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	active_bar.visible = false
	b.add_child(active_bar)

	var content := VBoxContainer.new()
	content.anchor_right = 1.0
	content.anchor_bottom = 1.0
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 3)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	b.add_child(content)

	var icon_holder := CenterContainer.new()
	icon_holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	icon_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(icon_holder)

	var icon_rect := _icon_texture_rect(icon, Vector2(38, 38), TEXT_MUTED)
	icon_holder.add_child(icon_rect)

	var text_label := _label(label_text, FONT_BODY + 2, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	content.add_child(text_label)

	b.set_meta("icon_rect", icon_rect)
	b.set_meta("text_label", text_label)
	b.set_meta("active_bar", active_bar)
	_apply_bottom_nav_style(b, tab_key == active_tab)
	return b


func _apply_bottom_nav_style(b: Button, active: bool) -> void:
	var fill := BG_PANEL_DARK if active else BG_NAV
	var normal := _styled(fill, fill, 0, 0)
	var hover := _styled(BG_PANEL_DARK.lightened(0.04), BG_PANEL_DARK, 0, 0)
	var press := _styled(BG_PANEL_DARK.darkened(0.1), BG_PANEL_DARK.darkened(0.1), 0, 0)
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", press)
	b.add_theme_stylebox_override("focus", normal)

	var color := TEXT_PRIMARY if active else TEXT_DIM
	if b.has_meta("active_bar"):
		var active_bar: ColorRect = b.get_meta("active_bar")
		active_bar.visible = active
		active_bar.color = TEXT_PRIMARY
	if b.has_meta("icon_rect"):
		var icon_rect: TextureRect = b.get_meta("icon_rect")
		icon_rect.modulate = color
	if b.has_meta("text_label"):
		var text_label: Label = b.get_meta("text_label")
		text_label.add_theme_color_override("font_color", color)


func _tab_button(text: String, tab_key: String) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.custom_minimum_size = Vector2(0, 44)
	b.add_theme_font_size_override("font_size", FONT_TAB)
	_apply_tab_style(b, tab_key == active_tab)
	b.pressed.connect(func(): _switch_tab(tab_key))
	return b


func _apply_tab_style(b: Button, active: bool) -> void:
	var fill := BG_PANEL_LIGHT if active else BG_PANEL_DARK.darkened(0.08)
	var border := CYAN_DEEP.lightened(0.12) if active else BORDER_DARK
	var label := TEXT_PRIMARY if active else TEXT_MUTED
	var normal := _styled(fill, border, 1, 4)
	var hover := _styled(fill.lightened(0.07), border.lightened(0.14), 1, 4)
	var press := _styled(fill.darkened(0.08), border, 1, 4)
	normal.content_margin_top = 5
	normal.content_margin_bottom = 5
	hover.content_margin_top = 5
	hover.content_margin_bottom = 5
	press.content_margin_top = 6
	press.content_margin_bottom = 4
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", press)
	b.add_theme_stylebox_override("focus", normal)
	b.add_theme_color_override("font_color", label)
	b.add_theme_color_override("font_hover_color", TEXT_PRIMARY)


func _switch_tab(tab_key: String) -> void:
	active_tab = tab_key
	_update_ui()


func _stat_card(title: String, value: String, accent: Color) -> PanelContainer:
	var card := _panel(accent.darkened(0.72), accent.darkened(0.18), 1, 5)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 72)

	var style := _styled(accent.darkened(0.72), accent.darkened(0.18), 1, 5)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 7
	style.content_margin_bottom = 8
	card.add_theme_stylebox_override("panel", style)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 0)
	card.add_child(col)

	var title_label := _label(title, 13, accent, HORIZONTAL_ALIGNMENT_CENTER)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title_label)

	var value_label := _label(value, 27, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.add_theme_constant_override("outline_size", 2)
	value_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.62))
	col.add_child(value_label)

	card.set_meta("value_label", value_label)
	card.set_meta("title_label", title_label)
	return card


func _stat_card_set(card: PanelContainer, value: String, color: Color = TEXT_PRIMARY) -> void:
	if card == null or not card.has_meta("value_label"):
		return
	var label: Label = card.get_meta("value_label")
	label.text = value
	label.add_theme_color_override("font_color", color)


# A left-rail HUD counter: dark-accent card body, accent icon+title, and a brighter inset "well"
# holding the count. Pushes/pops like a physical button on touch. Optionally clickable.
func _counter_button(key: String, icon: Texture2D, title: String, accent: Color, on_pressed: Callable) -> Control:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 96)
	card.clip_contents = false
	var style := _styled_shadow(accent.darkened(0.66), accent.darkened(0.04), 4, 9, 5)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 13
	style.content_margin_bottom = 14
	card.add_theme_stylebox_override("panel", style)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 9)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(col)

	var head := HBoxContainer.new()
	head.alignment = BoxContainer.ALIGNMENT_CENTER
	head.add_theme_constant_override("separation", 9)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(head)
	var ic := _icon_texture_rect(icon, Vector2(30, 30), accent)
	ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(ic)
	var title_label := _label(title, 21, accent, HORIZONTAL_ALIGNMENT_CENTER)
	title_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(title_label)

	# Inset "well" — a brighter, more saturated take on the card body.
	var well := PanelContainer.new()
	well.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	well.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var well_style := _styled(accent.darkened(0.44).lerp(accent, 0.12), Color(0, 0, 0, 0.5), 1, 6)
	well_style.border_width_top = 2
	well_style.border_width_bottom = 0
	well_style.content_margin_top = 5
	well_style.content_margin_bottom = 6
	well_style.content_margin_left = 10
	well_style.content_margin_right = 10
	well.add_theme_stylebox_override("panel", well_style)
	col.add_child(well)
	var value_label := _label("0", 40, accent.lightened(0.25), HORIZONTAL_ALIGNMENT_CENTER)
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.add_theme_constant_override("outline_size", 3)
	value_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.55))
	well.add_child(value_label)

	var btn := Button.new()
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	_anchor_fill(btn)
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		btn.add_theme_stylebox_override(st, _transparent_style())
	if on_pressed.is_valid():
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.pressed.connect(on_pressed)
	card.add_child(btn)
	_add_press_pop(card, btn)

	card.set_meta("value_label", value_label)
	card.set_meta("title_label", title_label)
	card.set_meta("icon_rect", ic)
	card.set_meta("button", btn)
	card.set_meta("accent", accent)
	ui[key] = card
	return card


# Update a counter's value, optional title, and enabled (lit vs greyed-out) state.
func _counter_set(key: String, value_text: String, enabled: bool = true, title_override: String = "") -> void:
	if not ui.has(key):
		return
	var card: Control = ui[key]
	if not is_instance_valid(card):
		return
	(card.get_meta("value_label") as Label).text = value_text
	if title_override != "":
		(card.get_meta("title_label") as Label).text = title_override
	var btn := card.get_meta("button") as Button
	if btn != null:
		btn.disabled = not enabled
	card.modulate = Color(1, 1, 1, 1) if enabled else Color(0.5, 0.56, 0.64, 0.8)


# Physical "push/pop" — scale down on press, overshoot back on release.
func _add_press_pop(target: Control, trigger: BaseButton) -> void:
	trigger.button_down.connect(func() -> void:
		if not is_instance_valid(target):
			return
		target.pivot_offset = target.size * 0.5
		var t := target.create_tween()
		t.tween_property(target, "scale", Vector2(0.93, 0.93), 0.06).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT))
	trigger.button_up.connect(func() -> void:
		if not is_instance_valid(target):
			return
		target.pivot_offset = target.size * 0.5
		var t := target.create_tween()
		t.tween_property(target, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT))


func _pill(text: String, accent: Color, text_color: Color = Color(0, 0, 0, 0)) -> PanelContainer:
	if text_color.a == 0:
		text_color = accent
	var fill := BG_PANEL_DARK.lerp(accent, 0.08)
	var p := _panel(fill, accent.darkened(0.15), 1, 5)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var s := _styled(fill, accent.darkened(0.15), 1, 5)
	s.content_margin_top = 5
	s.content_margin_bottom = 5
	s.content_margin_left = 10
	s.content_margin_right = 10
	p.add_theme_stylebox_override("panel", s)
	var l := _label(text, FONT_PILL, text_color, HORIZONTAL_ALIGNMENT_CENTER)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_child(l)
	p.set_meta("label", l)
	p.set_meta("accent", accent)
	return p


func _pill_set_text(pill: PanelContainer, text: String) -> void:
	var l: Label = pill.get_meta("label")
	if l:
		l.text = text


# Small green/red rocket badge showing a weather's catch multiplier (nothing at 1.0).
func _weather_mult_badge(mult: float) -> Control:
	if abs(mult - 1.0) <= 0.001:
		return null
	var accent := GREEN if mult > 1.0 else RED
	var badge := _panel(BG_PANEL_DARK.lerp(accent, 0.22), accent.darkened(0.1), 1, 4)
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 4)
	pad.add_theme_constant_override("margin_right", 5)
	pad.add_theme_constant_override("margin_top", 1)
	pad.add_theme_constant_override("margin_bottom", 1)
	badge.add_child(pad)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 2)
	pad.add_child(row)
	var icon := _icon_texture_rect(ICON_ROCKET_FISH_TEXTURE, Vector2(11, 11), accent)
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(icon)
	row.add_child(_label("%.1fX" % mult, 11, accent.lightened(0.25), HORIZONTAL_ALIGNMENT_CENTER))
	return badge


func _forecast_chip(weather: Dictionary, is_current: bool) -> Control:
	var weather_name := str(weather["name"])
	var strength := int(weather["strength"])
	var accent := TEXT_DIM
	var name := "Clear"
	match weather_name:
		"Storm":
			accent = CYAN_DEEP.lightened(0.2)
			name = "Storm"
		"Hurricane":
			accent = TEXT_MUTED
			name = "Hurr"
		_:
			accent = TEXT_DIM
			name = "Clear"

	var card := _panel(BG_PANEL_DARK.lerp(accent, 0.06), accent.darkened(0.18), 1, 4)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 62)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 5)
	pad.add_theme_constant_override("margin_right", 5)
	pad.add_theme_constant_override("margin_top", 4)
	pad.add_theme_constant_override("margin_bottom", 4)
	card.add_child(pad)

	var row := VBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 0)
	pad.add_child(row)

	var icon := _icon_texture_rect(_weather_icon_texture(weather_name), Vector2(18, 18), accent)
	row.add_child(icon)

	var label_text := "%s %d" % [name, strength] if strength > 0 else name
	var label := _label(label_text, 12, TEXT_PRIMARY if is_current else TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	var badge := _weather_mult_badge(float(weather.get("mult", 1.0)))
	if badge != null:
		badge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		row.add_child(badge)
	return card


func _hud_forecast_chip(weather: Dictionary, is_current: bool) -> Control:
	var weather_name := str(weather["name"])
	var strength := int(weather["strength"])
	var accent := TEXT_DIM
	var name := "Clear"
	match weather_name:
		"Storm":
			accent = CYAN_DEEP.lightened(0.26)
			name = "Storms" if strength >= 4 else "Storm"
		"Hurricane":
			accent = TEXT_MUTED
			name = "Hurricane"
		_:
			accent = TEXT_DIM
			name = "Clear"

	var row := HBoxContainer.new()
	_anchor_fill(row)
	row.add_theme_constant_override("separation", 7)
	row.alignment = BoxContainer.ALIGNMENT_CENTER

	var icon := _icon_texture_rect(_weather_icon_texture(weather_name), Vector2(29, 29), accent)
	row.add_child(icon)

	var label := _hud_label(name, 18, TEXT_PRIMARY if is_current else TEXT_MUTED, HORIZONTAL_ALIGNMENT_LEFT)
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	row.add_child(label)
	return row


func _hud_market_row(species: String) -> Control:
	var row := HBoxContainer.new()
	_anchor_fill(row)
	row.add_theme_constant_override("separation", 6)
	row.alignment = BoxContainer.ALIGNMENT_CENTER

	row.add_child(_hud_trophy_dot(species))

	var name := _hud_market_label(species.to_upper(), 15, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_LEFT)
	name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(name)

	var price := _hud_market_label("$%d" % int(market_prices[species]), 16, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_RIGHT)
	price.custom_minimum_size = Vector2(48, 0)
	row.add_child(price)
	return row


func _hud_market_label(text: String, size: int, color: Color, align: int) -> Label:
	var l := _hud_label(text, size, color, align)
	return l


func _hud_trophy_dot(species: String) -> Control:
	var achieved := bool(trophies.get(species, false))
	var color := GREEN if achieved else Color("#746522")
	var dot := PanelContainer.new()
	dot.custom_minimum_size = Vector2(8, 8)
	dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	dot.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = color.lightened(0.12 if achieved else 0.05)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.shadow_color = Color(color.r, color.g, color.b, 0.48 if achieved else 0.10)
	style.shadow_size = 5 if achieved else 2
	style.shadow_offset = Vector2.ZERO
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	dot.add_theme_stylebox_override("panel", style)
	return dot


func _weather_chip(weather: Dictionary, is_tonight: bool) -> Control:
	var weather_name := str(weather["name"])
	var strength := int(weather["strength"])
	var accent := TEXT_MUTED
	var label_text := "Clear"
	match weather_name:
		"Storm":
			accent = CYAN
			label_text = "Storm %d" % strength
		"Hurricane":
			accent = RED
			label_text = "Hurr %d" % strength
		_:
			accent = GOLD if is_tonight else TEXT_MUTED
			label_text = "Clear"

	var fill := BG_PANEL_DARK
	var border := BORDER_DARK
	var text_color := accent
	if is_tonight:
		fill = accent.darkened(0.66) if weather_name != "Clear" else BG_PANEL_LIGHT
		text_color = TEXT_PRIMARY if weather_name != "Clear" else GOLD
		border = accent.darkened(0.12)
	else:
		fill = BG_PANEL_DARK.lerp(accent, 0.05)

	var p := _panel(fill, border, 1, 4)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 6)
	pad.add_theme_constant_override("margin_right", 6)
	pad.add_theme_constant_override("margin_top", 2)
	pad.add_theme_constant_override("margin_bottom", 2)
	p.add_child(pad)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 4)
	pad.add_child(row)

	var icon := _icon_texture_rect(_weather_icon_texture(weather_name), Vector2(18, 18), text_color)
	row.add_child(icon)

	var lbl := _label(label_text, FONT_SMALL, text_color, HORIZONTAL_ALIGNMENT_CENTER)
	row.add_child(lbl)
	return p


# ────────────────────────────────────────────────────────────────────────
# End-of-game report screen
# ────────────────────────────────────────────────────────────────────────

func _build_game_over_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 180
	add_child(overlay)
	ui["game_over_overlay"] = overlay

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.82)
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(shade)

	var scroll := ScrollContainer.new()
	scroll.anchor_right = 1.0
	scroll.anchor_bottom = 1.0
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	overlay.add_child(scroll)

	var pad := MarginContainer.new()
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_left", 14)
	pad.add_theme_constant_override("margin_right", 14)
	pad.add_theme_constant_override("margin_top", 20)
	pad.add_theme_constant_override("margin_bottom", 18)
	scroll.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 8)
	pad.add_child(col)
	ui["game_over_col"] = col


func _show_game_over_screen() -> void:
	if not ui.has("game_over_overlay") or not ui.has("game_over_col"):
		return

	var col: VBoxContainer = ui["game_over_col"]
	for child in col.get_children():
		child.queue_free()

	var outcome := _game_over_outcome()
	var score_rank := _record_high_score()
	var total_sold := _total_fish_sold()
	var upgrade_total := _upgrade_total(upgrades)
	var fish_caught := _final_fish_caught()
	var elapsed_seconds := int(round(float(game_stats.get("elapsed_seconds", 0.0))))
	var paid_nights_found := int(game_stats.get("paid_nights_found", 0))
	var treasure_summary := "%d · $%d" % [int(game_stats.get("treasures_found", 0)), int(game_stats.get("treasure_money", 0))]
	if paid_nights_found > 0:
		treasure_summary += " · +%dN" % paid_nights_found

	var title_lbl := _label(outcome["title"], 24, outcome["title_color"], HORIZONTAL_ALIGNMENT_CENTER)
	title_lbl.add_theme_constant_override("shadow_offset_y", 4)
	title_lbl.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title_lbl)

	var subtitle := _label(outcome["subtitle"], FONT_SMALL, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	subtitle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(subtitle)

	col.add_child(_divider(BORDER_FRAME))
	col.add_child(_rank_banner(score_rank))

	# Final Score
	var score_card := _panel_lifted(BG_PANEL, BORDER_FRAME, 1, 8, 6)
	score_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(score_card)

	var score_pad := MarginContainer.new()
	score_pad.add_theme_constant_override("margin_left", 10)
	score_pad.add_theme_constant_override("margin_right", 10)
	score_pad.add_theme_constant_override("margin_top", 9)
	score_pad.add_theme_constant_override("margin_bottom", 9)
	score_card.add_child(score_pad)

	var score_col := VBoxContainer.new()
	score_col.add_theme_constant_override("separation", 6)
	score_pad.add_child(score_col)

	score_col.add_child(_section_label("FINAL RANKING"))

	var ranking_note := _label("Ranked by stars, dollars, ship upgrades, fish, then fewer days.", FONT_SMALL, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	ranking_note.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	score_col.add_child(ranking_note)

	var metric_grid := GridContainer.new()
	metric_grid.columns = 4
	metric_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	metric_grid.add_theme_constant_override("h_separation", 8)
	metric_grid.add_theme_constant_override("v_separation", 6)
	score_col.add_child(metric_grid)

	metric_grid.add_child(_end_metric_tile("STARS", "%d/%d" % [_trophy_count(), TROPHY_WIN_COUNT], _star_string(_trophy_count()), GOLD))
	metric_grid.add_child(_end_metric_tile("DOLLARS", "$%d" % money, "cash on hand", GREEN))
	metric_grid.add_child(_end_metric_tile("UPGRADES", "%d" % upgrade_total, "ship levels", CYAN))
	metric_grid.add_child(_end_metric_tile("FISH", "%d" % fish_caught, "%d sold" % total_sold, PURPLE))

	col.add_child(_section_label("TRIP LOG"))
	var trip_card := _panel_lifted(BG_PANEL_DARK, BORDER_DARK, 1, 8, 5)
	trip_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(trip_card)

	var trip_pad := MarginContainer.new()
	trip_pad.add_theme_constant_override("margin_left", 8)
	trip_pad.add_theme_constant_override("margin_right", 8)
	trip_pad.add_theme_constant_override("margin_top", 8)
	trip_pad.add_theme_constant_override("margin_bottom", 8)
	trip_card.add_child(trip_pad)

	var trip_grid := GridContainer.new()
	trip_grid.columns = 4
	trip_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	trip_grid.add_theme_constant_override("h_separation", 8)
	trip_grid.add_theme_constant_override("v_separation", 6)
	trip_pad.add_child(trip_grid)

	trip_grid.add_child(_stat_chip("TIME", _format_duration(elapsed_seconds), CYAN))
	trip_grid.add_child(_stat_chip("DAYS", "%d/%d" % [min(day, _season_days()), _season_days()], TEXT_PRIMARY))
	trip_grid.add_child(_stat_chip("NIGHTS", "%d" % extra_nights, GOLD if extra_nights > 0 else TEXT_DIM))
	trip_grid.add_child(_stat_chip("MOVES", "%d" % int(game_stats.get("move_actions", 0)), TEXT_PRIMARY))
	trip_grid.add_child(_stat_chip("SPACES", "%d" % int(game_stats.get("moves_used", 0)), TEXT_MUTED))
	trip_grid.add_child(_stat_chip("CASTS", "%d" % int(game_stats.get("casts_made", 0)), TEXT_PRIMARY))
	trip_grid.add_child(_stat_chip("FINDER", "%d" % int(game_stats.get("finds_used", 0)), TEXT_MUTED))
	trip_grid.add_child(_stat_chip("TREASURE", treasure_summary, GOLD))
	trip_grid.add_child(_stat_chip("EMPTY", "%d" % int(game_stats.get("empty_casts", 0)), TEXT_DIM))
	trip_grid.add_child(_stat_chip("REPAIRS", "%d" % int(game_stats.get("repairs_made", 0)), TEXT_MUTED))
	trip_grid.add_child(_stat_chip("WEATHER", "%d" % int(game_stats.get("weather_hits", 0)), RED if int(game_stats.get("weather_hits", 0)) > 0 else TEXT_DIM))
	if versus_mode:
		trip_grid.add_child(_stat_chip("WON", "%d" % int(game_stats.get("raids_won", 0)), GREEN))
		trip_grid.add_child(_stat_chip("LOST", "%d" % int(game_stats.get("raids_lost", 0)), RED if int(game_stats.get("raids_lost", 0)) > 0 else TEXT_DIM))

	# Trophies section
	col.add_child(_section_label("TROPHIES"))

	var trophy_grid := GridContainer.new()
	trophy_grid.columns = SPECIES.size()
	trophy_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	trophy_grid.add_theme_constant_override("h_separation", 6)
	trophy_grid.add_theme_constant_override("v_separation", 6)
	col.add_child(trophy_grid)

	for species in SPECIES:
		trophy_grid.add_child(_trophy_grid_tile(species))

	# Ship stats section
	col.add_child(_section_label("SHIP STATUS"))

	var ship_card := _panel_lifted(BG_PANEL, BORDER_FRAME, 1, 8, 6)
	ship_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ship_card)

	var ship_pad := MarginContainer.new()
	ship_pad.add_theme_constant_override("margin_left", 8)
	ship_pad.add_theme_constant_override("margin_right", 8)
	ship_pad.add_theme_constant_override("margin_top", 8)
	ship_pad.add_theme_constant_override("margin_bottom", 8)
	ship_card.add_child(ship_pad)

	var ship_grid := GridContainer.new()
	ship_grid.columns = 5
	ship_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ship_grid.add_theme_constant_override("h_separation", 8)
	ship_grid.add_theme_constant_override("v_separation", 6)
	ship_pad.add_child(ship_grid)

	for key in CONDITION_KEYS:
		var val := int(conditions[key])
		var fill_ratio := float(val) / float(CONDITION_MAX)
		var bar_color := GREEN if fill_ratio > 0.5 else (GOLD if fill_ratio > 0.2 else RED)
		ship_grid.add_child(_stat_chip(_condition_short_label(key), "%d%%" % int(round(fill_ratio * 100.0)), bar_color))

	for key in UPGRADE_KEYS:
		var lvl := int(upgrades[key])
		ship_grid.add_child(_stat_chip(_upgrade_short_label(key), "%d/%d" % [lvl, UPGRADE_MAX_LEVEL], CYAN if lvl > 0 else TEXT_DIM))

	col.add_child(_divider(BORDER_FRAME))

	# Buttons
	var btn_row := HBoxContainer.new()
	btn_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_row.add_theme_constant_override("separation", 8)
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_child(btn_row)

	var menu_btn := _tactile_button("MENU", 160, 46, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	menu_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	menu_btn.pressed.connect(func():
		_hide_game_over_screen()
		_show_start_screen()
	)
	btn_row.add_child(menu_btn)

	var again_btn := _tactile_button("PLAY AGAIN", 160, 46, CYAN_DEEP, CYAN, TEXT_PRIMARY)
	again_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	again_btn.pressed.connect(func():
		_hide_game_over_screen()
		_new_game(versus_mode)
	)
	btn_row.add_child(again_btn)

	_save_game()
	(ui["game_over_overlay"] as Control).visible = true


func _hide_game_over_screen() -> void:
	if ui.has("game_over_overlay"):
		(ui["game_over_overlay"] as Control).visible = false


func _game_over_outcome() -> Dictionary:
	var hull_sunk := int(conditions["hull"]) <= 0
	var won_trophies := _trophy_count() >= TROPHY_WIN_COUNT
	var bot_won := versus_mode and _bot_trophy_count() >= TROPHY_WIN_COUNT
	var bot_sank_you := versus_mode and hull_sunk

	if won_trophies:
		return {"title": "CHAMPION!", "subtitle": "All %d trophies earned." % TROPHY_WIN_COUNT, "title_color": GOLD}
	if hull_sunk:
		if bot_sank_you:
			return {"title": "SUNK!", "subtitle": "%s destroyed your boat." % BOT_NAME, "title_color": RED}
		return {"title": "SUNK!", "subtitle": "The sea claimed your vessel.", "title_color": RED}
	if bot_won:
		return {"title": "DEFEATED", "subtitle": "%s earned %d trophies first." % [BOT_NAME, TROPHY_WIN_COUNT], "title_color": RED}
	return {"title": "SEASON OVER", "subtitle": "The fishing season has ended.", "title_color": CYAN}


func _rank_banner(rank: int) -> Control:
	var is_top_10 := rank > 0 and rank <= 10
	var banner := _panel_lifted(BG_PANEL_LIGHT if is_top_10 else BG_PANEL_DARK, GOLD_DEEP if is_top_10 else BORDER_DARK, 2 if is_top_10 else 1, 8, 5)
	banner.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 10)
	pad.add_theme_constant_override("margin_right", 10)
	pad.add_theme_constant_override("margin_top", 8)
	pad.add_theme_constant_override("margin_bottom", 8)
	banner.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 12)
	pad.add_child(row)

	var marker_text := "TOP 10" if is_top_10 else "RANK"
	var marker := _label(marker_text, 28 if is_top_10 else 22, GOLD if is_top_10 else CYAN, HORIZONTAL_ALIGNMENT_CENTER)
	marker.add_theme_constant_override("shadow_offset_y", 4)
	marker.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	marker.custom_minimum_size = Vector2(118, 0)
	row.add_child(marker)

	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 2)
	row.add_child(copy)

	var rank_line := "High score #%d" % rank if rank > 0 else "Not ranked"
	if is_top_10:
		rank_line = "High score #%d" % rank
	elif rank > MAX_HIGH_SCORES:
		rank_line = "Outside the top %d" % MAX_HIGH_SCORES
	copy.add_child(_label(rank_line, FONT_BODY, TEXT_PRIMARY))
	copy.add_child(_label("Ties: cash, upgrades, fish, then fewer days.", FONT_SMALL, TEXT_MUTED))

	return banner


func _trophy_grid_tile(species: String) -> Control:
	var earned := bool(trophies.get(species, false))
	var tile := _panel(BG_PANEL_DARK if not earned else BG_PANEL_LIGHT, BORDER_DARK if not earned else GOLD_DEEP, 1, 6)
	tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tile.custom_minimum_size = Vector2(0, 86)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 4)
	pad.add_theme_constant_override("margin_right", 4)
	pad.add_theme_constant_override("margin_top", 5)
	pad.add_theme_constant_override("margin_bottom", 5)
	tile.add_child(pad)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 0)
	pad.add_child(col)

	var fish_art := TextureRect.new()
	fish_art.texture = _fish_texture(species)
	fish_art.custom_minimum_size = Vector2(56, 34)
	fish_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fish_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	fish_art.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if not earned:
		fish_art.modulate = Color(1, 1, 1, 0.25)
	col.add_child(fish_art)

	var name_lbl := _label(species.to_upper(), FONT_SMALL, TEXT_PRIMARY if earned else TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(name_lbl)

	var sold_count := int(sold_totals.get(species, 0))
	var footer := _label("%s  %d" % ["★" if earned else "☆", sold_count], FONT_SMALL, GOLD if earned else TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	footer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(footer)

	return tile


func _condition_short_label(key: String) -> String:
	match key:
		"hull":
			return "HULL"
		"propeller":
			return "PROP"
		"rudder":
			return "RUDDER"
		"nets":
			return "NETS"
		_:
			return key.to_upper()


func _upgrade_short_label(key: String) -> String:
	match key:
		"motor":
			return "MOTOR"
		"fish_finder":
			return "FINDER"
		"nets":
			return "NET+"
		"live_well":
			return "WELL"
		"cannons":
			return "GUNS"
		"defense":
			return "DEF"
		_:
			return key.to_upper()


func _end_metric_tile(title: String, value: String, detail: String, accent: Color) -> Control:
	var tile := _panel(BG_PANEL_DARK, accent.darkened(0.25), 1, 6)
	tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tile.custom_minimum_size = Vector2(0, 66)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 7)
	pad.add_theme_constant_override("margin_right", 7)
	pad.add_theme_constant_override("margin_top", 6)
	pad.add_theme_constant_override("margin_bottom", 6)
	tile.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 2)
	pad.add_child(col)

	col.add_child(_label(title, FONT_SMALL, TEXT_DIM))
	var value_lbl := _label(value, 22, accent)
	col.add_child(value_lbl)
	col.add_child(_label(detail, FONT_SMALL, TEXT_MUTED))
	return tile


func _stat_chip(title: String, value: String, accent: Color) -> Control:
	var chip := _panel(BG_PANEL, BORDER_DARK, 1, 4)
	chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chip.custom_minimum_size = Vector2(0, 32)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 6)
	pad.add_theme_constant_override("margin_right", 6)
	pad.add_theme_constant_override("margin_top", 5)
	pad.add_theme_constant_override("margin_bottom", 5)
	chip.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 5)
	pad.add_child(row)
	row.add_child(_label(title, FONT_SMALL, TEXT_DIM))
	var value_lbl := _label(value, FONT_SMALL, accent, HORIZONTAL_ALIGNMENT_RIGHT)
	value_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(value_lbl)
	return chip


func _star_string(count: int) -> String:
	var text := ""
	for i in range(TROPHY_WIN_COUNT):
		text += "★" if i < count else "☆"
	return text


func _format_duration(seconds: int) -> String:
	seconds = max(0, seconds)
	var hours := int(seconds / 3600)
	var minutes := int((seconds % 3600) / 60)
	var secs := seconds % 60
	if hours > 0:
		return "%dh %02dm" % [hours, minutes]
	if minutes > 0:
		return "%dm %02ds" % [minutes, secs]
	return "%ds" % secs


# ────────────────────────────────────────────────────────────────────────
# High scores
# ────────────────────────────────────────────────────────────────────────

func _record_high_score() -> int:
	if high_score_recorded:
		return last_high_score_rank

	var scores := _load_high_scores()
	var outcome := _game_over_outcome()
	var entry_id := "%d-%d" % [int(Time.get_unix_time_from_system()), rng.randi()]
	var entry := {
		"schema": 1,
		"id": entry_id,
		"money": money,
		"trophies": _trophy_count(),
		"day": min(day, _season_days()),
		"season_days": _season_days(),
		"extra_nights": extra_nights,
		"fish_sold": _total_fish_sold(),
		"fish_caught": _final_fish_caught(),
		"upgrade_total": _upgrade_total(upgrades),
		"elapsed_seconds": int(round(float(game_stats.get("elapsed_seconds", 0.0)))),
		"move_actions": int(game_stats.get("move_actions", 0)),
		"casts_made": int(game_stats.get("casts_made", 0)),
		"treasures_found": int(game_stats.get("treasures_found", 0)),
		"mode": MODE_VERSUS if versus_mode else MODE_SOLO,
		"outcome": outcome["title"],
		"timestamp": int(Time.get_unix_time_from_system()),
	}
	scores.append(entry)
	_sort_high_scores(scores)

	last_high_score_rank = scores.size()
	for i in range(scores.size()):
		var score: Dictionary = scores[i]
		if str(score.get("id", "")) == entry_id:
			last_high_score_rank = i + 1
			break
	last_high_score_top_10 = last_high_score_rank > 0 and last_high_score_rank <= 10
	high_score_recorded = true

	while scores.size() > MAX_HIGH_SCORES:
		scores.pop_back()
	_save_high_scores(scores)
	_submit_global_high_score(entry)
	return last_high_score_rank


func _sort_high_scores(scores: Array) -> void:
	scores.sort_custom(_is_high_score_better)


func _is_high_score_better(a, b) -> bool:
	var ad: Dictionary = a if a is Dictionary else {}
	var bd: Dictionary = b if b is Dictionary else {}
	var trophy_diff := int(ad.get("trophies", 0)) - int(bd.get("trophies", 0))
	if trophy_diff != 0:
		return trophy_diff > 0
	var money_diff := int(ad.get("money", 0)) - int(bd.get("money", 0))
	if money_diff != 0:
		return money_diff > 0
	var upgrade_diff := int(ad.get("upgrade_total", 0)) - int(bd.get("upgrade_total", 0))
	if upgrade_diff != 0:
		return upgrade_diff > 0
	var fish_diff := _entry_fish_count(ad) - _entry_fish_count(bd)
	if fish_diff != 0:
		return fish_diff > 0
	var day_diff := int(ad.get("day", 99999999)) - int(bd.get("day", 99999999))
	if day_diff != 0:
		return day_diff < 0
	var elapsed_diff := int(ad.get("elapsed_seconds", 99999999)) - int(bd.get("elapsed_seconds", 99999999))
	if elapsed_diff != 0:
		return elapsed_diff < 0
	return int(ad.get("timestamp", 0)) > int(bd.get("timestamp", 0))


func _entry_fish_count(entry: Dictionary) -> int:
	return int(entry.get("fish_caught", entry.get("fish_sold", 0)))


func _total_fish_sold() -> int:
	var total := 0
	for species in SPECIES:
		total += int(sold_totals.get(species, 0))
	return total


func _fish_aboard_count() -> int:
	var total := 0
	for batch in live_well:
		total += int(batch.get("quantity", 0))
	return total


func _final_fish_caught() -> int:
	return max(int(game_stats.get("fish_caught", 0)), _total_fish_sold() + _fish_aboard_count())


func _upgrade_total(upgrade_dict: Dictionary) -> int:
	var total := 0
	for key in UPGRADE_KEYS:
		total += int(upgrade_dict.get(key, 0))
	return total


func _load_high_scores() -> Array:
	if not FileAccess.file_exists(HIGH_SCORES_PATH):
		return []
	var file := FileAccess.open(HIGH_SCORES_PATH, FileAccess.READ)
	if file == null:
		return []
	var parser := JSON.new()
	if parser.parse(file.get_as_text()) != OK:
		return []
	if parser.data is Array:
		var scores: Array = parser.data
		for item in scores:
			if item is Dictionary:
				var entry: Dictionary = item
				if not entry.has("upgrade_total"):
					entry["upgrade_total"] = 0
				if not entry.has("fish_caught"):
					entry["fish_caught"] = int(entry.get("fish_sold", 0))
				if not entry.has("elapsed_seconds"):
					entry["elapsed_seconds"] = 99999999
		_sort_high_scores(scores)
		return scores
	return []


func _save_high_scores(scores: Array) -> void:
	var file := FileAccess.open(HIGH_SCORES_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(scores))


func _global_scores_enabled() -> bool:
	return GLOBAL_SCORES_API != "" and global_scores_fetch_request != null and global_scores_submit_request != null


func _submit_global_high_score(entry: Dictionary) -> void:
	if not _global_scores_enabled():
		return
	var headers := ["Content-Type: application/json", "Accept: application/json"]
	var err := global_scores_submit_request.request(GLOBAL_SCORES_API, headers, HTTPClient.METHOD_POST, JSON.stringify(entry))
	if err != OK:
		global_scores_status = "Global score submit queued locally."


func _fetch_global_high_scores() -> void:
	if not _global_scores_enabled():
		return
	global_scores_status = "Loading global scores..."
	var err := global_scores_fetch_request.request(GLOBAL_SCORES_API, ["Accept: application/json"], HTTPClient.METHOD_GET)
	if err != OK:
		global_scores_status = "Global scores unavailable. Showing local scores."


func _on_global_score_submit_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		global_scores_status = "Global score submit failed. Saved locally."
		return
	var parsed := _global_scores_from_body(body)
	if not parsed.is_empty():
		global_scores = parsed
		if ui.has("high_scores_overlay") and (ui["high_scores_overlay"] as Control).visible:
			_render_high_scores_screen(global_scores, "GLOBAL HIGH SCORES", "Shared Raider Bay scoreboard.")


func _on_global_scores_fetch_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		global_scores_status = "Global scores unavailable. Showing local scores."
		if ui.has("high_scores_overlay") and (ui["high_scores_overlay"] as Control).visible:
			_render_high_scores_screen(_load_high_scores(), "HIGH SCORES", global_scores_status)
		return
	var parsed := _global_scores_from_body(body)
	if parsed.is_empty():
		global_scores_status = "No global scores yet."
		_render_high_scores_screen(_load_high_scores(), "HIGH SCORES", global_scores_status)
		return
	global_scores = parsed
	global_scores_status = "Shared Raider Bay scoreboard."
	if ui.has("high_scores_overlay") and (ui["high_scores_overlay"] as Control).visible:
		_render_high_scores_screen(global_scores, "GLOBAL HIGH SCORES", global_scores_status)


func _global_scores_from_body(body: PackedByteArray) -> Array:
	var parser := JSON.new()
	if parser.parse(body.get_string_from_utf8()) != OK:
		return []
	var scores: Array = []
	if parser.data is Dictionary:
		var data: Dictionary = parser.data
		if data.get("scores", []) is Array:
			scores = data.get("scores", [])
	elif parser.data is Array:
		scores = parser.data
	return _normalize_score_array(scores)


func _normalize_score_array(scores: Array) -> Array:
	var clean: Array = []
	for item in scores:
		if item is Dictionary:
			var entry: Dictionary = item
			if not entry.has("upgrade_total"):
				entry["upgrade_total"] = 0
			if not entry.has("fish_caught"):
				entry["fish_caught"] = int(entry.get("fish_sold", 0))
			if not entry.has("elapsed_seconds"):
				entry["elapsed_seconds"] = 99999999
			clean.append(entry)
	_sort_high_scores(clean)
	while clean.size() > MAX_HIGH_SCORES:
		clean.pop_back()
	return clean


# ── Deck Training (animated single-player tutorial) ─────────────────────────

var deck_training_index := 0
var deck_training_slide_node: Control = null
var deck_training_animating := false


func _deck_training_slides() -> Array:
	return [
		{"title": "WELCOME ABOARD", "accent": GOLD, "icon": ICON_ROCKET_FISH_TEXTURE,
			"body": "You captain a fishing boat for one season. Catch fish, sell your haul at the docks, and upgrade your gear — and bank as much money as you can before time runs out."},
		{"title": "THE BAY", "accent": CYAN, "icon": ICON_FIND_FISH_TEXTURE,
			"body": "The board is the bay. Every card is a spot to fish. The deeper water near the bottom holds the biggest, most valuable fish."},
		{"title": "YOUR DAILY BUDGET", "accent": Color("#8ad5f3"), "icon": ICON_DAY_TEXTURE,
			"body": "Each day you get a small budget on the left: MOVES to sail, FIND FISH to spot fish, and CASTS to reel them in. Spend them, then end your day."},
		{"title": "SAIL THE BAY", "accent": Color("#ff6161"), "icon": ICON_MOVES_TEXTURE,
			"body": "Tap a card next to your boat to sail there — that costs one move. You can go straight or diagonal. Long-press any card to peek at what's on it."},
		{"title": "FIND & CAST", "accent": Color("#84ed72"), "icon": ICON_CAST_TEXTURE,
			"body": "Tap FIND FISH to scan the water nearby and reveal fish. Then sit on a fish and tap CAST to reel it in. Each spot only holds a few catches."},
		{"title": "SELL AT THE DOCKS", "accent": GOLD, "icon": ICON_CARD_SHIP_TEXTURE,
			"body": "Your catch waits in the live well, but it spoils after a few days. Sail back to THE DOCKS and sell it before it goes bad."},
		{"title": "UPGRADE YOUR BOAT", "accent": PURPLE, "icon": ICON_FUNDS_TEXTURE,
			"body": "At the docks, tap FUNDS to open the shop. Buy a faster motor, a sharper fish finder, and bigger nets — and repair your hull so storms can't sink you."},
		{"title": "WEATHER & TROPHIES", "accent": CYAN, "icon": ICON_TROPHY_SOLID,
			"body": "Watch the weather: a storm boosts your catch, but a hurricane cuts it and can batter your boat. Catch enough of one fish to earn its trophy, then survive the whole season to win!"},
	]


func _build_deck_training_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 220
	overlay.visible = false
	add_child(overlay)
	ui["deck_training_overlay"] = overlay

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.66)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	_anchor_fill(shade)
	overlay.add_child(shade)

	var cc := CenterContainer.new()
	cc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(cc)
	overlay.add_child(cc)

	var panel := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 2, 6, 12)
	panel.custom_minimum_size = Vector2(820, 624)
	cc.add_child(panel)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 34)
	pad.add_theme_constant_override("margin_right", 34)
	pad.add_theme_constant_override("margin_top", 26)
	pad.add_theme_constant_override("margin_bottom", 28)
	panel.add_child(pad)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 18)
	pad.add_child(col)

	# Slim header: a quiet eyebrow on the left, close on the right. The slide title is the hero.
	var header := HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(header)
	var eyebrow := _label("DECK TRAINING", 15, _with_alpha(GOLD, 0.85), HORIZONTAL_ALIGNMENT_LEFT)
	eyebrow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	eyebrow.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	eyebrow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(eyebrow)
	var close := _tactile_button("X", 48, 44, BG_PANEL_LIGHT, BORDER_FRAME, TEXT_MUTED)
	close.add_theme_font_size_override("font_size", 20)
	close.pressed.connect(_hide_deck_training)
	header.add_child(close)

	var content := Control.new()
	content.custom_minimum_size = Vector2(752, 414)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.clip_contents = true
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(content)
	ui["deck_training_content"] = content

	var dots := HBoxContainer.new()
	dots.alignment = BoxContainer.ALIGNMENT_CENTER
	dots.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dots.add_theme_constant_override("separation", 10)
	col.add_child(dots)
	ui["deck_training_dots"] = dots

	var nav := HBoxContainer.new()
	nav.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_theme_constant_override("separation", 12)
	col.add_child(nav)
	var back := _tactile_button("BACK", 175, 60, BG_PANEL_LIGHT, BORDER_FRAME, TEXT_PRIMARY)
	back.add_theme_font_size_override("font_size", 20)
	back.pressed.connect(_deck_training_prev)
	nav.add_child(back)
	ui["deck_training_back"] = back
	var nav_spacer := Control.new()
	nav_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	nav_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_child(nav_spacer)
	var next := _tactile_button("NEXT", 175, 60, GREEN_DEEP, GOLD_DEEP, TEXT_PRIMARY)
	next.add_theme_font_size_override("font_size", 20)
	next.pressed.connect(_deck_training_next)
	nav.add_child(next)
	ui["deck_training_next"] = next


func _build_deck_slide(slide: Dictionary, slide_size: Vector2) -> Control:
	var accent: Color = slide["accent"]
	var root := Control.new()
	root.custom_minimum_size = slide_size
	root.size = slide_size
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 24)
	_anchor_fill(box)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(box)

	# Icon in a soft accent disc.
	var disc := PanelContainer.new()
	disc.custom_minimum_size = Vector2(140, 140)
	disc.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	disc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var disc_style := _styled(accent.darkened(0.6), accent, 3, 30)
	disc_style.content_margin_left = 26
	disc_style.content_margin_right = 26
	disc_style.content_margin_top = 26
	disc_style.content_margin_bottom = 26
	disc.add_theme_stylebox_override("panel", disc_style)
	box.add_child(disc)
	var icon := _icon_texture_rect(slide["icon"], Vector2(86, 86), accent)
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	disc.add_child(icon)

	var title := _label(slide["title"], 40, accent, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.add_theme_constant_override("outline_size", 3)
	title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.6))
	box.add_child(title)

	var body := _label(slide["body"], 24, _with_alpha(TEXT_PRIMARY, 0.96), HORIZONTAL_ALIGNMENT_CENTER)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.custom_minimum_size = Vector2(600, 0)
	body.add_theme_constant_override("line_spacing", 6)
	box.add_child(body)

	root.set_meta("disc", disc)
	root.set_meta("title", title)
	root.set_meta("body", body)
	return root


func _render_deck_training_slide(direction: int = 0) -> void:
	if not ui.has("deck_training_content"):
		return
	var slides := _deck_training_slides()
	deck_training_index = clampi(deck_training_index, 0, slides.size() - 1)
	var content: Control = ui["deck_training_content"]
	var old_slide: Control = null
	if deck_training_slide_node != null and is_instance_valid(deck_training_slide_node):
		old_slide = deck_training_slide_node
	# Drop any stray slides from an interrupted transition.
	for ch in content.get_children():
		if ch != old_slide:
			ch.queue_free()

	var w := content.size.x if content.size.x > 1.0 else 752.0
	var h := content.size.y if content.size.y > 1.0 else 414.0
	var new_slide := _build_deck_slide(slides[deck_training_index], Vector2(w, h))
	content.add_child(new_slide)
	deck_training_slide_node = new_slide

	if direction == 0 or old_slide == null:
		new_slide.position = Vector2.ZERO
		if old_slide:
			old_slide.queue_free()
	else:
		deck_training_animating = true
		new_slide.position = Vector2(float(direction) * w, 0.0)
		var nt := new_slide.create_tween()
		nt.tween_property(new_slide, "position:x", 0.0, 0.36).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		nt.tween_callback(func() -> void: deck_training_animating = false)
		var os := old_slide
		var ot := os.create_tween()
		ot.set_parallel(true)
		ot.tween_property(os, "position:x", -float(direction) * w, 0.32).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		ot.tween_property(os, "modulate:a", 0.0, 0.26)
		ot.chain().tween_callback(os.queue_free)

	_animate_deck_slide_in(new_slide)
	_update_deck_training_dots()
	_update_deck_training_nav()


# Staggered, GPU-friendly entrance: the disc pops, then the title and body fade in.
func _animate_deck_slide_in(slide: Control) -> void:
	var disc: Control = slide.get_meta("disc")
	var title: Control = slide.get_meta("title")
	var body: Control = slide.get_meta("body")

	disc.pivot_offset = Vector2(70, 70)
	disc.scale = Vector2(0.5, 0.5)
	disc.modulate = Color(1, 1, 1, 0)
	var dt := disc.create_tween()
	dt.set_parallel(true)
	dt.tween_property(disc, "modulate:a", 1.0, 0.16)
	dt.tween_property(disc, "scale", Vector2(1.1, 1.1), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	dt.chain().tween_property(disc, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	title.modulate = Color(1, 1, 1, 0)
	var tt := title.create_tween()
	tt.tween_interval(0.1)
	tt.tween_property(title, "modulate:a", 1.0, 0.22)

	body.modulate = Color(1, 1, 1, 0)
	var bt := body.create_tween()
	bt.tween_interval(0.17)
	bt.tween_property(body, "modulate:a", 1.0, 0.24)


func _update_deck_training_dots() -> void:
	if not ui.has("deck_training_dots"):
		return
	var dots: HBoxContainer = ui["deck_training_dots"]
	for ch in dots.get_children():
		ch.queue_free()
	var n := _deck_training_slides().size()
	for i in range(n):
		var on := i == deck_training_index
		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(24 if on else 11, 11)
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var st := StyleBoxFlat.new()
		st.bg_color = GOLD if on else _with_alpha(TEXT_DIM, 0.5)
		st.set_corner_radius_all(6)
		st.anti_aliasing = false
		dot.add_theme_stylebox_override("panel", st)
		dots.add_child(dot)


func _update_deck_training_nav() -> void:
	var n := _deck_training_slides().size()
	if ui.has("deck_training_back"):
		var back: Button = ui["deck_training_back"]
		back.disabled = deck_training_index <= 0
		back.modulate = Color(1, 1, 1, 1) if deck_training_index > 0 else Color(1, 1, 1, 0.35)
	if ui.has("deck_training_next"):
		var next: Button = ui["deck_training_next"]
		next.text = "LET'S FISH" if deck_training_index >= n - 1 else "NEXT"


func _deck_training_prev() -> void:
	if deck_training_animating:
		return
	if deck_training_index > 0:
		deck_training_index -= 1
		_render_deck_training_slide(-1)


func _deck_training_next() -> void:
	if deck_training_animating:
		return
	if deck_training_index >= _deck_training_slides().size() - 1:
		_hide_deck_training()
	else:
		deck_training_index += 1
		_render_deck_training_slide(1)


func _show_deck_training() -> void:
	deck_training_index = 0
	deck_training_animating = false
	if deck_training_slide_node != null and is_instance_valid(deck_training_slide_node):
		deck_training_slide_node.queue_free()
	deck_training_slide_node = null
	_render_deck_training_slide(0)
	if ui.has("deck_training_overlay"):
		(ui["deck_training_overlay"] as Control).visible = true


func _hide_deck_training() -> void:
	if ui.has("deck_training_overlay"):
		(ui["deck_training_overlay"] as Control).visible = false


func _build_high_scores_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 210
	add_child(overlay)
	ui["high_scores_overlay"] = overlay

	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.88)
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(shade)

	var scroll := ScrollContainer.new()
	scroll.anchor_right = 1.0
	scroll.anchor_bottom = 1.0
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	overlay.add_child(scroll)

	var pad := MarginContainer.new()
	pad.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 48)
	pad.add_theme_constant_override("margin_bottom", 106)
	scroll.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 10)
	pad.add_child(col)
	ui["high_scores_col"] = col

	var back_btn := _tactile_button("BACK", 170, 50, BG_PANEL_LIGHT, GOLD_DEEP, GOLD)
	back_btn.anchor_left = 0.34
	back_btn.anchor_right = 0.66
	back_btn.anchor_top = 0.925
	back_btn.anchor_bottom = 0.975
	back_btn.offset_left = 0
	back_btn.offset_right = 0
	back_btn.offset_top = 0
	back_btn.offset_bottom = 0
	back_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	back_btn.pressed.connect(_return_from_high_scores)
	overlay.add_child(back_btn)
	ui["high_scores_back"] = back_btn


func _show_high_scores_screen() -> void:
	if not ui.has("high_scores_overlay") or not ui.has("high_scores_col"):
		return

	global_scores_status = "Loading global scores..." if _global_scores_enabled() else "Local scores on this device."
	_render_high_scores_screen(_load_high_scores(), "HIGH SCORES", global_scores_status)
	(ui["high_scores_overlay"] as Control).visible = true
	_fetch_global_high_scores()


func _render_high_scores_screen(scores: Array, title_text: String, status_text: String = "") -> void:
	var col: VBoxContainer = ui["high_scores_col"]
	for child in col.get_children():
		child.queue_free()

	var title := _label(title_text, 28, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	title.add_theme_constant_override("shadow_offset_y", 4)
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title)

	if status_text != "":
		var status := _label(status_text, FONT_SMALL, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
		status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(status)

	if scores.is_empty():
		var empty := _label("No games played yet.", FONT_BODY, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
		empty.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(empty)
	else:
		var header := HBoxContainer.new()
		header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header.add_theme_constant_override("separation", 6)
		col.add_child(header)

		var rank_h := _label("#", FONT_SMALL, TEXT_DIM)
		rank_h.custom_minimum_size = Vector2(28, 0)
		header.add_child(rank_h)
		var trophy_h := _label("★", FONT_SMALL, TEXT_DIM)
		trophy_h.custom_minimum_size = Vector2(32, 0)
		header.add_child(trophy_h)
		var money_h := _label("$", FONT_SMALL, TEXT_DIM)
		money_h.custom_minimum_size = Vector2(78, 0)
		header.add_child(money_h)
		var upgrade_h := _label("UPG", FONT_SMALL, TEXT_DIM)
		upgrade_h.custom_minimum_size = Vector2(38, 0)
		header.add_child(upgrade_h)
		var fish_h := _label("FISH", FONT_SMALL, TEXT_DIM)
		fish_h.custom_minimum_size = Vector2(46, 0)
		header.add_child(fish_h)
		var day_h := _label("DAY", FONT_SMALL, TEXT_DIM)
		day_h.custom_minimum_size = Vector2(40, 0)
		header.add_child(day_h)
		var mode_h := _label("MODE", FONT_SMALL, TEXT_DIM)
		mode_h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header.add_child(mode_h)
		header.add_child(_label("RESULT", FONT_SMALL, TEXT_DIM))

		col.add_child(_divider(BORDER_FRAME))

		for i in range(scores.size()):
			var entry: Dictionary = scores[i]
			var is_top := i < 3

			var row_wrap := PanelContainer.new()
			var row_bg := BG_PANEL_LIGHT if is_top else (BG_PANEL_DARK if i % 2 == 0 else BG_PANEL)
			var row_border := GOLD_DIM if i == 0 else BORDER_DARK
			var row_style := _styled(row_bg, row_border, 1 if i == 0 else 0, 4)
			row_style.content_margin_left = 8
			row_style.content_margin_right = 8
			row_style.content_margin_top = 8
			row_style.content_margin_bottom = 8
			row_wrap.add_theme_stylebox_override("panel", row_style)
			row_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			col.add_child(row_wrap)

			var row := HBoxContainer.new()
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_theme_constant_override("separation", 6)
			row_wrap.add_child(row)

			var rank_color := GOLD if i == 0 else (CYAN if i < 3 else TEXT_MUTED)
			var rank_lbl := _label("%d" % (i + 1), FONT_BODY, rank_color)
			rank_lbl.custom_minimum_size = Vector2(28, 0)
			row.add_child(rank_lbl)

			var t_count := int(entry.get("trophies", 0))
			var t_lbl := _label("%d" % t_count, FONT_BODY, GOLD if t_count >= 5 else TEXT_MUTED)
			t_lbl.custom_minimum_size = Vector2(32, 0)
			row.add_child(t_lbl)

			var m_lbl := _label("$%d" % int(entry.get("money", 0)), FONT_BODY, GOLD if is_top else TEXT_PRIMARY)
			m_lbl.custom_minimum_size = Vector2(78, 0)
			row.add_child(m_lbl)

			var u_lbl := _label("%d" % int(entry.get("upgrade_total", 0)), FONT_BODY, CYAN if is_top else TEXT_MUTED)
			u_lbl.custom_minimum_size = Vector2(38, 0)
			row.add_child(u_lbl)

			var f_lbl := _label("%d" % _entry_fish_count(entry), FONT_BODY, TEXT_MUTED)
			f_lbl.custom_minimum_size = Vector2(46, 0)
			row.add_child(f_lbl)

			var d_lbl := _label("%d" % int(entry.get("day", 0)), FONT_BODY, TEXT_MUTED)
			d_lbl.custom_minimum_size = Vector2(40, 0)
			row.add_child(d_lbl)

			var mode_text := "VS" if str(entry.get("mode", MODE_SOLO)) == MODE_VERSUS else "Solo"
			var mode_lbl := _label(mode_text, FONT_SMALL, TEXT_DIM)
			mode_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(mode_lbl)

			var outcome_text := str(entry.get("outcome", ""))
			var oc_color := GOLD if outcome_text == "CHAMPION!" else (RED if outcome_text == "SUNK!" or outcome_text == "DEFEATED" else TEXT_MUTED)
			row.add_child(_label(outcome_text, FONT_SMALL, oc_color, HORIZONTAL_ALIGNMENT_RIGHT))


func _return_from_high_scores() -> void:
	_hide_high_scores_screen()
	_show_start_screen()


func _hide_high_scores_screen() -> void:
	if ui.has("high_scores_overlay"):
		(ui["high_scores_overlay"] as Control).visible = false
