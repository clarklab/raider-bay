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
const BOARD_CELL_WIDTH := 68
const BOARD_CELL_HEIGHT := 94
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
const TABLE_SIDE_WIDTH := 232
const TABLE_COMMAND_WIDTH := 556
const TABLE_HEADER_HEIGHT := 118
const SAVE_PATH := "user://raider_bay_save.json"
const HIGH_SCORES_PATH := "user://raider_bay_high_scores.json"
const GLOBAL_SCORES_API := "https://raiderbay.netlify.app/api/scores"
const Leaderboards := preload("res://scripts/leaderboards.gd")
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
const BOAT_TEXTURES: Array[Texture2D] = [
	preload("res://assets/boats/boat-1.png"),
	preload("res://assets/boats/boat-2.png"),
	preload("res://assets/boats/boat-3.png"),
	preload("res://assets/boats/boat-4.png"),
]

# Each boat comes rigged with one free starting upgrade (its first card, no
# cost) — index-aligned with BOAT_TEXTURES.
const BOAT_PERKS: Array[String] = ["motor", "fish_finder", "live_well", "nets"]

# Mix-and-match phrasebook for the Boat Setup shuffle. Boat = "The {adj} {noun}",
# captain = "{first} {last}".
const BOAT_ADJ := [
	"Rusty", "Wild", "Rocky", "Salty", "Frozen", "Lucky", "Grumpy", "Mighty", "Crooked",
	"Drunken", "Wicked", "Foggy", "Slippery", "Ragged", "Howling", "Restless", "Battered",
	"Bristly", "Lonesome", "Stubborn",
]
const BOAT_NOUN := [
	"Shark", "Point", "Halibut", "Kodiak", "Otter", "Ptarmigan", "Sockeye", "Walrus",
	"Puffin", "Glacier", "Grizzly", "Barnacle", "King Crab", "Sea Dog", "Bering", "Tundra",
	"Moose", "Sourdough", "Chinook", "Mudflat",
]
const CAPTAIN_FIRST := [
	"Barnaby", "Elias", "Cornelius", "Silas", "Amos", "Ezekiel", "Jebediah", "Mortimer",
	"Thaddeus", "Bartholomew", "Horace", "Ingmar", "Sven", "Knut", "Magnus", "Percival",
	"Gus", "Alistair", "Ebenezer", "Fitzgerald",
]
const CAPTAIN_LAST := [
	"McGraw", "Frostbeard", "Salteye", "Codd", "Barnacle", "Grimsby", "Tarbuckle",
	"Coldwater", "Blackfin", "Stormcrow", "Bilgewater", "Northwind", "Driftwood",
	"Whalebone", "Ironhook", "Sourdough", "Halibutton", "Kettleford", "Frosthook",
	"Bergstrom",
]
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
const CATCH_WAVES_VIDEO: VideoStream = preload("res://assets/cutscenes/catch-waves-1.ogv")
const CATCH_CALM_VIDEO: VideoStream = preload("res://assets/cutscenes/catch-calm.ogv")
const CATCH_STORM_VIDEO: VideoStream = preload("res://assets/cutscenes/catch-storm-squall.ogv")
const CARD_WEATHER_CALM: Texture2D = preload("res://assets/cards/card-weather-calm-1.png")
const CARD_WEATHER_RAIN: Texture2D = preload("res://assets/cards/card-weather-rain-1.png")
const CARD_WEATHER_SQUALL: Texture2D = preload("res://assets/cards/card-weather-squall-1.png")
const CARD_WEATHER_HURRICANE: Texture2D = preload("res://assets/cards/card-weather-hurricane-1.png")
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
const CARD_WELL_TEXTURES: Array[Texture2D] = [
	preload("res://assets/cards/card-well-1.png"),
	preload("res://assets/cards/card-well-2.png"),
	preload("res://assets/cards/card-well-3.png"),
	preload("res://assets/cards/card-well-4.png"),
	preload("res://assets/cards/card-well-5.png"),
]
# Small per-level icon art used inside the mini cards in the shop lanes.
const ICON_MOTOR_SMALL: Array[Texture2D] = [
	preload("res://assets/icons/icon-motor-1-small.png"),
	preload("res://assets/icons/icon-motor-2-small.png"),
	preload("res://assets/icons/icon-motor-3-small.png"),
	preload("res://assets/icons/icon-motor-4-small.png"),
	preload("res://assets/icons/icon-motor-5-small.png"),
]
const ICON_FINDER_SMALL: Array[Texture2D] = [
	preload("res://assets/icons/icon-finder-1-small.png"),
	preload("res://assets/icons/icon-finder-2-small.png"),
	preload("res://assets/icons/icon-finder-3-small.png"),
	preload("res://assets/icons/icon-finder-4-small.png"),
	preload("res://assets/icons/icon-finder-5-small.png"),
]
const ICON_NETS_SMALL: Array[Texture2D] = [
	preload("res://assets/icons/icon-nets-1-small.png"),
	preload("res://assets/icons/icon-nets-2-small.png"),
	preload("res://assets/icons/icon-nets-3-small.png"),
	preload("res://assets/icons/icon-nets-4-small.png"),
	preload("res://assets/icons/icon-nets-5-small.png"),
]
const ICON_WELL_SMALL: Array[Texture2D] = [
	preload("res://assets/icons/icon-well-1-small.png"),
	preload("res://assets/icons/icon-well-2-small.png"),
	preload("res://assets/icons/icon-well-3-small.png"),
	preload("res://assets/icons/icon-well-4-small.png"),
	preload("res://assets/icons/icon-well-5-small.png"),
]

const BG_CALM_STREAM: AudioStream = preload("res://assets/bg-calm.mp3")
const BG_BIRDS_STREAM: AudioStream = preload("res://assets/bg-birds.mp3")
const BG_WAVES_STREAM: AudioStream = preload("res://assets/bg-waves.mp3")
const MUSIC_HIGH_SCORES_STREAM: AudioStream = preload("res://assets/music/high-scores.mp3")
const MUSIC_SHOP_STREAM: AudioStream = preload("res://assets/music/shop-upgrade.mp3")
const SOUND_REEL_STREAM: AudioStream = preload("res://assets/sound-reel.mp3")
const SOUND_BONK_STREAM: AudioStream = preload("res://assets/sound-bonk.mp3")
const SOUND_CATCH_STREAM: AudioStream = preload("res://assets/sound-catch.mp3")

# Update channel: newest release metadata + the constant-name APK asset the
# release workflow uploads, so this link always serves the latest build.
const UPDATE_RELEASE_API := "https://api.github.com/repos/clarklab/raider-bay/releases/latest"
const UPDATE_DOWNLOAD_URL := "https://github.com/clarklab/raider-bay/releases/latest/download/raider-bay.apk"

# One-shot UI/event sounds (assets/sounds). Played via _play_sfx on the master
# bus, so the title-screen MUTE toggle silences them with everything else.
const SFX_STREAMS: Dictionary = {
	"tap": preload("res://assets/sounds/sfx-tap.mp3"),
	"tap_cancel": preload("res://assets/sounds/sfx-tap-cancel.mp3"),
	"modal_open": preload("res://assets/sounds/sfx-modal-open.mp3"),
	"card_flip": preload("res://assets/sounds/sfx-card-flip.mp3"),
	"card_slide": preload("res://assets/sounds/sfx-card-slide.mp3"),
	"dice_roll": preload("res://assets/sounds/dice-roll.mp3"),
	"confetti": preload("res://assets/sounds/sfx-confetti.mp3"),
	"bonk_1": preload("res://assets/sounds/sfx-bonk-1.mp3"),
	"bonk_2": preload("res://assets/sounds/sfx-bonk-2.mp3"),
	"haggle_avg": preload("res://assets/sounds/sfx-haggle-avg.mp3"),
	"trophy": preload("res://assets/sounds/sfx-trophy.mp3"),
	"title_slam": preload("res://assets/sounds/sfx-title-slam.mp3"),
}
# Per-sound base volume: taps sit under the ambience; celebrations get the stage.
const SFX_BASE_DB: Dictionary = {
	"tap": -9.0,
	"tap_cancel": -9.0,
	"modal_open": -7.0,
	"card_flip": -6.0,
	"card_slide": -6.0,
	"dice_roll": -4.0,
	"confetti": -4.0,
	"bonk_1": -3.0,
	"bonk_2": -3.0,
	"haggle_avg": -4.0,
	"trophy": -3.0,
	"title_slam": -4.0,
}

# Birds cycle: distant → near → close → gone, on a rolling loop. Volumes are
# linear amplitudes (0..1); we crossfade between them so the birds "come and
# go" rather than snapping between levels.
const BIRDS_VOLUME_PHASES: Array[float] = [0.20, 0.60, 0.80, 0.0]
const BIRDS_PHASE_SECONDS := 22.0
const BIRDS_TRANSITION_SECONDS := 7.0
const WEATHER_AUDIO_CROSSFADE_SECONDS := 1.8
const MUSIC_CROSSFADE_SECONDS := 0.9
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
# Structural colors sampled from the study (source-assets/art/preview-design.png).
const REF_BG_NAVY    := Color("#061854")  # deep screen background
const REF_PANEL      := Color("#486084")  # right-side group + boat-status panel fill
const REF_INSET      := Color("#0c182a")  # dark list/container insets
const REF_CARD_NAVY  := Color("#24487e")  # weather card body
const REF_BORDER     := Color("#fcfcfc")  # card / cell white border
const BG_ROW         := Color("#243f5f")
const BORDER_DARK    := Color("#07121c")
const BORDER_FRAME   := Color("#27668d")
const BORDER_HI      := Color("#6fb6d8")
const TEXT_PRIMARY   := Color("#f1f7fb")
const TEXT_MUTED     := Color("#a3bccd")
const TEXT_DIM       := Color("#5a7993")
# Accents sampled from source-assets/art/preview-design.png (the study) for an exact match.
const CYAN           := Color("#8ad2f0")
const CYAN_DEEP      := Color("#1688b0")
const GOLD           := Color("#fcba00")
const GOLD_DEEP      := Color("#b98a1d")
const GOLD_DIM       := Color("#5b4818")
const NEON_COMPUTER_YELLOW := Color("#fff04a")
const RED            := Color("#fc6060")
const RED_DEEP       := Color("#a64545")
const RED_DIM        := Color("#5b1f24")
const GREEN          := Color("#84ed72")
const GREEN_DEEP     := Color("#2e8c66")
const PURPLE         := Color("#c684fc")
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

# Boat Setup screen (chosen fresh each new game; flavor only for now).
var pending_versus := false
var boat_choice := 0
var boat_perk_key := ""  # starter upgrade category — permanently one price step cheaper
const PREFS_PATH := "user://prefs.cfg"
var seen_training := false  # first launch ever auto-opens DECK TRAINING once
var boat_name := ""
var captain_name := ""

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
var market_flip: Dictionary = {}  # species -> last night's price (drives the odometer flip)
var sold_totals: Dictionary = {}
var trophies: Dictionary = {}
var sale_selection: Dictionary = {}
var pending_haggle: Dictionary = {}
var _pixel_die_tex: Texture2D = null
var extra_nights := 0
var upgrade_cart: Dictionary = {}
var extra_night_cart := 0

var weather_deck: Array[Dictionary] = []
var forecast: Array[Dictionary] = []
var current_weather: Dictionary = {"name": "Calm", "strength": 0}
# Full-size card popup (weather chips + board squares): fly-up flip from the
# tapped source control. weather_preview_spec: {"title", "accent", "front":
# Callable(cw,ch)->Control, "fill_desc": Callable(RichTextLabel)}.
var weather_preview_source_rect := Rect2()
var weather_preview_source: Control = null
var weather_preview_opening := false
var weather_preview_spec: Dictionary = {}
var weather_preview_tween: Tween = null
var weather_preview_fly: Control = null
var weather_preview_fly_front: Control = null
var weather_preview_fly_back: Control = null
var weather_preview_closing := false
var weather_preview_seq := 0
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
var action_blink: Dictionary = {}  # left-rail counter key -> attention pulse on
var action_blink_time := 0.0
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
var audio_high_scores: AudioStreamPlayer
var audio_shop: AudioStreamPlayer
var high_scores_music_volume: float = 0.0
var shop_music_volume: float = 0.0
var _hs_music_was_open: bool = false
var _shop_music_was_open: bool = false
var audio_reel: AudioStreamPlayer
var audio_bonk: AudioStreamPlayer
var audio_catch: AudioStreamPlayer
var plonk_players: Array[AudioStreamPlayer] = []
var plonk_index: int = 0
var cast_audio_token: int = 0
var audio_muted: bool = false
var sfx_players: Array[AudioStreamPlayer] = []
var sfx_pool_index: int = 0
var sfx_last_played_ms: Dictionary = {}
var sfx_gesture_seen: bool = false
var dice_sfx_player: AudioStreamPlayer = null
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
	_build_audio()  # before the start screen: the title intro plays a slam SFX
	_show_start_screen()
	_build_global_score_requests()
	_apply_safe_area_inset()
	get_viewport().size_changed.connect(_apply_safe_area_inset)
	set_process(true)
	_schedule_catch_preview_from_query()
	_schedule_deck_preview_from_query()
	# Promo/demo capture: `-- --autoplay` drives a full scripted playthrough for
	# Movie Maker recording. Inert in every normal launch; suppresses the training
	# and update overlays so nothing covers the reel.
	if OS.get_cmdline_user_args().has("--autoplay"):
		_start_autopilot()
		return
	_maybe_show_first_run_training()
	get_tree().create_timer(2.0).timeout.connect(_maybe_check_for_update)


# ────────────────────────────────────────────────────────────────────────
# Autopilot — a scripted solo playthrough for promo/landing capture. Enabled
# only by `-- --autoplay` on the command line (see _ready). It drives the REAL
# gameplay functions with paced awaits, so the recording is genuine play, not a
# mockup. RNG is pinned to AUTOPILOT_SEED for a reproducible "good take".
# ────────────────────────────────────────────────────────────────────────

const AUTOPILOT_SEED := 20260706
const AUTOPILOT_DAYS := 4
var autopilot := false

func _start_autopilot() -> void:
	autopilot = true
	seen_training = true  # never let the first-run training overlay cover the reel
	rng.seed = AUTOPILOT_SEED   # gameplay RNG (board, catches, market, haggle, names)
	seed(AUTOPILOT_SEED)        # global RNG (board-deal card scatter cosmetics)
	call_deferred("_run_autopilot")


func _ap_wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func _run_autopilot() -> void:
	await _ap_wait(1.2)                       # beat on the title
	_new_game(false)                          # opens Boat Setup
	await _ap_wait(1.1)
	_boat_setup_shuffle()                     # a die tumbles — setup flavor
	await _ap_wait(1.4)
	boat_choice = 0                           # boat #0: motor perk
	_refresh_boat_carousel()
	await _ap_wait(0.9)
	_boat_setup_set_sail()                    # builds the game + deals the board
	await _ap_wait(1.8)

	# Equip a lively demo boat so every trip shows a finder ping AND a catch and
	# has the moves to fish and get home in a single day.
	upgrades["fish_finder"] = maxi(1, int(upgrades["fish_finder"]))
	upgrades["motor"] = maxi(1, int(upgrades["motor"]))
	_refresh_daily_actions(true)
	_update_ui()
	await _ap_wait(0.6)

	for d in range(AUTOPILOT_DAYS):
		if game_over:
			break
		await _ap_play_day(d)

	await _ap_wait(1.8)
	get_tree().quit()


# One full catch → sell → end-day cycle.
func _ap_play_day(day_index: int) -> void:
	var target := _ap_best_fish_cell()
	if target.x >= 0:
		await _ap_move_to(target)
	elif _is_docked():
		await _ap_move_to(Vector2i(DOCK_COL, GRID_ROWS - 1))  # at least leave the dock
	await _ap_wait(0.4)

	if _can_find_here():
		_find_fish()                          # finder card-fan
		await _ap_wait(1.4)
	if _can_attempt_cast_here():
		_cast()                               # catch card-fan
		await _ap_wait(1.9)

	await _ap_dock()
	await _ap_wait(0.5)

	if _is_docked() and not live_well.is_empty():
		_sell_catch()                         # opens the sell modal (all selected)
		await _ap_wait(0.9)
		if day_index % 2 == 1:
			_haggle_sale()                    # dice roll + confetti / BONK
			await _ap_wait(3.0)
		else:
			_confirm_sale()                   # straight SOLD
			await _ap_wait(1.5)
		await _ap_wait(1.0)
		_close_sell_modal()
		await _ap_wait(0.5)

	_end_day()                                # weather resolve + day transition
	await _ap_wait(2.1)


# Nearest fishable fish tile we can reach AND still get home from this turn,
# preferring closer and shallower (higher-row) water.
func _ap_best_fish_cell() -> Vector2i:
	var access := _ap_dock_access_cells()
	var best := Vector2i(-1, -1)
	var best_score := 1 << 30
	for y in range(GRID_ROWS):
		for x in range(GRID_COLS):
			var idx := y * GRID_COLS + x
			var tile: Dictionary = board[idx]
			if str(tile["content"]) != "fish" or bool(tile["depleted"]):
				continue
			if cast_holes_today.has(idx):
				continue
			var cell := Vector2i(x, y)
			var to_fish := _ap_cheb(boat_pos, cell)
			var home := _ap_cheb(cell, _ap_nearest(access, cell)) + 1  # +1 to dock
			if to_fish + home > moves_remaining:
				continue
			var score := to_fish * 2 + (GRID_ROWS - y)
			if score < best_score:
				best_score = score
				best = cell
	return best


func _ap_dock_access_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(DOCK_ACCESS_START_COL, DOCK_ACCESS_END_COL + 1):
		cells.append(Vector2i(x, GRID_ROWS - 1))
	return cells


func _ap_cheb(a: Vector2i, b: Vector2i) -> int:
	return maxi(absi(a.x - b.x), absi(a.y - b.y))


func _ap_nearest(cells: Array, from: Vector2i) -> Vector2i:
	var best: Vector2i = cells[0]
	var best_dist := 1 << 30
	for c in cells:
		var d := _ap_cheb(from, c)
		if d < best_dist:
			best_dist = d
			best = c
	return best


# Diagonal-capable walk toward a sea cell, one step per beat, stopping if blocked
# or out of moves.
func _ap_move_to(target: Vector2i) -> void:
	var guard := 0
	while boat_pos != target and moves_remaining > 0 and guard < 16:
		guard += 1
		var prev := boat_pos
		var d := target - boat_pos
		_move(Vector2i(signi(d.x), signi(d.y)))
		if boat_pos == prev:
			break  # rejected (edge / rudder / dock rules) — don't spin
		await _ap_wait(0.6)


# Route back to the nearest dock mouth and dock.
func _ap_dock() -> void:
	if _is_docked():
		return
	var access := _ap_nearest(_ap_dock_access_cells(), boat_pos)
	await _ap_move_to(access)
	if _is_dock_access_cell(boat_pos) and moves_remaining > 0:
		var dock_x := clampi(boat_pos.x, DOCK_START_COL, DOCK_END_COL)
		_move(Vector2i(dock_x - boat_pos.x, 1))


# Sideloaded Android builds don't self-update, so the title screen offers the
# newest release when GitHub has one. CI stamps application/config/version from
# the tag; local "dev" builds never nag. Web debug hook: ?update_preview forces
# the check (the web build itself always ships current, so it's excluded).
var update_check_started: bool = false

func _maybe_check_for_update() -> void:
	var forced := OS.has_feature("web") and str(JavaScriptBridge.eval("window.location.search", true)).find("update_preview") != -1
	if not (OS.has_feature("android") or forced):
		return
	if update_check_started:
		return
	update_check_started = true
	var current := str(ProjectSettings.get_setting("application/config/version", "dev"))
	if forced:
		current = "0.0.1"
	if current.is_empty() or not current[0].is_valid_int():
		return
	var req := HTTPRequest.new()
	req.timeout = 10.0
	add_child(req)
	req.request_completed.connect(func(_result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
		req.queue_free()
		if code != 200:
			return
		var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
		if not (parsed is Dictionary):
			return
		var latest := str((parsed as Dictionary).get("tag_name", "")).trim_prefix("v")
		if latest.is_empty() or latest == current:
			return
		_show_update_chip(latest))
	# No custom User-Agent: browsers forbid it and the web fetch would fail.
	# Native builds send the engine UA, which GitHub accepts.
	req.request(UPDATE_RELEASE_API, ["Accept: application/vnd.github+json"])


func _show_update_chip(latest: String) -> void:
	if not ui.has("start_overlay") or ui.has("update_chip"):
		return
	var overlay := ui["start_overlay"] as Control
	var chip := _flat_button("GET UPDATE v%s" % latest, 0, 56, GOLD, Color("#3a2a00"), 22, 14)
	chip.pressed.connect(func() -> void: OS.shell_open(UPDATE_DOWNLOAD_URL))
	var wrap := CenterContainer.new()
	wrap.anchor_right = 1.0
	var vp := get_viewport_rect().size
	wrap.offset_top = vp.y * 0.87
	wrap.offset_bottom = vp.y * 0.87 + 62.0
	wrap.add_child(chip)
	overlay.add_child(wrap)
	ui["update_chip"] = wrap
	wrap.modulate = Color(1, 1, 1, 0)
	var t := wrap.create_tween()
	t.tween_property(wrap, "modulate:a", 1.0, 0.3)


# First boot ever: open DECK TRAINING over the title so new players learn the
# ropes before their first trip. Closing it (X or LET'S FISH) marks it seen.
func _maybe_show_first_run_training() -> void:
	_load_prefs()
	if seen_training:
		return
	# Preview/debug query hooks drive their own screens — don't fight them.
	# (Match the schedulers: they read the hash too.)
	if OS.has_feature("web") and str(JavaScriptBridge.eval("window.location.search + window.location.hash", true)).find("preview") != -1:
		return
	call_deferred("_show_deck_training")


func _load_prefs() -> void:
	var cf := ConfigFile.new()
	if cf.load(PREFS_PATH) == OK:
		seen_training = bool(cf.get_value("onboarding", "seen_training", false))


func _save_prefs() -> void:
	var cf := ConfigFile.new()
	cf.set_value("onboarding", "seen_training", seen_training)
	cf.save(PREFS_PATH)


func _schedule_deck_preview_from_query() -> void:
	if not OS.has_feature("web") and not ClassDB.class_exists("JavaScriptBridge"):
		return
	var search := str(JavaScriptBridge.eval("window.location.search + window.location.hash", true))
	if search.find("deck_preview=") == -1:
		return
	var raw := ""
	for part in search.trim_prefix("?").split("&", false):
		if part.find("deck_preview=") != -1:
			raw = part.get_slice("deck_preview=", 1)
			break
	var idx := int(raw)
	call_deferred("_run_deck_preview", idx)


func _run_deck_preview(idx: int) -> void:
	_show_deck_training()
	deck_training_index = clampi(idx, 0, _deck_training_slides().size() - 1)
	_render_deck_training_slide(0)


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
	var dice_sign := 0
	for part in query.split("&", false):
		if part.begins_with("dice="):
			dice_sign = clampi(int(part.trim_prefix("dice=")), -1, 1)
			break
	call_deferred("_run_catch_preview", species, quantity, multiplier, dice_sign)


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


func _run_catch_preview(species: String, quantity: int, multiplier: int, dice_sign: int = 0) -> void:
	if ui.has("start_overlay"):
		(ui["start_overlay"] as Control).visible = false
	await get_tree().create_timer(0.35).timeout
	if dice_sign == 0:
		_show_catch_card_fan(species, quantity, multiplier)
		return
	var droll := rng.randi_range(1, 6)
	var delta := int(ceil(float(droll) / 2.0)) if dice_sign > 0 else -int(floor(float(droll - 1) / 2.0))
	var final := maxi(1, quantity + delta)
	_show_catch_card_fan(species, final, 1, Vector2(-1, -1), dice_sign, final - quantity, quantity)


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
		root.add_theme_constant_override("margin_left", 10 + left_inset)
		root.add_theme_constant_override("margin_top", top_inset)
		root.add_theme_constant_override("margin_right", 10 + right_inset)
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
	action_blink_time += delta
	_update_action_blink()
	_update_audio(delta)
	_update_end_day_prompt(delta)
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
	audio_high_scores = _make_loop_player(MUSIC_HIGH_SCORES_STREAM, AUDIO_SILENT_DB)
	audio_shop = _make_loop_player(MUSIC_SHOP_STREAM, AUDIO_SILENT_DB)
	audio_reel = _make_one_shot_player(SOUND_REEL_STREAM)
	audio_bonk = _make_one_shot_player(SOUND_BONK_STREAM)
	audio_catch = _make_one_shot_player(SOUND_CATCH_STREAM)
	_build_plonk_players()
	_build_sfx_pool()


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


func _input(event: InputEvent) -> void:
	if not sfx_gesture_seen and (event is InputEventMouseButton or event is InputEventScreenTouch or event is InputEventKey):
		sfx_gesture_seen = true


func _build_sfx_pool() -> void:
	for stream in SFX_STREAMS.values():
		if stream is AudioStreamMP3:
			(stream as AudioStreamMP3).loop = false
	for i in range(8):
		var p := AudioStreamPlayer.new()
		p.autoplay = false
		add_child(p)
		sfx_players.append(p)


# Round-robin one-shot pool with a small per-sound throttle so simultaneous
# triggers (e.g. an X press that also closes a popup) don't phase-stack.
func _play_sfx(sfx: String, volume_offset_db: float = 0.0, pitch: float = 1.0, throttle_ms: int = 70) -> AudioStreamPlayer:
	if sfx_players.is_empty() or not SFX_STREAMS.has(sfx):
		return null
	# Pre-gesture the browser AudioContext is suspended; a one-shot queued now
	# would pop, stale, on the player's first tap. Drop it instead.
	if OS.has_feature("web") and not sfx_gesture_seen:
		return null
	var now := Time.get_ticks_msec()
	if sfx_last_played_ms.has(sfx) and now - int(sfx_last_played_ms[sfx]) < throttle_ms:
		return null
	sfx_last_played_ms[sfx] = now
	var player := sfx_players[sfx_pool_index % sfx_players.size()]
	sfx_pool_index += 1
	player.stop()
	player.stream = SFX_STREAMS[sfx]
	player.volume_db = float(SFX_BASE_DB.get(sfx, 0.0)) + volume_offset_db
	player.pitch_scale = pitch
	player.play()
	return player


# Factory-wired button audio: a soft tap, or the cancel variant for dismiss-y
# labels. Set a "sfx" meta on a button to override (empty string = silent).
func _play_button_sfx(b: Button) -> void:
	var sfx := "tap"
	if b.has_meta("sfx"):
		sfx = str(b.get_meta("sfx"))
	elif b.text.strip_edges().to_upper() in ["CANCEL", "X", "BACK", "CLOSE", "NO"]:
		sfx = "tap_cancel"
	if sfx != "":
		_play_sfx(sfx)


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
	var weather_name := str(current_weather.get("name", "Calm")) if not current_weather.is_empty() else "Calm"
	var want_calm := on_start_screen or weather_name == "Calm"

	# Screen music: high scores + shop (upgrade/repair). Fades in over the ambient
	# bed, which ducks out while a track plays.
	var hs_open := ui.has("high_scores_overlay") and (ui["high_scores_overlay"] as Control).visible
	var shop_open := active_tray == "upgrade" or active_tray == "repair"
	# Restart each theme from the top when its screen is first opened.
	if hs_open and not _hs_music_was_open and audio_high_scores != null:
		audio_high_scores.seek(0.0)
	if shop_open and not _shop_music_was_open and audio_shop != null:
		audio_shop.seek(0.0)
	_hs_music_was_open = hs_open
	_shop_music_was_open = shop_open
	var music_step := delta / MUSIC_CROSSFADE_SECONDS
	high_scores_music_volume = move_toward(high_scores_music_volume, 1.0 if hs_open else 0.0, music_step)
	shop_music_volume = move_toward(shop_music_volume, 1.0 if shop_open else 0.0, music_step)
	if audio_high_scores != null:
		audio_high_scores.volume_db = AUDIO_SILENT_DB if high_scores_music_volume <= 0.001 else linear_to_db(high_scores_music_volume)
	if audio_shop != null:
		audio_shop.volume_db = AUDIO_SILENT_DB if shop_music_volume <= 0.001 else linear_to_db(shop_music_volume)
	var duck := 1.0 - maxf(high_scores_music_volume, shop_music_volume)

	var calm_target := 1.0 if want_calm else 0.0
	var waves_target := 0.0 if want_calm else 1.0
	var step := delta / WEATHER_AUDIO_CROSSFADE_SECONDS
	calm_current_volume = move_toward(calm_current_volume, calm_target, step)
	waves_current_volume = move_toward(waves_current_volume, waves_target, step)
	var calm_v := calm_current_volume * duck
	var waves_v := waves_current_volume * duck
	audio_calm.volume_db = AUDIO_SILENT_DB if calm_v <= 0.001 else linear_to_db(calm_v)
	audio_waves.volume_db = AUDIO_SILENT_DB if waves_v <= 0.001 else linear_to_db(waves_v)

	birds_phase_time += delta
	if birds_phase_time >= BIRDS_PHASE_SECONDS:
		birds_phase_time = fmod(birds_phase_time, BIRDS_PHASE_SECONDS)
		birds_previous_volume = BIRDS_VOLUME_PHASES[birds_phase_index]
		birds_phase_index = (birds_phase_index + 1) % BIRDS_VOLUME_PHASES.size()
	var birds_target: float = BIRDS_VOLUME_PHASES[birds_phase_index]
	var fade_t := clampf(birds_phase_time / BIRDS_TRANSITION_SECONDS, 0.0, 1.0)
	var eased := smoothstep(0.0, 1.0, fade_t)
	var birds_v := lerpf(birds_previous_volume, birds_target, eased) * duck
	audio_birds.volume_db = AUDIO_SILENT_DB if birds_v <= 0.001 else linear_to_db(birds_v)


# Once there's nothing useful left to do at sea, flash the MOVES/END DAY counter
# (it reads "END DAY" at that point) so it's obvious that's the tap to finish the day.
func _update_end_day_prompt(delta: float) -> void:
	if not ui.has("stat_moves"):
		return
	var card: Control = ui["stat_moves"]
	if not is_instance_valid(card):
		return
	# Also stand down while the full-screen card preview covers the board.
	var covered := ui.has("weather_preview_overlay") and (ui["weather_preview_overlay"] as Control).visible
	if not game_started or game_over or active_tray != "" or _is_docked() or _has_useful_action() or covered:
		if end_day_prompt_time != 0.0:
			end_day_prompt_time = 0.0
			card.modulate = Color(1, 1, 1, 1)
		return
	end_day_prompt_time += delta
	var t := (sin(end_day_prompt_time * PI * 2.6) + 1.0) * 0.5
	var glow := lerpf(1.0, 1.55, t)
	card.modulate = Color(glow, glow, glow, 1.0)


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
	background_wash.color = _with_alpha(REF_BG_NAVY, 0.66)
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
	root.add_theme_constant_override("margin_left", 10)
	root.add_theme_constant_override("margin_top", 0)
	root.add_theme_constant_override("margin_right", 10)
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
	_build_boat_setup_screen()
	_build_weather_card_preview_overlay()


func _build_table_layout(parent: Container) -> void:
	# Board gets the full vertical space: no top header, no bottom log strip flanking it.
	var main := HBoxContainer.new()
	main.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main.add_theme_constant_override("separation", 14)
	parent.add_child(main)

	_build_left_table_rail(main)
	_build_center_table(main)
	_build_command_rail(main)


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

	col.add_child(_counter_button("stat_day", ICON_DAY_TEXTURE, "DAY", Color("#8ad2f0"), Color("#12548a"), Callable()))
	col.add_child(_counter_button("stat_funds", ICON_FUNDS_TEXTURE, "FUNDS", Color("#fcba00"), Color("#723c00"), _on_funds_pressed))
	col.add_child(_counter_button("stat_moves", ICON_MOVES_TEXTURE, "MOVES", Color("#fc6060"), Color("#781818"), _request_end_day))
	col.add_child(_counter_button("stat_finds", ICON_FIND_FISH_TEXTURE, "FIND FISH", Color("#c889ff"), Color("#3e1799"), _on_finds_counter_pressed))
	col.add_child(_counter_button("stat_casts", ICON_CAST_TEXTURE, "CAST", Color("#84ea72"), Color("#005860"), _cast))


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
	rail.size_flags_horizontal = Control.SIZE_SHRINK_END
	rail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	rail.clip_contents = true
	parent.add_child(rail)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 6)
	pad.add_theme_constant_override("margin_right", 6)
	pad.add_theme_constant_override("margin_top", 6)
	pad.add_theme_constant_override("margin_bottom", 6)
	rail.add_child(pad)

	var outer := VBoxContainer.new()
	outer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_theme_constant_override("separation", 10)
	pad.add_child(outer)

	# The forecast + live well + market are one grouped interface; boat status sits below.
	_build_forecast_group(outer)
	_build_boat_status_panel(outer)


# Forecast card-stack + the Live Well / Market interface attached beneath it.
func _build_forecast_group(parent: Container) -> void:
	var group := PanelContainer.new()
	group.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	group.size_flags_vertical = Control.SIZE_EXPAND_FILL
	group.size_flags_stretch_ratio = 1.35
	var gstyle := _styled_shadow(REF_PANEL, REF_PANEL.darkened(0.32), 2, 13, 5)
	gstyle.content_margin_left = 13
	gstyle.content_margin_right = 13
	gstyle.content_margin_top = 11
	gstyle.content_margin_bottom = 12
	group.add_theme_stylebox_override("panel", gstyle)
	parent.add_child(group)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 10)
	group.add_child(col)

	# Header — title + the radio megaphone.
	var head := HBoxContainer.new()
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_theme_constant_override("separation", 8)
	col.add_child(head)
	var title := _label("WEATHER FORECAST", 17, CYAN)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(title)
	head.add_child(_radio_megaphone_button())

	# Weather card stack sits in a dark inset; it's wider than the window so further
	# days peek off the right edge.
	var wx_inset := PanelContainer.new()
	wx_inset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var wxs := _styled(REF_INSET, REF_INSET.lightened(0.08), 1, 11)
	wxs.content_margin_left = 9
	wxs.content_margin_right = 9
	wxs.content_margin_top = 9
	wxs.content_margin_bottom = 9
	wx_inset.add_theme_stylebox_override("panel", wxs)
	col.add_child(wx_inset)
	var window := Control.new()
	window.clip_contents = true
	window.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	window.custom_minimum_size = Vector2(0, 112)
	wx_inset.add_child(window)
	var strip := HBoxContainer.new()
	strip.add_theme_constant_override("separation", WEATHER_DAY_CARD_GAP)
	strip.anchor_top = 0.0
	strip.anchor_bottom = 1.0
	window.add_child(strip)
	ui["weather_strip"] = strip

	# Live Well + Market interface row.
	var iface := HBoxContainer.new()
	iface.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	iface.size_flags_vertical = Control.SIZE_EXPAND_FILL
	iface.add_theme_constant_override("separation", 10)
	col.add_child(iface)
	iface.add_child(_build_live_well_column())
	iface.add_child(_build_market_column())


func _radio_megaphone_button() -> Control:
	var btn := Button.new()
	btn.focus_mode = Control.FOCUS_NONE
	btn.custom_minimum_size = Vector2(36, 30)
	btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_apply_transparent_button_style(btn)
	btn.pressed.connect(_on_radio_pressed)
	var ic := _icon_texture_rect(ICON_RADIO_TEXTURE, Vector2(28, 26), TEXT_PRIMARY)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(ic)
	btn.add_child(ic)
	return btn


# Section header (cyan) on the slate panel, with a dark inset list below it.
func _build_inset_section(title_text: String, accent: Color, ratio: float, rows_key: String, subhead: String = "", status_key: String = "") -> Control:
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.size_flags_stretch_ratio = ratio
	col.add_theme_constant_override("separation", 5)

	var head := HBoxContainer.new()
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(head)
	var title := _label(title_text, 16, accent)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	if subhead != "":
		head.add_child(_label(subhead, 11, TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT))
	if status_key != "":
		ui[status_key] = _label("EMPTY", 12, TEXT_MUTED, HORIZONTAL_ALIGNMENT_RIGHT)
		ui[status_key].clip_text = true
		head.add_child(ui[status_key])

	var inset := PanelContainer.new()
	inset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inset.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var istyle := _styled(REF_INSET, REF_INSET.lightened(0.08), 1, 9)
	istyle.content_margin_left = 9
	istyle.content_margin_right = 9
	istyle.content_margin_top = 8
	istyle.content_margin_bottom = 8
	inset.add_theme_stylebox_override("panel", istyle)
	inset.clip_contents = true
	col.add_child(inset)

	var rows := VBoxContainer.new()
	rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rows.add_theme_constant_override("separation", 4)
	inset.add_child(rows)
	ui[rows_key] = rows
	return col


func _build_live_well_column() -> Control:
	return _build_inset_section("LIVE WELL", CYAN, 1.08, "live_well_lines", "", "live_well_status")


func _build_market_column() -> Control:
	return _build_inset_section("MARKET PRICES", CYAN, 0.92, "top_market_rows")


# Boat status: overlapping mini-cards that double as power meters, in three columns.
func _build_boat_status_panel(parent: Container) -> void:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.size_flags_stretch_ratio = 1.0
	var style := _styled_shadow(REF_PANEL, REF_PANEL.darkened(0.32), 2, 13, 5)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 11
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 10)
	panel.add_child(row)

	var vpill := PanelContainer.new()
	vpill.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var vps := _styled(REF_INSET, REF_INSET.lightened(0.08), 1, 11)
	vps.content_margin_left = 3
	vps.content_margin_right = 3
	vps.content_margin_top = 10
	vps.content_margin_bottom = 10
	vpill.add_theme_stylebox_override("panel", vps)
	vpill.add_child(_vertical_label("BOAT STATUS", 15, CYAN))
	row.add_child(vpill)

	var cols := HBoxContainer.new()
	cols.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cols.add_theme_constant_override("separation", 7)
	row.add_child(cols)

	var col_nodes: Array[Control] = []
	for i in range(3):
		var c := VBoxContainer.new()
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		c.add_theme_constant_override("separation", 9)
		cols.add_child(c)
		col_nodes.append(c)
	ui["boat_status_cols"] = col_nodes


# A vertically-stacked label (reads bottom-to-top), recentered whenever its box resizes.
func _vertical_label(text: String, font_size: int, color: Color) -> Control:
	var box := Control.new()
	box.custom_minimum_size = Vector2(font_size + 8, 0)
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.clip_contents = true
	var lbl := _label(text, font_size, color, HORIZONTAL_ALIGNMENT_CENTER)
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lbl.rotation = deg_to_rad(-90.0)
	box.add_child(lbl)
	var reposition := func() -> void:
		if not is_instance_valid(lbl):
			return
		var ts := lbl.get_minimum_size()
		lbl.size = ts
		lbl.pivot_offset = Vector2.ZERO
		# After a -90° turn the label runs upward; place its origin so it centers in the box.
		lbl.position = Vector2(box.size.x * 0.5 - ts.y * 0.5, box.size.y * 0.5 + ts.x * 0.5)
	box.resized.connect(reposition)
	reposition.call()
	return box


# Make interactive children transparent to drags so a finger-drag that STARTS on a button
# or card still scrolls the rail (taps still fire, gated by the ScrollContainer's deadzone).
func _make_rail_scrollable(node: Node) -> void:
	for child in node.get_children():
		if child is Control:
			var c := child as Control
			if c.mouse_filter == Control.MOUSE_FILTER_STOP:
				c.mouse_filter = Control.MOUSE_FILTER_PASS
			_make_rail_scrollable(c)


const WEATHER_DAY_CARD_WIDTH := 86
const WEATHER_DAY_CARD_GAP := 8

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
	links.add_child(_title_link("RULES", _show_rules_modal))
	links.add_child(_title_link_sep())
	links.add_child(_title_link("HIGH SCORES", _show_high_scores_screen))
	links.add_child(_title_link_sep())
	links.add_child(_title_link("SETTINGS", _show_settings_screen))
	links.add_child(_title_link_sep())
	links.add_child(_title_link("CREDITS", _show_credits_screen))
	links.add_child(_title_link_sep())
	# The mute toggle previously lived only in dead code — this is its live home.
	var mute_link := _title_link("MUTE", _toggle_audio_mute)
	links.add_child(mute_link)
	ui["mute_button"] = mute_link

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
		# has_meta first: get_meta with a null default still raises a console error.
		if g.has_meta("intro_tween"):
			var old: Tween = g.get_meta("intro_tween") as Tween
			if old:
				old.kill()
		g.position.y = float(e["base_y"])
		g.scale = Vector2(0.04, 0.04)
		g.rotation_degrees = base_rot + dir * randf_range(30.0, 60.0)
		g.modulate = Color(1, 1, 1, 0)
		var t := g.create_tween()
		g.set_meta("intro_tween", t)
		t.tween_interval(float(i) * 0.08)
		# Every letter hits with its own slam, stepping up in pitch (40ms
		# throttle: the 80ms stagger must never be swallowed by the default).
		t.tween_callback(_play_sfx.bind("title_slam", -2.0, 1.0 + 0.03 * float(i), 40))
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
	b.button_down.connect(_play_button_sfx.bind(b))
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
	if _has_useful_action():
		_show_confirm_overlay("END YOUR DAY?", "You can still move, fish, or cast from here. Are you sure you want to end your day?", "END DAY", _end_day)
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
	backdrop.color = Color(0.01, 0.04, 0.12, 0.78)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(backdrop)

	# Chunky navy panel with a gold "market" trim; fish sit on it as cards.
	var card := _panel_lifted(REF_BG_NAVY, GOLD_DEEP, 3, 18, 16)
	card.anchor_left = 0.5
	card.anchor_right = 0.5
	card.anchor_top = 0.5
	card.anchor_bottom = 0.5
	card.offset_left = -380
	card.offset_right = 380
	card.offset_top = -348
	card.offset_bottom = 348
	overlay.add_child(card)

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 26)
	pad.add_theme_constant_override("margin_right", 26)
	pad.add_theme_constant_override("margin_top", 22)
	pad.add_theme_constant_override("margin_bottom", 22)
	card.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 14)
	pad.add_child(col)

	# Title row: coin icon + chunky gold heading.
	var title_row := HBoxContainer.new()
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	title_row.add_theme_constant_override("separation", 12)
	title_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title_row)
	title_row.add_child(_icon_texture_rect(ICON_FUNDS_TEXTURE, Vector2(38, 38), GOLD))
	ui["sell_title"] = _label("SELL YOUR CATCH", FONT_TITLE, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_title"].add_theme_constant_override("outline_size", 3)
	ui["sell_title"].add_theme_color_override("font_outline_color", Color("#3a2a00"))
	title_row.add_child(ui["sell_title"])

	# Big haggle-outcome banner (hidden until a haggle resolves) — solid accent
	# slab, no stroke; _show_haggle_outcome restyles it per result.
	var outcome := PanelContainer.new()
	outcome.visible = false
	outcome.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outcome.add_theme_stylebox_override("panel", _styled(CYAN, Color(0, 0, 0, 0), 0, 14))
	col.add_child(outcome)
	ui["sell_outcome"] = outcome
	var outcome_col := VBoxContainer.new()
	outcome_col.add_theme_constant_override("separation", 2)
	outcome_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	outcome.add_child(outcome_col)
	ui["sell_outcome_label"] = _label("", FONT_TITLE + 4, CYAN, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_outcome_label"].add_theme_constant_override("outline_size", 3)
	ui["sell_outcome_label"].add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	ui["sell_outcome_label"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outcome_col.add_child(ui["sell_outcome_label"])
	ui["sell_outcome_sub"] = _label("", FONT_BODY, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_outcome_sub"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outcome_col.add_child(ui["sell_outcome_sub"])

	# Min height leaves room for the haggle-outcome banner; the expand flag
	# grows the scroll to fill the panel whenever the banner is hidden.
	var sell_scroll := ScrollContainer.new()
	sell_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sell_scroll.custom_minimum_size = Vector2(0, 316)
	sell_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sell_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(sell_scroll)

	# Fish sit on the felt as REAL portrait cards (the catch-fan cards), wrapping
	# into rows like a dealt hand.
	var sell_flow := HFlowContainer.new()
	sell_flow.alignment = FlowContainer.ALIGNMENT_CENTER
	sell_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sell_flow.add_theme_constant_override("h_separation", 20)
	sell_flow.add_theme_constant_override("v_separation", 16)
	ui["sell_rows"] = sell_flow
	sell_scroll.add_child(sell_flow)

	# Summary pill (solid chunky gold, no stroke) — logic sets the label's text.
	var total_pill := PanelContainer.new()
	total_pill.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var tps := _styled(GOLD, Color(0, 0, 0, 0), 0, 12)
	tps.content_margin_left = 22
	tps.content_margin_right = 22
	tps.content_margin_top = 8
	tps.content_margin_bottom = 8
	total_pill.add_theme_stylebox_override("panel", tps)
	col.add_child(total_pill)
	ui["sell_total"] = _label("", FONT_CELL_BIG, Color("#3a2a00"), HORIZONTAL_ALIGNMENT_CENTER)
	total_pill.add_child(ui["sell_total"])

	ui["sell_result"] = _label("", FONT_SMALL, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	ui["sell_result"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["sell_result"])

	ui["sell_action_row"] = HBoxContainer.new()
	ui["sell_action_row"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_action_row"].add_theme_constant_override("separation", 12)
	col.add_child(ui["sell_action_row"])

	ui["sell_confirm"] = _flat_button("SELL", 0, 64, GREEN_DEEP, TEXT_PRIMARY, 24, 16)
	ui["sell_confirm"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_confirm"].pressed.connect(_confirm_sale)
	ui["sell_action_row"].add_child(ui["sell_confirm"])

	ui["sell_haggle"] = _flat_button("HAGGLE", 0, 64, GOLD, Color("#3a2a00"), 24, 16)
	ui["sell_haggle"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_haggle"].pressed.connect(_haggle_sale)
	ui["sell_action_row"].add_child(ui["sell_haggle"])

	ui["sell_cancel"] = _flat_button("CANCEL", 0, 64, BG_PANEL_LIGHT, TEXT_MUTED, 24, 16)
	ui["sell_cancel"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["sell_cancel"].pressed.connect(_close_sell_modal)
	ui["sell_action_row"].add_child(ui["sell_cancel"])

	ui["sell_ok"] = _flat_button("OK", 0, 64, GREEN_DEEP, TEXT_PRIMARY, 24, 16)
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
	# Above the title screen (z 200) — this modal opens from the title links.
	overlay.z_index = 510
	add_child(overlay)
	ui["rules_overlay"] = overlay

	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.72)
	backdrop.anchor_right = 1.0
	backdrop.anchor_bottom = 1.0
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(backdrop)

	var card := _panel_lifted(BG_PANEL_DARK, GOLD_DEEP, 0, 16, 12)
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

	var close_btn := _flat_button("CLOSE", 0, 56, GOLD, Color("#3a2a00"), 24, 16)
	close_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close_btn.pressed.connect(_hide_rules_modal)
	col.add_child(close_btn)


func _show_rules_modal() -> void:
	if ui.has("rules_overlay"):
		var ov := ui["rules_overlay"] as Control
		ov.move_to_front()  # tree-order input picking: last sibling wins
		ov.visible = true
		_play_sfx("modal_open")


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
		+ "Each evening a weather card is drawn: Calm, Rain, Squall, or Hurricane. Calm nights pass safely. Rain boosts your "
		+ "catch, Squall and Hurricane cut it. Any weather with strength rolls a d6: if your roll is below the strength, you "
		+ "take damage equal to the difference to random systems. Docked boats are safe. Tap a forecast card to see its effect.\n\n"
		+ "[b]COMBAT (PIRATE BATTLE)[/b]\n"
		+ "When both boats are at sea and within 2 squares of each other, the captain with Cannons can ATTACK. Damage rolls "
		+ "against the rival's hull and systems; Defense reduces the hit. Sinking your rival ends the contest.\n\n"
		+ "[b]TROPHIES[/b]\n"
		+ "Selling 10 or more of one species in a single dock visit locks in that trophy. Trophies persist for the rest of the "
		+ "game. The first captain to collect all five wins outright. If the season ends first, highest trophy count wins; "
		+ "ties broken by money.\n\n"
		+ "[b]SEASON END[/b]\n"
		+ "After day 14 (plus any Paid Nights), unsold fish at sea spoil. Your SEASON SCORE is banked cash "
		+ "plus $300 a trophy, $40 an upgrade card, and $2 a fish sold — the highest score tops the leaderboard.\n\n"
		+ "[b]CONTROLS[/b]\n"
		+ "Tap adjacent water to move. Tap your own cell to FIND or CAST via the action bar. From a dock-access square tap "
		+ "the dock strip to enter. END DAY when you've used your moves or want to skip the rest.\n\n"
		+ "[b]TIPS[/b]\n"
		+ "  • Deep water is worth the risk only if your hull and live well can handle a setback.\n"
		+ "  • Sell often — spoiled fish are a wasted catch.\n"
		+ "  • In Pirate Battle, watch the rival's distance; Cannons are useless once they dock.\n"
		+ "  • Save a few casts for a known fish hole before END DAY in case weather damage strands you tomorrow.\n")


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
		dock_row.add_child(_dock_parking_zone(right_cells))

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
	_play_sfx("card_slide")
	# The dock is the dealer: cards ripple outward from THE DOCKS, nearest
	# squares first, each order slot getting a small shuffle nudge.
	var deck_from_global := Vector2.ZERO
	var has_deck := ui.has("dock_strip") and is_instance_valid(ui["dock_strip"])
	if has_deck:
		deck_from_global = (ui["dock_strip"] as Control).get_global_rect().get_center()
	var order: Array[int] = []
	var deal_score: Dictionary = {}
	for i in range(cell_buttons.size()):
		var c: Vector2i = cell_buttons[i].get_meta("cell_pos", Vector2i.ZERO)
		var from_dock := Vector2(float(c.x - DOCK_COL), float(GRID_ROWS - c.y) * 1.15).length()
		deal_score[i] = from_dock + randf_range(-0.8, 0.8)
		order.append(i)
	order.sort_custom(func(a: int, b: int) -> bool:
		return float(deal_score[a]) < float(deal_score[b])
	)
	var per_card := 0.028
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
		# Fly out of the dealer's spot (the dock) when layout gives us a rect;
		# fall back to the old local up-left toss otherwise.
		var start := home + Vector2(-64.0 + randf_range(-22.0, 22.0), -52.0 + randf_range(-16.0, 16.0))
		var slot: Control = (btn.get_meta("board_slot") as Control) if btn.has_meta("board_slot") else null
		if has_deck and slot != null and is_instance_valid(slot):
			start = deck_from_global - slot.get_global_rect().position - Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT) * 0.5
			start += Vector2(randf_range(-18.0, 18.0), randf_range(-10.0, 10.0))
		btn.position = start
		btn.scale = Vector2(0.46, 0.46)
		btn.rotation_degrees = tilt - randf_range(14.0, 26.0)
		if shell:
			shell.z_index = 15 + rank
			shell.modulate = btn.modulate
			shell.position = btn.position
			shell.scale = btn.scale
			shell.rotation_degrees = btn.rotation_degrees

		# Longer throws get a touch more air time so far corners still arc.
		var flight := clampf(0.26 + btn.position.length() / 2400.0, 0.26, 0.44)

		# The interval MUST be its own sequential step. set_parallel(true) right after
		# tween_interval() would run the props in parallel WITH the interval — ignoring the
		# stagger (that was the "all cards at once" bug). Use parallel() per-tweener instead.
		var tween := btn.create_tween()
		btn.set_meta("board_card_tween", tween)
		tween.tween_interval(float(rank) * per_card)
		if rank % 6 == 0:
			# A soft ascending riffle as the hand sweeps out.
			tween.tween_callback(_play_sfx.bind("card_slide", -8.0, 1.0 + 0.008 * float(rank), 35))
		tween.tween_property(btn, "modulate:a", 1.0, 0.12)
		tween.parallel().tween_property(btn, "position", home, flight).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(btn, "scale", Vector2.ONE, flight).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(btn, "rotation_degrees", tilt, flight).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		if shell:
			tween.parallel().tween_property(shell, "modulate:a", 1.0, 0.12)
			tween.parallel().tween_property(shell, "position", home, flight).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(shell, "scale", Vector2.ONE, flight).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(shell, "rotation_degrees", tilt, flight).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
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
	var slot: Control = (btn.get_meta("board_slot") as Control) if btn.has_meta("board_slot") else null
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
		var wm := _card_shell_metrics(card_size)
		var wi := float(int(wm["border"]))
		var wash := ColorRect.new()
		wash.color = _with_alpha(Color("#020914"), 0.22)
		wash.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wash.position = Vector2(wi, wi)
		wash.size = card_size - Vector2(wi, wi) * 2.0
		shell.add_child(wash)


# Board-cell/dock variant of the unified shell (colorable border, no outline
# stroke — cells sit edge to edge and read cleaner without it). The legacy
# border/step params are ignored: metrics come from the card size.
func _draw_squarestep_card(parent: Control, card_size: Vector2, fill: Color, border_color: Color, _border_px: int, _steps: int, _step_px: int, metrics_ref: Vector2 = Vector2.ZERO) -> void:
	var m := _card_shell_metrics(metrics_ref if metrics_ref != Vector2.ZERO else card_size)
	var b := float(m["border"])
	var s := float(m["step"])
	# Use the caller's raw size — anything seated at these metrics derives
	# from the same floats, so edges always agree (no floor drift).
	var w := card_size.x
	var h := card_size.y
	var shell := Control.new()
	shell.size = card_size
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var outer_steps := int(m["steps"])
	var inner_steps := int(m["inner_steps"])
	shell.draw.connect(func() -> void:
		_draw_stepped_slab(shell, 0.0, 0.0, w, h, s, border_color, outer_steps)
		_draw_stepped_slab(shell, b, b, w - 2.0 * b, h - 2.0 * b, s, fill, inner_steps))
	parent.add_child(shell)


# A dashed-outline parking placeholder spanning `width_cells` cells of the dock row.
# Always empty now — the player's ship sits inside THE DOCKS square instead.
func _dock_parking_zone(width_cells: int) -> Control:
	var zone := Control.new()
	var w := BOARD_CELL_WIDTH * width_cells + BOARD_CARD_GAP * (width_cells - 1)
	zone.custom_minimum_size = Vector2(w, BOARD_CELL_HEIGHT)
	zone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	zone.draw.connect(_draw_parking_zone.bind(zone))
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

	# The player's ship sits docked in the right half of the square (shown only when docked).
	var boat := TextureRect.new()
	boat.texture = ICON_CARD_SHIP_TEXTURE
	boat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boat.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	boat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boat.visible = false
	boat.modulate = _with_alpha(TEXT_PRIMARY, 0.96)
	boat.z_index = 12
	boat.anchor_left = 0.5
	boat.anchor_right = 1.0
	boat.anchor_top = 0.0
	boat.anchor_bottom = 1.0
	boat.offset_left = 2.0
	boat.offset_right = -10.0
	boat.offset_top = 10.0
	boat.offset_bottom = -10.0
	dock_btn.add_child(boat)
	ui["dock_boat"] = boat


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
	# Reference cell metrics so the dock's border matches its neighbours 1:1.
	_draw_squarestep_card(shell, size, fill, Color.WHITE, 4, 2, 2, Vector2(BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT))


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

	# Fullscreen background video (revealed by the comic-cut entrance on catch fans).
	var video := VideoStreamPlayer.new()
	video.stream = CATCH_WAVES_VIDEO
	video.expand = true
	video.loop = true
	video.autoplay = false
	video.mouse_filter = Control.MOUSE_FILTER_IGNORE
	video.visible = false
	_anchor_fill(video)
	overlay.add_child(video)
	ui["catch_video"] = video

	var shade := ColorRect.new()
	shade.color = _with_alpha(Color("#020b15"), 0.68)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(shade)
	overlay.add_child(shade)
	ui["catch_card_shade"] = shade

	var layer := Control.new()
	layer.anchor_right = 1.0
	layer.anchor_bottom = 1.0
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(layer)
	ui["catch_card_layer"] = layer

	# Comic-cut shutters: two dark panels meeting on a diagonal seam that the "strike"
	# splits open to reveal the video. Built inside a rotated Node2D frame whose local
	# x-axis is the seam, so the two covers just slide along local ±y to open.
	var slash := Node2D.new()
	slash.visible = false
	overlay.add_child(slash)
	ui["catch_slash"] = slash

	var big := 2400.0
	var cover_col := Color("#04101c")
	var cover_a := ColorRect.new()
	cover_a.color = cover_col
	cover_a.size = Vector2(big * 2.0, big)
	cover_a.position = Vector2(-big, -big)
	cover_a.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slash.add_child(cover_a)
	ui["catch_slash_a"] = cover_a

	var cover_b := ColorRect.new()
	cover_b.color = cover_col
	cover_b.size = Vector2(big * 2.0, big)
	cover_b.position = Vector2(-big, 0.0)
	cover_b.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slash.add_child(cover_b)
	ui["catch_slash_b"] = cover_b

	var line := ColorRect.new()
	line.color = Color(0.88, 0.96, 1.0, 1.0)
	line.size = Vector2(big * 2.0, 7.0)
	line.position = Vector2(-big, -3.5)
	line.pivot_offset = Vector2(0.0, 3.5)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	slash.add_child(line)
	ui["catch_slash_line"] = line

	var flash := ColorRect.new()
	flash.color = Color(1, 1, 1, 1)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash.modulate = Color(1, 1, 1, 0)
	flash.visible = false
	_anchor_fill(flash)
	overlay.add_child(flash)
	ui["catch_flash"] = flash


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

	# CAST / FIND FISH / SELL FISH / END DAY now live as the left-rail counter buttons.
	action_buttons["attack"]  = _action_button("ATTACK",      "attack",  _attack)
	action_buttons["upgrade"] = _action_button("UPGRADE",     "upgrade", _open_upgrade_tray)
	action_buttons["repair"]  = _action_button("REPAIR",      "repair",  _open_repair_tray)

	row.add_child(action_buttons["attack"])
	row.add_child(action_buttons["upgrade"])
	row.add_child(action_buttons["repair"])


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

	# Header is just the funds readout + a corner X — no title / hint copy.
	var head := HBoxContainer.new()
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_theme_constant_override("separation", 12)
	col.add_child(head)

	var head_spacer := Control.new()
	head_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(head_spacer)

	# Color-filled funds readout — keyed "tray_money" so _pill_set_text still drives it.
	ui["tray_money"] = _funds_pill("$0")
	ui["tray_money"].size_flags_horizontal = Control.SIZE_SHRINK_END
	ui["tray_money"].size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(ui["tray_money"])

	var close_x := _tactile_button("X", 56, 56, BG_PANEL_LIGHT, BORDER_HI, TEXT_PRIMARY)
	close_x.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	close_x.pressed.connect(_close_tray)
	head.add_child(close_x)

	# Body host: each mode (upgrade / repair) supplies its own layout and scrolling.
	ui["tray_body"] = VBoxContainer.new()
	ui["tray_body"].add_theme_constant_override("separation", 6)
	ui["tray_body"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["tray_body"].size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(ui["tray_body"])

	_build_tray_body_upgrade()
	_build_tray_body_repair()
	_show_tray_body("upgrade", false)
	_show_tray_body("repair", false)
	_build_upgrade_card_preview_overlay(overlay)


func _build_tray_body_upgrade() -> void:
	# Two columns: a narrow Extra Night buy panel on the left, the upgrade lanes
	# filling (and scrolling within) the whole right side.
	var body := HBoxContainer.new()
	body.name = "UpgradeBody"
	body.add_theme_constant_override("separation", 14)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ui["tray_body"].add_child(body)
	ui["tray_body_upgrade"] = body

	body.add_child(_build_extra_night_column())

	var right_scroll := ScrollContainer.new()
	right_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	right_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_scroll.clip_contents = true
	body.add_child(right_scroll)

	var lanes := VBoxContainer.new()
	lanes.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lanes.add_theme_constant_override("separation", 12)
	right_scroll.add_child(lanes)

	for key in UPGRADE_KEYS:
		var lane := _upgrade_store_lane(key)
		lanes.add_child(lane)
		upgrade_store_lanes[key] = lane


# Narrow left column of the upgrade shop: buy one extra night at sea, instant purchase.
func _build_extra_night_column() -> Control:
	# No stroke — a lighter shade of navy defines the area against the tray body.
	var panel := _panel_lifted(BG_PANEL_LIGHT, BG_PANEL_LIGHT, 0, 10, 5)
	panel.custom_minimum_size = Vector2(284, 0)
	panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var pad := MarginContainer.new()
	pad.add_theme_constant_override("margin_left", 22)
	pad.add_theme_constant_override("margin_right", 22)
	pad.add_theme_constant_override("margin_top", 22)
	pad.add_theme_constant_override("margin_bottom", 22)
	panel.add_child(pad)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 16)
	pad.add_child(col)

	col.add_child(_label("EXTRA NIGHT", 28, GOLD, HORIZONTAL_ALIGNMENT_CENTER))

	# Current season progress lives here in the days column.
	ui["shop_day_count"] = _label("DAY 1 / 14", 22, CYAN, HORIZONTAL_ALIGNMENT_CENTER)
	ui["shop_day_count"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["shop_day_count"])

	var icon := _icon_texture_rect(ICON_DAY_TEXTURE, Vector2(84, 84), GOLD)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(icon)

	var blurb := _label("Buy one more day at sea. Extends the season the moment you buy.", 17, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	blurb.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	blurb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(blurb)

	ui["extra_night_owned"] = _label("", 17, CYAN, HORIZONTAL_ALIGNMENT_CENTER)
	ui["extra_night_owned"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(ui["extra_night_owned"])

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(spacer)

	ui["extra_night_buy"] = _tactile_button("BUY  $%d" % EXTRA_NIGHT_COST, 0, 72, GOLD_DEEP, GOLD, Color("#241a02"))
	ui["extra_night_buy"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["extra_night_buy"].pressed.connect(_buy_extra_night)
	col.add_child(ui["extra_night_buy"])

	return panel


func _build_tray_body_repair() -> void:
	var body := VBoxContainer.new()
	body.name = "RepairBody"
	body.add_theme_constant_override("separation", 12)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ui["tray_body"].add_child(body)
	ui["tray_body_repair"] = body

	for key in CONDITION_KEYS:
		var row := _segment_row(_condition_name(key), CONDITION_MAX, false, key, true, true)
		body.add_child(row)
		repair_tray_rows[key] = row


# Chunky, color-filled funds readout for the shop header.
func _funds_pill(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	# Solid gold fill, no stroke.
	var s := _styled_shadow(GOLD_DEEP.lerp(GOLD, 0.32), GOLD_DEEP.lerp(GOLD, 0.32), 0, 9, 5)
	s.shadow_color = Color(0, 0, 0, 0.4)
	s.shadow_offset = Vector2(0, 3)
	s.content_margin_top = 8
	s.content_margin_bottom = 10
	s.content_margin_left = 18
	s.content_margin_right = 20
	p.add_theme_stylebox_override("panel", s)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 9)
	p.add_child(row)

	var icon := _icon_texture_rect(ICON_FUNDS_TEXTURE, Vector2(30, 30), Color("#3a2c05"))
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(icon)

	var l := _label(text, 30, Color("#241a02"), HORIZONTAL_ALIGNMENT_CENTER)
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(l)

	p.set_meta("label", l)
	return p


# Solid accent chip used on the card-preview overlay, e.g. "+1 MOTOR".
func _preview_chip(text: String, accent: Color) -> PanelContainer:
	var p := PanelContainer.new()
	var s := _styled_shadow(accent.darkened(0.06), accent.lightened(0.32), 2, 8, 4)
	s.shadow_color = Color(0, 0, 0, 0.4)
	s.shadow_offset = Vector2(0, 3)
	s.content_margin_top = 7
	s.content_margin_bottom = 9
	s.content_margin_left = 22
	s.content_margin_right = 22
	p.add_theme_stylebox_override("panel", s)
	var l := _label(text, 27, Color("#10131a"), HORIZONTAL_ALIGNMENT_CENTER)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_child(l)
	p.set_meta("label", l)
	return p


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

	# Card and its details sit side by side. The details column hides on purchase so the
	# card reveal animation plays alone.
	var stage := HBoxContainer.new()
	stage.anchor_left = 0.5
	stage.anchor_right = 0.5
	stage.anchor_top = 0.5
	stage.anchor_bottom = 0.5
	stage.offset_left = -410
	stage.offset_right = 410
	stage.offset_top = -300
	stage.offset_bottom = 300
	stage.alignment = BoxContainer.ALIGNMENT_CENTER
	stage.add_theme_constant_override("separation", 40)
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(stage)
	ui["upgrade_card_preview_stage"] = stage

	# Left column: the card and its "+1 …" chip, both kept through the reveal.
	var left := VBoxContainer.new()
	left.alignment = BoxContainer.ALIGNMENT_CENTER
	left.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	left.add_theme_constant_override("separation", 18)
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(left)

	var card_slot := Control.new()
	card_slot.custom_minimum_size = Vector2(316, 412)
	card_slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card_slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	card_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left.add_child(card_slot)
	ui["upgrade_card_preview_slot"] = card_slot

	ui["upgrade_card_preview_chip"] = _preview_chip("+1 MOTOR", GOLD)
	ui["upgrade_card_preview_chip"].size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	left.add_child(ui["upgrade_card_preview_chip"])

	# Right column: description + price + buttons. All hidden on Buy.
	var info := VBoxContainer.new()
	info.custom_minimum_size = Vector2(372, 0)
	info.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 16)
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(info)
	ui["upgrade_card_preview_info"] = info

	ui["upgrade_card_preview_level"] = _label("CARD 1 / 5", FONT_BODY, GOLD)
	ui["upgrade_card_preview_level"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(ui["upgrade_card_preview_level"])

	ui["upgrade_card_preview_desc"] = _label("", 22, TEXT_PRIMARY)
	ui["upgrade_card_preview_desc"].autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ui["upgrade_card_preview_desc"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(ui["upgrade_card_preview_desc"])

	ui["upgrade_card_preview_effect"] = _label("", 18, CYAN)
	ui["upgrade_card_preview_effect"].autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ui["upgrade_card_preview_effect"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(ui["upgrade_card_preview_effect"])

	ui["upgrade_card_preview_price"] = _label("$0", 38, GOLD)
	ui["upgrade_card_preview_price"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(ui["upgrade_card_preview_price"])

	ui["upgrade_card_preview_buy"] = _tactile_button("UPGRADE", 0, 64, PURPLE_DEEP, PURPLE, TEXT_PRIMARY)
	ui["upgrade_card_preview_buy"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_card_preview_buy"].pressed.connect(_purchase_selected_upgrade)
	info.add_child(ui["upgrade_card_preview_buy"])

	ui["upgrade_card_preview_close"] = _tactile_button("CLOSE", 0, 52, BG_PANEL_LIGHT, BORDER_HI, TEXT_PRIMARY)
	ui["upgrade_card_preview_close"].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui["upgrade_card_preview_close"].pressed.connect(_close_upgrade_card_preview)
	info.add_child(ui["upgrade_card_preview_close"])


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
	lane.custom_minimum_size = Vector2(0, 146)
	lane.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lane.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	lane.pressed.connect(_open_upgrade_card_preview.bind(key))

	var pad := MarginContainer.new()
	_anchor_fill(pad)
	pad.add_theme_constant_override("margin_left", 20)
	pad.add_theme_constant_override("margin_right", 20)
	pad.add_theme_constant_override("margin_top", 14)
	pad.add_theme_constant_override("margin_bottom", 14)
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lane.add_child(pad)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 22)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pad.add_child(row)

	# Count sits on the inside-left.
	var count := _label("0/%d" % UPGRADE_MAX_LEVEL, 32, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	count.custom_minimum_size = Vector2(74, 0)
	count.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	count.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(count)

	var copy := VBoxContainer.new()
	copy.custom_minimum_size = Vector2(190, 0)
	copy.size_flags_vertical = Control.SIZE_EXPAND_FILL
	copy.alignment = BoxContainer.ALIGNMENT_CENTER
	copy.add_theme_constant_override("separation", 5)
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(copy)

	var title := _label(_upgrade_name(key).to_upper(), 26, TEXT_PRIMARY)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(title)

	var desc := _label(_row_description(key, true), 16, TEXT_MUTED)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.custom_minimum_size = Vector2(182, 0)
	desc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(desc)

	var cost := _label("", 16, GOLD)
	cost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(cost)

	# Cards live on the right side of the lane.
	var slots := HBoxContainer.new()
	slots.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slots.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slots.alignment = BoxContainer.ALIGNMENT_END
	slots.add_theme_constant_override("separation", 10)
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
	if ui.has("upgrade_card_preview_stage"):
		var st: Control = ui["upgrade_card_preview_stage"]
		st.scale = Vector2.ONE
		st.modulate = Color(1, 1, 1, 1)
	if ui.has("upgrade_card_preview_overlay"):
		(ui["upgrade_card_preview_overlay"] as Control).visible = true
	_refresh_upgrade_card_preview()
	_rebuild_upgrade_preview_cards()
	_play_catch_plonk(0)


func _close_upgrade_card_preview() -> void:
	_hide_card_tooltip()
	_kill_upgrade_reveal_tween()
	selected_upgrade_card_key = ""
	selected_upgrade_card_level = 0
	upgrade_card_purchase_locked = false
	if ui.has("upgrade_card_preview_overlay"):
		(ui["upgrade_card_preview_overlay"] as Control).visible = false


# The flip-reveal tween is bound to `self` (so it survives freeing the back
# mid-flip). Kill it before we free the slot's cards on rebuild/close so it can
# never animate a freed node.
func _kill_upgrade_reveal_tween() -> void:
	var tw = ui.get("upgrade_reveal_tween", null)
	if tw is Tween and tw.is_valid():
		tw.kill()
	ui["upgrade_reveal_tween"] = null


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

	var chip: PanelContainer = ui["upgrade_card_preview_chip"]
	(chip.get_meta("label") as Label).text = "MAXED" if maxed else "+1 %s" % _upgrade_name(key).to_upper()
	chip.visible = true

	# Details panel (description of what the card does) starts visible; hidden on buy.
	if ui.has("upgrade_card_preview_info"):
		(ui["upgrade_card_preview_info"] as Control).visible = true
	if ui.has("upgrade_card_preview_level"):
		(ui["upgrade_card_preview_level"] as Label).text = "CARD %d / %d" % [level, UPGRADE_MAX_LEVEL]
	if ui.has("upgrade_card_preview_desc"):
		(ui["upgrade_card_preview_desc"] as Label).text = _upgrade_name(key).to_upper() + " — " + _row_description(key, true)
	if ui.has("upgrade_card_preview_effect"):
		var eff: Label = ui["upgrade_card_preview_effect"]
		eff.text = "Now: %s" % _upgrade_effect_text(key, level)
		eff.visible = not maxed

	var price: Label = ui["upgrade_card_preview_price"]
	price.text = "MAXED" if maxed else "$%d" % cost
	price.add_theme_color_override("font_color", GOLD if can_buy or maxed else RED)
	price.visible = true

	var buy: Button = ui["upgrade_card_preview_buy"]
	buy.visible = not maxed
	buy.text = "UPGRADE"
	buy.disabled = not can_buy
	var buy_text := TEXT_PRIMARY if can_buy else TEXT_DIM
	buy.add_theme_color_override("font_color", buy_text)
	buy.add_theme_color_override("font_hover_color", buy_text)
	buy.add_theme_color_override("font_pressed_color", buy_text)
	buy.add_theme_color_override("font_disabled_color", buy_text)
	_apply_tactile_style(buy, PURPLE_DEEP if can_buy else BG_PANEL, PURPLE if can_buy else BORDER_DARK)

	if ui.has("upgrade_card_preview_close"):
		(ui["upgrade_card_preview_close"] as Button).visible = true


func _rebuild_upgrade_preview_cards() -> void:
	if selected_upgrade_card_key == "" or not ui.has("upgrade_card_preview_slot"):
		return
	var slot: Control = ui["upgrade_card_preview_slot"]
	_kill_upgrade_reveal_tween()
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

	# A card you're about to buy stays face-DOWN until you pay; an already-owned
	# (maxed) card you're just viewing shows its face right away.
	var current := int(upgrades.get(key, 0))
	var reveal := current >= UPGRADE_MAX_LEVEL
	var front := _build_store_card_visual(key, level, reveal, card_size, options)
	front.position = pos
	front.pivot_offset = card_size * 0.5
	front.scale = Vector2(0.58, 0.58)
	front.rotation = deg_to_rad(-8.0)
	front.modulate = Color(1, 1, 1, 0)
	front.set_meta("is_face_up", reveal)
	slot.add_child(front)
	ui["upgrade_card_preview_front"] = front

	var t := front.create_tween()
	t.set_parallel(true)
	t.tween_property(front, "scale", Vector2.ONE, 0.26).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(front, "rotation", 0.0, 0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(front, "modulate:a", 1.0, 0.14)


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

	# The card image is already shown; the reveal is a celebratory pop + fanfare.
	var front: Control = ui.get("upgrade_card_preview_front", null)
	if front == null or not is_instance_valid(front):
		_finish_upgrade_card_purchase(level, cost)
		return

	if bool(front.get_meta("is_face_up", true)):
		_pop_upgrade_card(front, level, cost)
	else:
		_reveal_upgrade_card(front, key, level, cost)


# Celebratory pop for a card that is already face-up.
func _pop_upgrade_card(front: Control, level: int, cost: int) -> void:
	_play_sfx("card_flip")
	_play_catch_plonk(1)
	front.pivot_offset = front.size * 0.5
	var pop := front.create_tween()
	pop.tween_property(front, "scale", Vector2(1.12, 1.12), 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pop.tween_callback(_play_catch_plonk.bind(3))
	pop.tween_property(front, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	pop.tween_callback(_finish_upgrade_card_purchase.bind(level, cost))


# Flip a face-down card to reveal the real art, then pop. The tween is bound to
# `self` (not the card) so it survives freeing the back mid-flip.
func _reveal_upgrade_card(back: Control, key: String, level: int, cost: int) -> void:
	var slot: Control = ui["upgrade_card_preview_slot"]
	var card_size := _store_preview_card_size()
	var options := {
		"show_shadow": true,
		"shadow_offset": Vector2(12, 16),
		"card_border_px": 8,
		"card_step_px": 4,
	}
	var front := _build_store_card_visual(key, level, true, card_size, options)
	front.position = back.position
	front.pivot_offset = card_size * 0.5
	front.scale = Vector2(0.0, 1.0)  # start edge-on (invisible)
	front.set_meta("is_face_up", true)
	slot.add_child(front)
	back.pivot_offset = back.size * 0.5

	_play_sfx("card_flip")
	var t := create_tween()
	ui["upgrade_reveal_tween"] = t
	t.tween_property(back, "scale:x", 0.0, 0.13).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.tween_callback(func() -> void:
		if is_instance_valid(back):
			back.queue_free()
		ui["upgrade_card_preview_front"] = front)
	t.tween_callback(_play_catch_plonk.bind(3))
	t.tween_property(front, "scale:x", 1.0, 0.13).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(front, "scale", Vector2(1.12, 1.12), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(front, "scale", Vector2.ONE, 0.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_callback(_finish_upgrade_card_purchase.bind(level, cost))


func _finish_upgrade_card_purchase(_level: int, _cost: int) -> void:
	upgrade_card_purchase_locked = false
	var key := selected_upgrade_card_key
	_refresh_upgrade_store_lanes()

	# Reveal: drop the whole details column (description, price, buttons) and leave only
	# the card art + "+1 …" chip, then animate the stage away and close.
	if ui.has("upgrade_card_preview_info"):
		(ui["upgrade_card_preview_info"] as Control).visible = false
	if ui.has("upgrade_card_preview_chip") and key != "":
		var chip: PanelContainer = ui["upgrade_card_preview_chip"]
		(chip.get_meta("label") as Label).text = "+1 %s" % _upgrade_name(key).to_upper()
		chip.visible = true

	_show_upgrade_purchase_fanfare(_upgrade_accent(key))
	if audio_catch:
		audio_catch.stop()
		audio_catch.play()

	var stage: Control = ui.get("upgrade_card_preview_stage", null)
	if stage != null and is_instance_valid(stage):
		stage.pivot_offset = stage.size * 0.5
		var t := stage.create_tween()
		t.tween_interval(0.72)
		t.tween_property(stage, "scale", Vector2(0.84, 0.84), 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		t.parallel().tween_property(stage, "modulate:a", 0.0, 0.22)
		t.tween_callback(func() -> void:
			if is_instance_valid(stage):
				stage.scale = Vector2.ONE
				stage.modulate = Color(1, 1, 1, 1)
			_close_upgrade_card_preview())
	else:
		_close_upgrade_card_preview()

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

	var mini := bool(options.get("mini", false))
	# Mini cards (shop lanes) always use the generated face with the small icon art.
	# Big cards (preview) use the full-resolution card image when one exists.
	var full_tex: Texture2D = null if mini else _upgrade_card_texture(key, level)
	var small_icon: Texture2D = _upgrade_small_icon_texture(key, level) if mini else null
	var fill := Color("#011244")
	if small_icon != null:
		# Match the small icon's own navy background so the icon blends into the card.
		fill = Color("#010f44")
	elif face_up and full_tex == null:
		fill = _upgrade_accent(key).darkened(0.64)
	var inner := _add_squarestep_card_shell(card, card_size, fill, options)
	var inner_size := Vector2(card_size.x - inner * 2.0, card_size.y - inner * 2.0)
	if face_up:
		if full_tex != null:
			var smm := _card_shell_metrics(card_size)
			var face := _gallery_face(full_tex, float(smm["step"]), int(smm["inner_steps"]))
			face.position = Vector2(inner, inner)
			face.size = inner_size
			card.add_child(face)
		else:
			_add_generated_upgrade_card_face(card, key, level, Rect2(Vector2(inner, inner), inner_size), options)
	else:
		var bmm := _card_shell_metrics(card_size)
		var back := _gallery_face(CARD_BACK_TEXTURE, float(bmm["step"]), int(bmm["inner_steps"]))
		back.position = Vector2(inner, inner)
		back.size = inner_size
		card.add_child(back)
	return card


# ─── Unified card shell ───
# ONE renderer for every generated card: dark pixel outline, chunky white
# border at a fixed PROPORTION of the card's width, stepped pixel corners,
# and the art seated EXACTLY against the border — no fill ring, ever.
# Metrics are integers derived from the card size, so an 84px fish card and
# a 372px weather card carry identical proportions with zero seams.

func _card_shell_metrics(card_size: Vector2) -> Dictionary:
	# Keyed on the shorter side so wide strips (the dock) stay in proportion.
	var b := maxi(3, roundi(minf(card_size.x, card_size.y) * 0.055))  # white border
	var o := maxi(1, roundi(float(b) * 0.35))      # dark outline stroke
	var s := maxi(2, roundi(float(b) * 0.37))      # corner step unit
	# Outer edge rounds over 3 chunks; the border's inner edge over 2, so the
	# white frame follows one continuous radius on BOTH sides.
	return {"outline": o, "border": b, "step": s, "inset": o + b, "steps": 3, "inner_steps": 2}


# One filled slab with a stepped-corner silhouette (two corner rows of `s`,
# square below). All edges land on the same computed values — no seams.
func _draw_stepped_slab(ci: Control, x: float, y: float, w: float, h: float, s: float, color: Color, steps: int = 3) -> void:
	for i in range(steps):
		var inset := float(steps - i) * s
		ci.draw_rect(Rect2(x + inset, y + float(i) * s, w - 2.0 * inset, s), color)
		ci.draw_rect(Rect2(x + inset, y + h - float(i + 1) * s, w - 2.0 * inset, s), color)
	ci.draw_rect(Rect2(x, y + float(steps) * s, w, h - 2.0 * float(steps) * s), color)


# Draws the shell into ONE canvas item and returns the art inset: callers
# place their face at (inset, inset) sized (card - 2*inset) and it meets the
# white border exactly. Legacy border/step options are ignored (proportional).
func _add_squarestep_card_shell(card: Control, card_size: Vector2, fill: Color, options: Dictionary = {}) -> float:
	if bool(options.get("show_shadow", true)):
		_add_halftone_card_shadow(card, card_size, options)
	var m := _card_shell_metrics(card_size)
	var o := float(m["outline"])
	var s := float(m["step"])
	var t := float(m["inset"])
	# Use the caller's raw size — anything seated at these metrics derives
	# from the same floats, so edges always agree (no floor drift).
	var w := card_size.x
	var h := card_size.y
	var shell := Control.new()
	shell.size = card_size
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var outer_steps := int(m["steps"])
	var inner_steps := int(m["inner_steps"])
	shell.draw.connect(func() -> void:
		_draw_stepped_slab(shell, 0.0, 0.0, w, h, s, Color("#0a0e14"), outer_steps)
		_draw_stepped_slab(shell, o, o, w - 2.0 * o, h - 2.0 * o, s, Color("#ffffff"), outer_steps)
		_draw_stepped_slab(shell, t, t, w - 2.0 * t, h - 2.0 * t, s, fill, inner_steps))
	card.add_child(shell)
	return t


func _add_generated_upgrade_card_face(card: Control, key: String, level: int, rect: Rect2, options: Dictionary = {}) -> void:
	var accent := _upgrade_accent(key)
	var mini := bool(options.get("mini", false))

	# Mini shop-lane cards show just the icon — no header bar, label, or level.
	if mini:
		var mini_icon: Texture2D = _upgrade_small_icon_texture(key, level)
		if mini_icon != null:
			var s := rect.size.x * 0.88
			var icon := _icon_texture_rect(mini_icon, Vector2(s, s), Color(1, 1, 1, 1))
			icon.position = rect.position + (rect.size - Vector2(s, s)) * 0.5
			icon.size = Vector2(s, s)
			icon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
			card.add_child(icon)
		else:
			var gs := rect.size.x * 0.62
			var gicon := _icon_texture_rect(_upgrade_icon_texture(key), Vector2(gs, gs), accent.lightened(0.36))
			gicon.position = rect.position + (rect.size - Vector2(gs, gs)) * 0.5
			gicon.size = Vector2(gs, gs)
			gicon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			card.add_child(gicon)
		return

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

	# Prefer the per-level small icon art (full colour) on mini cards; fall back to the
	# generic tinted material icon for upgrades without bespoke art (cannons, defense).
	var small_icon: Texture2D = _upgrade_small_icon_texture(key, level) if mini else null
	if small_icon != null:
		var s := rect.size.x * 0.82
		var icon := _icon_texture_rect(small_icon, Vector2(s, s), Color(1, 1, 1, 1))
		icon.position = rect.position + Vector2((rect.size.x - s) * 0.5, rect.size.y * 0.24)
		icon.size = Vector2(s, s)
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
		card.add_child(icon)
	else:
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


# Full-resolution card art for the big, zoomed-up card in the preview overlay.
func _upgrade_card_texture(key: String, level: int) -> Texture2D:
	var idx := clampi(level, 1, UPGRADE_MAX_LEVEL) - 1
	match key:
		"motor":
			return CARD_MOTOR_TEXTURES[idx]
		"fish_finder":
			return CARD_FISH_FINDER_TEXTURES[idx]
		"nets":
			return CARD_NETS_TEXTURES[idx]
		"live_well":
			return CARD_WELL_TEXTURES[idx]
	return null


# Small per-level icon art for the mini cards in the shop lanes (low-res collection view).
func _upgrade_small_icon_texture(key: String, level: int) -> Texture2D:
	var idx := clampi(level, 1, UPGRADE_MAX_LEVEL) - 1
	match key:
		"motor":
			return ICON_MOTOR_SMALL[idx]
		"fish_finder":
			return ICON_FINDER_SMALL[idx]
		"nets":
			return ICON_NETS_SMALL[idx]
		"live_well":
			return ICON_WELL_SMALL[idx]
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

func _segment_row(title: String, total_segments: int, is_upgrade: bool, key: String, interactive: bool, chunky: bool = false) -> Control:
	var wrap := PanelContainer.new()
	var wrap_style := _styled(BG_BODY, BORDER_DARK, 0, 0)
	wrap_style.content_margin_left = 16 if chunky else 10
	wrap_style.content_margin_right = 16 if chunky else 10
	wrap_style.content_margin_top = 16 if chunky else 12
	wrap_style.content_margin_bottom = 16 if chunky else 12
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

	var name_label := _label("%s:" % title, 27 if chunky else 21, TEXT_PRIMARY)
	title_line.add_child(name_label)

	var desc := _label(_row_description(key, is_upgrade), 18 if chunky else FONT_BODY, TEXT_MUTED)
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_line.add_child(desc)

	var percent_label := _label("", 34 if chunky else 28, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_RIGHT)
	percent_label.custom_minimum_size = Vector2(78 if chunky else 70, 0)
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
		seg_btn.custom_minimum_size = Vector2(44, 40) if chunky else Vector2(28, 24)
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

func _on_finds_counter_pressed() -> void:
	# Same counter: SELL FISH at the dock, FIND FISH at sea. Both self-guard.
	if _is_docked():
		_sell_catch()
	else:
		_find_fish()


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
	_play_sfx("modal_open")
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
	_play_sfx("modal_open")
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


# Instant purchase of one extra night at sea (no cart / checkout step).
func _buy_extra_night() -> void:
	if game_over:
		return
	if not _is_docked():
		_log("Buy extra nights at the docks.")
		return
	if money < EXTRA_NIGHT_COST:
		_log("An extra night costs $%d. You only have $%d." % [EXTRA_NIGHT_COST, money])
		return
	money -= EXTRA_NIGHT_COST
	extra_nights += 1
	_stat_add("extra_nights_bought", 1)
	_log("Bought an extra night at sea (+1 day) for $%d." % EXTRA_NIGHT_COST)
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

func _new_game(enable_versus: bool = false, skip_setup: bool = false) -> void:
	# Every new game first passes through the Boat Setup screen; Set Sail then
	# re-enters here with skip_setup = true to actually build the game.
	if not skip_setup:
		_show_boat_setup(enable_versus)
		return
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
	# The chosen boat's free starting perk — reads exactly like owning the
	# first upgrade card, but costs nothing (money stays at START_MONEY).
	# The category also stays one price step cheaper all game (see _upgrade_cost).
	var boat_perk := BOAT_PERKS[clampi(boat_choice, 0, BOAT_PERKS.size() - 1)]
	upgrades[boat_perk] = 1
	boat_perk_key = boat_perk
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
	current_weather = {"name": "Calm", "strength": 0}
	forecast.clear()
	for i in range(4):
		forecast.append(_draw_weather())
	_refresh_daily_actions()
	_close_tray()
	_hide_start_screen()
	_hide_game_over_screen()
	if captain_name != "" and boat_name != "":
		_log("Captain %s sets sail aboard %s!" % [captain_name, boat_name])
	_log("%s comes rigged with +1 %s." % [boat_name if boat_name != "" else "Your boat", _upgrade_name(boat_perk)])
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
		"boat_perk_key": boat_perk_key,
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
	boat_perk_key = str(data.get("boat_perk_key", ""))  # pre-perk saves: no discount
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
	current_weather = _dict_copy(data.get("current_weather", {"name": "Calm", "strength": 0}))
	_migrate_weather_names()
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
	market_flip.clear()
	for species in SPECIES:
		market_prices[species] = max(8, int(BASE_PRICES[species]) + rng.randi_range(-5, 8))


# Overnight the market moves: each species drifts a few dollars, banded around
# its base price. Changed species are remembered so the HUD can flip like an
# odometer when the new day renders.
func _drift_market() -> void:
	market_flip.clear()
	for species in SPECIES:
		var old_price := int(market_prices[species])
		var base := int(BASE_PRICES[species])
		var drift := rng.randi_range(-6, 7)
		var next_price := clampi(old_price + drift, maxi(8, base - 8), base + 14)
		if next_price != old_price:
			market_flip[species] = old_price
		market_prices[species] = next_price


# Odometer flap on a market price label: up-flips flash green for a rise,
# down-flips flash red for a drop, then settle back to gold.
func _odometer_flip_price(label: Label, from_v: int, to_v: int, delay: float) -> void:
	if from_v == to_v:
		return
	var up := to_v > from_v
	var accent: Color = GREEN if up else RED
	label.text = "$%d" % from_v
	var t := label.create_tween()
	t.tween_interval(delay)
	t.tween_callback(func() -> void:
		# Hinge the flap on the edge it flips away from.
		label.pivot_offset = Vector2(label.size.x * 0.5, 0.0 if up else label.size.y))
	t.tween_property(label, "scale:y", 0.0, 0.11).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.tween_callback(func() -> void:
		label.text = "$%d" % to_v
		label.add_theme_color_override("font_color", accent))
	t.tween_property(label, "scale:y", 1.0, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_interval(1.2)
	t.tween_callback(func() -> void:
		if is_instance_valid(label):
			label.add_theme_color_override("font_color", GOLD))


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


# Old saves stored weather as Clear/Storm/Hurricane; map the retired names onto
# the current set (Calm/Rain/Squall/Hurricane) so a mid-game load renders right.
func _migrate_weather_names() -> void:
	var all: Array = [current_weather]
	all.append_array(weather_deck)
	all.append_array(forecast)
	for w in all:
		if w is Dictionary:
			match str(w.get("name", "")):
				"Clear":
					w["name"] = "Calm"
				"Storm":
					w["name"] = "Rain"


func _build_weather_deck() -> void:
	weather_deck = []
	for i in range(13):
		weather_deck.append({"name": "Calm", "strength": 0})
	weather_deck.append({"name": "Rain", "strength": 3})
	weather_deck.append({"name": "Rain", "strength": 2})
	weather_deck.append({"name": "Rain", "strength": 2})
	weather_deck.append({"name": "Rain", "strength": 1})
	weather_deck.append({"name": "Squall", "strength": 4})
	weather_deck.append({"name": "Squall", "strength": 3})
	weather_deck.append({"name": "Squall", "strength": 3})
	weather_deck.append({"name": "Squall", "strength": 2})
	weather_deck.append({"name": "Hurricane", "strength": 5})
	weather_deck.append({"name": "Hurricane", "strength": 4})
	weather_deck.append({"name": "Hurricane", "strength": 3})
	weather_deck.shuffle()


func _draw_weather() -> Dictionary:
	if weather_deck.is_empty():
		_build_weather_deck()
	var w: Dictionary = weather_deck.pop_back()
	# The weather die replaced the old catch multiplier: good weather rolls a
	# BONUS die at every catch (+1/+2/+3 fish), bad weather rolls a DANGER die
	# (-0/-1/-2). Calm rolls nothing. The roll happens at catch time.
	match str(w["name"]):
		"Rain":
			w["dice"] = 1
		"Squall", "Hurricane":
			w["dice"] = -1
		_:
			w["dice"] = 0
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


# A fish-finder use only helps on water you haven't scanned or fished yet.
func _can_find_here() -> bool:
	if _is_docked() or finds_remaining <= 0:
		return false
	var tile: Dictionary = board[_cell_index(boat_pos)]
	return not bool(tile["found"]) and not bool(tile["depleted"])


# True only when the player could still spend an action to some effect this turn:
# move somewhere, scan un-found water, or cast a workable hole. Holding leftover
# casts/finds you can't actually use here (already-fished square) does not count.
func _has_useful_action() -> bool:
	if _is_docked():
		return false
	if moves_remaining > 0:
		return true
	if _can_attempt_cast_here():
		return true
	return _can_find_here()


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
		var catch_base := roll + nets_bonus
		# The weather die: rolled NOW so the game state resolves instantly; the
		# card fan then stages the reveal (base cards → 3D die → outcome).
		# Bonus die maps d6 → +1/+2/+3; danger die maps d6 → -0/-1/-2. A catch
		# never drops below one fish.
		var dice_sign := _weather_dice_sign(current_weather)
		var dice_delta := 0
		if dice_sign > 0:
			dice_delta = int(ceil(float(rng.randi_range(1, 6)) / 2.0))
		elif dice_sign < 0:
			dice_delta = -int(floor(float(rng.randi_range(1, 6) - 1) / 2.0))
		var amount: int = maxi(1, catch_base + dice_delta)
		dice_delta = amount - catch_base  # post-clamp, so the reveal matches state
		_stat_add("fish_caught", amount)
		live_well.append({"species": tile["species"], "quantity": amount, "age": 0})
		tile["casts_remaining"] = max(0, int(tile["casts_remaining"]) - 1)
		if int(tile["casts_remaining"]) <= 0:
			tile["depleted"] = true
		var bonus_text := "" if nets_bonus == 0 else " (rolled %d + nets %d)" % [roll, nets_bonus]
		if dice_sign != 0:
			bonus_text += " · %s die %+d" % [str(current_weather.get("name", "weather")), dice_delta]
		_log("Caught %d %s%s." % [amount, str(tile["species"]), bonus_text])
		_show_catch_card_fan(str(tile["species"]), amount, 1, catch_origin, dice_sign, dice_delta, catch_base)
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


# A trophy is a fifth of the win — confetti and a rising sting when one lands.
# (The words go inside the sell modal, which covers the board at that moment.)
func _celebrate_trophies(earned: Array) -> void:
	if earned.is_empty():
		return
	_play_sfx("trophy")
	_burst_confetti(false)
	for p in range(3):
		var sched := create_tween()
		sched.tween_interval(0.12 * float(p))
		sched.tween_callback(_play_catch_plonk.bind(4 + p))


func _trophy_earned_text(earned: Array) -> String:
	var names: Array[String] = []
	for s in earned:
		names.append(str(s).to_upper())
	return " + ".join(names)


func _confirm_sale() -> void:
	if live_well.is_empty():
		_close_sell_modal()
		return
	if _selected_sale_count() <= 0:
		_refresh_sell_selection_summary(0)
		return
	var result := _complete_sale(0)
	_log_sale_result(result, "")
	# The sale gets its own beat (same plumbing as the haggle reveal) instead
	# of the modal just vanishing.
	_populate_sell_rows(result["quantities"], 0)
	(ui["sell_outcome"] as Control).visible = false
	var earned: Array = result["earned_species"]
	(ui["sell_title"] as Label).text = "TROPHY EARNED!" if not earned.is_empty() else "SOLD"
	(ui["sell_total"] as Label).text = "SOLD FOR $%d" % int(result["total"])
	if earned.is_empty():
		(ui["sell_result"] as Label).text = "Market price, cash on the barrel."
	else:
		(ui["sell_result"] as Label).text = "The %s trophy is yours! Market price, cash on the barrel." % _trophy_earned_text(earned)
	(ui["sell_action_row"] as Control).visible = false
	(ui["sell_ok"] as Control).visible = true
	if audio_catch:
		audio_catch.stop()
		audio_catch.play()
	_celebrate_trophies(result["earned_species"])
	_update_ui()
	if game_over:
		_close_sell_modal()
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

	# Lock the roll in, then roll the dice across the screen; the sale is only
	# completed + revealed once the dice finishes (sale_selection stays intact).
	pending_haggle = {"roll": roll, "delta": delta_per_fish}
	var rows: Container = ui["sell_rows"]
	for child in rows.get_children():
		child.queue_free()
	(ui["sell_outcome"] as Control).visible = false
	(ui["sell_title"] as Label).text = "HAGGLING…"
	(ui["sell_total"] as Label).text = "ROLLING…"
	(ui["sell_result"] as Label).text = "The dealer shakes the dice…"
	(ui["sell_action_row"] as Control).visible = false
	(ui["sell_ok"] as Control).visible = false
	_play_dice_roll(_reveal_haggle_result)


func _reveal_haggle_result() -> void:
	if not pending_haggle.has("delta"):
		return
	var roll := int(pending_haggle["roll"])
	var delta_per_fish := int(pending_haggle["delta"])
	pending_haggle = {}

	var result := _complete_sale(delta_per_fish)
	var adjustment_text := "$0"
	if delta_per_fish > 0:
		adjustment_text = "+$%d" % delta_per_fish
	elif delta_per_fish < 0:
		adjustment_text = "-$%d" % abs(delta_per_fish)
	var haggle_text := "Roll %d: %s per fish. Auto-accepted." % [roll, adjustment_text]
	if delta_per_fish == 0:
		haggle_text = "Roll %d: market price. Auto-accepted." % roll
	if not (result["earned_species"] as Array).is_empty():
		haggle_text += "  ·  %s TROPHY EARNED!" % _trophy_earned_text(result["earned_species"])

	_populate_sell_rows(result["quantities"], delta_per_fish)
	_show_haggle_outcome(roll, delta_per_fish)
	(ui["sell_title"] as Label).text = "HAGGLE RESULT"
	(ui["sell_total"] as Label).text = "SOLD FOR $%d" % int(result["total"])
	(ui["sell_result"] as Label).text = haggle_text
	(ui["sell_action_row"] as Control).visible = false
	(ui["sell_ok"] as Control).visible = true
	_log_sale_result(result, "Haggle roll %d. " % roll)
	_celebrate_trophies(result["earned_species"])
	_update_ui()
	if game_over:
		_close_sell_modal()
		_show_game_over_screen()


# Big outcome banner + juice: confetti for a good roll, a BONK stamp for a bad one.
func _show_haggle_outcome(roll: int, delta_per_fish: int) -> void:
	var banner := ui["sell_outcome"] as PanelContainer
	var big := ui["sell_outcome_label"] as Label
	var sub := ui["sell_outcome_sub"] as Label

	var head := "FAIR PRICE"
	var sub_text := "Market rate · rolled %d" % roll
	var accent := CYAN
	if delta_per_fish > 0:
		head = "GREAT DEAL!"
		sub_text = "+$%d per fish · rolled %d" % [delta_per_fish, roll]
		accent = GREEN
	elif delta_per_fish < 0:
		head = "BONK! RIPPED OFF"
		sub_text = "-$%d per fish · rolled %d" % [abs(delta_per_fish), roll]
		accent = RED

	# Solid accent slab, no stroke — dark ink on the bright fill (chunky system).
	var style := _styled_shadow(accent, Color(0, 0, 0, 0), 0, 14, 4)
	style.shadow_color = Color(0, 0, 0, 0.35)
	style.shadow_offset = Vector2(0, 4)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 12
	banner.add_theme_stylebox_override("panel", style)
	big.text = head
	big.add_theme_color_override("font_color", Color("#10131a"))
	big.add_theme_color_override("font_outline_color", Color(1, 1, 1, 0.25))
	sub.text = sub_text
	sub.add_theme_color_override("font_color", accent.darkened(0.55))
	banner.visible = true

	banner.modulate = Color(1, 1, 1, 0)
	var t := banner.create_tween()
	t.tween_property(banner, "modulate:a", 1.0, 0.18)

	if delta_per_fish > 0:
		_burst_confetti()
	elif delta_per_fish < 0:
		_play_bonk()
	else:
		_play_sfx("haggle_avg")


# Deal the freshly-built batch cards in like a hand — only on OPEN; the
# rebuilds from toggles/steppers stay instant.
func _deal_in_sell_cards() -> void:
	if not ui.has("sell_rows"):
		return
	_play_sfx("card_slide")
	var rows: Container = ui["sell_rows"]
	var i := 0
	for unit in rows.get_children():
		if not (unit is Control):
			continue
		var u := unit as Control
		if u.is_queued_for_deletion():
			continue  # last open's cards, freed at end of frame — don't count them
		u.modulate = Color(1, 1, 1, 0)
		var t := u.create_tween()
		t.tween_interval(0.05 + 0.08 * float(i))
		t.tween_callback(_play_catch_plonk.bind(mini(i, 6)))
		t.tween_property(u, "modulate:a", 1.0, 0.16)
		var card: Control = (u.get_meta("deal_card") as Control) if u.has_meta("deal_card") else null
		if card != null and is_instance_valid(card):
			card.pivot_offset = card.custom_minimum_size * 0.5
			card.scale = Vector2(0.62, 0.62)
			t.parallel().tween_property(card, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		# Fan spread: back layers start stacked behind the front card and fan
		# out just after the unit lands.
		if u.has_meta("fan"):
			var fan := u.get_meta("fan") as Control
			for b in fan.get_children():
				if not (b is Control) or not b.has_meta("fan_k"):
					continue
				var bc := b as Control
				var k := int(bc.get_meta("fan_k"))
				bc.position = Vector2.ZERO
				bc.rotation_degrees = 0.0
				# set_delay, NOT tween_interval + set_parallel: parallel tweeners
				# join the interval's step, which would spread during the fade-in.
				var fd := 0.28 + 0.08 * float(i)
				var ft := bc.create_tween()
				ft.set_parallel(true)
				ft.tween_property(bc, "position", _sell_fan_offset(k), 0.24).set_delay(fd).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				ft.tween_property(bc, "rotation_degrees", _sell_fan_rotation(k), 0.24).set_delay(fd).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		i += 1


func _open_sell_modal() -> void:
	_reset_sale_selection()
	_populate_sell_selection_rows(0)
	_deal_in_sell_cards()
	(ui["sell_outcome"] as Control).visible = false
	(ui["sell_title"] as Label).text = "SELL YOUR CATCH"
	_refresh_sell_selection_summary(0)
	(ui["sell_result"] as Label).text = "Tap a card to sell or keep it · − / + splits a batch · sell 10 of one fish for its TROPHY."
	(ui["sell_action_row"] as Control).visible = true
	(ui["sell_ok"] as Control).visible = false
	var overlay := ui["sell_overlay"] as Control
	overlay.move_to_front()  # top-most sibling so clicks reach the modal
	overlay.visible = true
	_play_sfx("modal_open")


func _close_sell_modal() -> void:
	if ui.has("sell_overlay"):
		(ui["sell_overlay"] as Control).visible = false
	sale_selection.clear()
	pending_haggle = {}


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


# One live-well batch as a mini FAN of real portrait fish cards: the fan depth
# tracks how many are selected, a checkbox on the card's bottom edge shows the
# group's SELL state, and -/+ steppers split the batch. Tap the card to toggle.
# Updates happen in place (no rebuild) so every change can animate.
func _sell_batch_card_unit(batch_index: int, species: String, age: int, batch_quantity: int, selected: int, unit_price: int) -> Control:
	var cw := 148.0
	var ch := cw * CATCH_CARD_ASPECT
	var pad_x := 26.0
	var pad_top := 16.0
	var pad_bottom := 18.0
	var holder_w := cw + pad_x * 2.0

	var unit := VBoxContainer.new()
	unit.add_theme_constant_override("separation", 6)
	unit.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	unit.set_meta("batch_index", batch_index)
	unit.set_meta("species", species)
	unit.set_meta("batch_quantity", batch_quantity)
	unit.set_meta("unit_price", unit_price)
	unit.set_meta("card_size", Vector2(cw, ch))

	var holder := Control.new()
	holder.custom_minimum_size = Vector2(holder_w, ch + pad_top + pad_bottom)
	holder.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	unit.add_child(holder)
	unit.set_meta("deal_card", holder)

	# Fan layers live UNDER the front card; _update_sell_unit grows/shrinks them.
	var fan := Control.new()
	fan.position = Vector2(pad_x, pad_top)
	fan.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(fan)
	unit.set_meta("fan", fan)

	var card := _build_result_card(_fish_card_texture(species), Vector2(cw, ch), "$%d" % unit_price, GOLD)
	card.position = Vector2(pad_x, pad_top)
	card.pivot_offset = Vector2(cw * 0.5, ch)
	holder.add_child(card)
	unit.set_meta("front_card", card)

	# Freshness chip riding the card's top-left corner. Positive offsets only —
	# the old negative ones poked out of the holder and the scroll clipped them.
	var age_name := _age_name(age).to_upper()
	var age_accent: Color = GREEN if age <= 0 else (GOLD if age < _live_well_days() else RED)
	var fresh := PanelContainer.new()
	fresh.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fs := _styled(age_accent, age_accent.darkened(0.25), 0, 7)
	fs.content_margin_left = 8
	fs.content_margin_right = 8
	fs.content_margin_top = 1
	fs.content_margin_bottom = 2
	fresh.add_theme_stylebox_override("panel", fs)
	fresh.position = Vector2(pad_x - 10.0, 3.0)
	fresh.rotation_degrees = -3.0
	fresh.add_child(_label(age_name, 13, Color("#10131a"), HORIZONTAL_ALIGNMENT_CENTER))
	holder.add_child(fresh)
	unit.set_meta("chip", fresh)

	# Checkbox pinned to the card's bottom edge: the group's SELL state.
	var checkbox := _sell_checkbox(selected > 0)
	checkbox.position = Vector2(holder_w * 0.5 - 15.0, pad_top + ch - 16.0)
	holder.add_child(checkbox)
	unit.set_meta("checkbox", checkbox)

	var btn := Button.new()
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	_anchor_fill(btn)
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		btn.add_theme_stylebox_override(st, _transparent_style())
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.pressed.connect(_on_sell_batch_card_tapped.bind(batch_index))
	holder.add_child(btn)
	_add_press_pop(card, btn)

	# --- -/+ steppers with the split count ---
	var controls := HBoxContainer.new()
	controls.alignment = BoxContainer.ALIGNMENT_CENTER
	controls.add_theme_constant_override("separation", 6)
	controls.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	unit.add_child(controls)

	var minus := _tactile_button("-", 44, 44, BG_PANEL_LIGHT, BORDER_DARK, TEXT_PRIMARY)
	minus.add_theme_font_size_override("font_size", FONT_CELL_BIG)
	minus.pressed.connect(_adjust_sale_batch_quantity.bind(batch_index, -1))
	controls.add_child(minus)
	unit.set_meta("minus", minus)

	var count_lbl := _label("", FONT_CELL, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_CENTER)
	count_lbl.custom_minimum_size = Vector2(58, 0)
	controls.add_child(count_lbl)
	unit.set_meta("count_label", count_lbl)

	var plus := _tactile_button("+", 44, 44, BG_PANEL_LIGHT, BORDER_DARK, TEXT_PRIMARY)
	plus.add_theme_font_size_override("font_size", FONT_CELL_BIG)
	plus.pressed.connect(_adjust_sale_batch_quantity.bind(batch_index, 1))
	controls.add_child(plus)
	unit.set_meta("plus", plus)

	# --- gold subtotal ---
	var sub := _label("", FONT_CELL_BIG, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	unit.add_child(sub)
	unit.set_meta("subtotal", sub)
	return unit


# Chunky flat checkbox (custom-drawn: box + tick), state lives in a meta flag.
func _sell_checkbox(checked: bool) -> Control:
	var box := Control.new()
	box.custom_minimum_size = Vector2(30, 30)
	box.size = Vector2(30, 30)
	box.pivot_offset = Vector2(15, 15)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.set_meta("checked", checked)
	box.draw.connect(func() -> void:
		var on: bool = bool(box.get_meta("checked"))
		box.draw_rect(Rect2(0, 0, 30, 30), GREEN.darkened(0.35) if on else BORDER_FRAME)
		box.draw_rect(Rect2(3, 3, 24, 24), GREEN if on else Color("#131a26"))
		if on:
			var pts := PackedVector2Array([Vector2(8, 15), Vector2(13, 21), Vector2(22, 9)])
			box.draw_polyline(pts, Color("#0c3312"), 4.0))
	return box


# Fan geometry: layer k (1..3) behind the front card, alternating sides so the
# stack reads as a small held hand. All cards pivot at their bottom-center.
func _sell_fan_offset(k: int) -> Vector2:
	match k:
		1: return Vector2(9, 0)
		2: return Vector2(-9, 0)
		_: return Vector2(16, 0)


func _sell_fan_rotation(k: int) -> float:
	match k:
		1: return 4.0
		2: return -4.0
		_: return 7.0


func _sell_fan_back(unit: Control, k: int, animate: bool) -> Control:
	var cs: Vector2 = unit.get_meta("card_size")
	var species := str(unit.get_meta("species"))
	var b := _build_result_card(_fish_card_texture(species), cs, "", Color(0, 0, 0, 0), {"show_shadow": false})
	b.pivot_offset = Vector2(cs.x * 0.5, cs.y)
	b.set_meta("fan_k", k)
	var dimmed := _selected_sale_quantity_for_batch(int(unit.get_meta("batch_index"))) <= 0
	var tint := Color(0.6, 0.66, 0.78, 1.0) if dimmed else Color(0.74, 0.8, 0.9, 1.0)
	if animate:
		b.position = Vector2.ZERO
		b.rotation_degrees = 0.0
		b.modulate = Color(tint.r, tint.g, tint.b, 0.0)
		var t := b.create_tween()
		t.set_parallel(true)
		t.tween_property(b, "position", _sell_fan_offset(k), 0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(b, "rotation_degrees", _sell_fan_rotation(k), 0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(b, "modulate:a", 1.0, 0.16)
	else:
		b.position = _sell_fan_offset(k)
		b.rotation_degrees = _sell_fan_rotation(k)
		b.modulate = tint
	return b


# Refresh one batch unit in place: fan depth, checkbox, dim state, labels.
func _update_sell_unit(batch_index: int, animate: bool = true) -> void:
	if not ui.has("sell_units"):
		return
	var units: Dictionary = ui["sell_units"]
	if not units.has(batch_index):
		return
	var unit := units[batch_index] as Control
	if unit == null or not is_instance_valid(unit):
		return
	var selected := _selected_sale_quantity_for_batch(batch_index)
	var included := selected > 0
	var batch_quantity := int(unit.get_meta("batch_quantity"))
	var unit_price := int(unit.get_meta("unit_price"))

	# Fan depth follows the selection (an unselected group keeps its lone card).
	var fan := unit.get_meta("fan") as Control
	var want_backs := clampi(maxi(selected, 1), 1, 4) - 1
	var backs: Array[Control] = []
	for c in fan.get_children():
		# has_meta filter: a back animating OUT loses its marker immediately, so
		# a quick re-select re-grows the fan instead of counting the dying card.
		if c is Control and c.has_meta("fan_k") and not (c as Control).is_queued_for_deletion():
			backs.append(c)
	# Fan children are ordered deepest-first so nearer layers draw on top.
	while backs.size() > want_backs:
		var gone: Control = backs.pop_front()
		gone.remove_meta("fan_k")
		if animate:
			var gt := gone.create_tween()
			gt.set_parallel(true)
			gt.tween_property(gone, "position", Vector2.ZERO, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
			gt.tween_property(gone, "rotation_degrees", 0.0, 0.18)
			gt.tween_property(gone, "modulate:a", 0.0, 0.16)
			gt.chain().tween_callback(gone.queue_free)
		else:
			gone.queue_free()
	while backs.size() < want_backs:
		var k := backs.size() + 1
		var nb := _sell_fan_back(unit, k, animate)
		fan.add_child(nb)
		fan.move_child(nb, 0)  # deeper layers sit under the nearer ones
		backs.push_front(nb)
		if animate:
			_play_sfx("card_slide", -4.0)

	# Checkbox tick + pop.
	var checkbox := unit.get_meta("checkbox") as Control
	if bool(checkbox.get_meta("checked")) != included:
		checkbox.set_meta("checked", included)
		checkbox.queue_redraw()
		if animate:
			checkbox.scale = Vector2(1.35, 1.35)
			var ct := checkbox.create_tween()
			ct.tween_property(checkbox, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Kept fish sit back from the counter: dimmed and slightly small.
	var card := unit.get_meta("front_card") as Control
	var chip := unit.get_meta("chip") as Control
	var card_tint := Color(1, 1, 1, 1) if included else Color(0.6, 0.66, 0.78, 0.9)
	var card_scale := Vector2.ONE if included else Vector2(0.96, 0.96)
	# The press pop recenters the pivot and caches its own rest scale — re-seat
	# both so dim/undim always scales around the card's bottom edge and a
	# cancelled press settles back to THIS state's scale.
	var cs: Vector2 = unit.get_meta("card_size")
	card.pivot_offset = Vector2(cs.x * 0.5, cs.y)
	card.set_meta("press_pop_rest", card_scale)
	var back_tint := Color(0.74, 0.8, 0.9, 1.0) if included else Color(0.6, 0.66, 0.78, 0.9)
	var chip_tint := Color(1, 1, 1, 1) if included else Color(1, 1, 1, 0.55)
	if animate:
		var dt := card.create_tween()
		dt.set_parallel(true)
		dt.tween_property(card, "modulate", card_tint, 0.18)
		dt.tween_property(card, "scale", card_scale, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		dt.tween_property(chip, "modulate", chip_tint, 0.18)
		for b in backs:
			dt.tween_property(b, "modulate", back_tint, 0.18)
	else:
		card.modulate = card_tint
		card.scale = card_scale
		chip.modulate = chip_tint
		for b in backs:
			b.modulate = back_tint

	# Labels + stepper gating.
	(unit.get_meta("count_label") as Label).text = "%d/%d" % [selected, batch_quantity]
	(unit.get_meta("count_label") as Label).add_theme_color_override("font_color", TEXT_PRIMARY if included else TEXT_DIM)
	(unit.get_meta("minus") as Button).disabled = selected <= 0
	(unit.get_meta("plus") as Button).disabled = selected >= batch_quantity
	var sub := unit.get_meta("subtotal") as Label
	sub.text = "$%d" % (selected * unit_price)
	sub.add_theme_color_override("font_color", GOLD if included else TEXT_DIM)
	if animate:
		sub.pivot_offset = sub.size * 0.5
		sub.scale = Vector2(1.18, 1.18)
		var st := sub.create_tween()
		st.tween_property(sub, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _populate_sell_selection_rows(delta_per_fish: int) -> void:
	var rows: Container = ui["sell_rows"]
	for child in rows.get_children():
		child.queue_free()

	# Spoil-first ordering: fewest days of freshness left leads the grid.
	var days := _live_well_days()
	var order: Array = []
	for i in range(live_well.size()):
		if int(live_well[i].get("quantity", 0)) > 0:
			order.append(i)
	order.sort_custom(func(a: int, b: int) -> bool:
		var da: int = days - int(live_well[a].get("age", 0))
		var db: int = days - int(live_well[b].get("age", 0))
		if da == db:
			return a < b
		return da < db)

	var units: Dictionary = {}
	for i in order:
		var batch: Dictionary = live_well[i]
		var batch_quantity: int = max(0, int(batch.get("quantity", 0)))
		var species := str(batch.get("species", ""))
		var selected := _selected_sale_quantity_for_batch(i)
		var unit_price: int = max(0, int(market_prices[species]) + delta_per_fish)
		var unit := _sell_batch_card_unit(i, species, int(batch.get("age", 0)), batch_quantity, selected, unit_price)
		rows.add_child(unit)
		units[i] = unit
	ui["sell_units"] = units
	for i in order:
		_update_sell_unit(i, false)


func _refresh_sell_selection_summary(delta_per_fish: int) -> void:
	var quantities := _selected_sale_quantities()
	var selected_count := _selected_sale_count()
	var total := _sale_total_for(quantities, delta_per_fish)
	if selected_count <= 0:
		(ui["sell_total"] as Label).text = "SELECT FISH TO SELL"
	else:
		var text := "%d FISH  ·  $%d" % [selected_count, total]
		# Live trophy cue: this sale would claim a species' trophy as selected.
		for species in quantities.keys():
			if int(quantities[species]) >= TROPHY_REQUIRED and not bool(trophies.get(species, false)):
				text += "  ·  %s TROPHY!" % str(species).to_upper()
				break
		(ui["sell_total"] as Label).text = text
	if ui.has("sell_confirm"):
		var confirm: Button = ui["sell_confirm"]
		confirm.disabled = selected_count <= 0
	if ui.has("sell_haggle"):
		var haggle: Button = ui["sell_haggle"]
		haggle.disabled = selected_count <= 0


func _on_sell_batch_card_tapped(batch_index: int) -> void:
	if not pending_haggle.is_empty():
		return  # selection is locked once the haggle dice is rolling
	if batch_index < 0 or batch_index >= live_well.size():
		return
	var batch: Dictionary = live_well[batch_index]
	var enable := _selected_sale_quantity_for_batch(batch_index) <= 0
	sale_selection[batch_index] = max(0, int(batch.get("quantity", 0))) if enable else 0
	_play_sfx("tap" if enable else "tap_cancel")
	_update_sell_unit(batch_index)
	_refresh_sell_selection_summary(0)


func _adjust_sale_batch_quantity(batch_index: int, delta: int) -> void:
	if not pending_haggle.is_empty():
		return  # selection is locked once the haggle dice is rolling
	if batch_index < 0 or batch_index >= live_well.size():
		return
	var batch: Dictionary = live_well[batch_index]
	var batch_quantity: int = max(0, int(batch.get("quantity", 0)))
	var selected: int = _selected_sale_quantity_for_batch(batch_index)
	sale_selection[batch_index] = min(batch_quantity, max(0, selected + delta))
	_update_sell_unit(batch_index)
	_refresh_sell_selection_summary(0)


func _populate_sell_rows(quantities: Dictionary, delta_per_fish: int) -> void:
	var rows: Container = ui["sell_rows"]
	for child in rows.get_children():
		child.queue_free()

	# Sold fish as the same portrait cards, with the count on the card and the
	# money made underneath.
	for species in SPECIES:
		var quantity := int(quantities.get(species, 0))
		if quantity <= 0:
			continue

		var unit_price: int = max(0, int(market_prices[species]) + delta_per_fish)
		var subtotal := quantity * unit_price

		var unit := VBoxContainer.new()
		unit.add_theme_constant_override("separation", 6)
		unit.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		rows.add_child(unit)

		var cw := 148.0
		var holder := Control.new()
		holder.custom_minimum_size = Vector2(cw + 12.0, cw * CATCH_CARD_ASPECT + 14.0)
		holder.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		unit.add_child(holder)
		var card := _build_result_card(_fish_card_texture(species), Vector2(cw, cw * CATCH_CARD_ASPECT), "×%d" % quantity, GOLD)
		card.position = Vector2(6, 2)
		holder.add_child(card)

		unit.add_child(_label("%d × $%d each" % [quantity, unit_price], FONT_SMALL, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER))
		var sub := _label("$%d" % subtotal, FONT_CELL_BIG, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
		sub.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unit.add_child(sub)


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


func _upgrade_cost(key: String, current: int, apply_perk: bool = true) -> int:
	var effective := current
	if apply_perk and key == boat_perk_key:
		# The boat's free starter card permanently discounts its category one
		# step: level 2 sells at the level-1 price, level 3 at level-2, etc.
		effective = maxi(0, current - 1)
	var base: int = int(UPGRADE_BASE_COST[key])
	var step: int = int(UPGRADE_COST_STEP[key])
	return base + effective * step


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
		_log("Season over — Season Score %s." % _format_thousands(_season_score()))
		_update_ui()
		_show_game_over_screen()
		return

	current_weather = forecast.pop_front()
	forecast.append(_draw_weather())
	_drift_market()
	_refresh_daily_actions()
	_log("Day %d begins. The market shifts overnight." % day)
	_update_ui()
	_show_day_transition()


func _resolve_weather() -> void:
	var strength: int = int(current_weather["strength"])
	if strength <= 0:
		_log("Calm night.")
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
		var cost := _upgrade_cost(key, current, false)  # bot doesn't get the player's perk discount
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
	# Re-apply after content rebuilds so freshly-created rail cards/rows stay drag-scrollable.
	if ui.has("command_rail_col"):
		_make_rail_scrollable(ui["command_rail_col"])
	_save_game()


func _update_hud() -> void:
	_counter_set("stat_day", "%d/%d" % [day, _season_days()], true)
	# At the docks the funds counter doubles as the upgrade-store button.
	_counter_set("stat_funds", "$%d" % money, true, "UPGRADE" if _is_docked() else "FUNDS")
	if moves_remaining > 0:
		_counter_set("stat_moves", "%d" % moves_remaining, true, "MOVES")
	else:
		_counter_set("stat_moves", "GO", true, "END DAY")
	# The counter only reads SELL FISH when there's actually a catch to sell;
	# an empty well at the docks keeps the (unusable there) FIND FISH face.
	if _is_docked() and not live_well.is_empty():
		_counter_set("stat_finds", "$$$$", true, "SELL FISH")
	else:
		_counter_set("stat_finds", "%d" % finds_remaining, not _is_docked() and finds_remaining > 0, "FIND FISH")
	_counter_set("stat_casts", "%d" % casts_remaining, casts_remaining > 0)
	# Attention pulse: FIND FISH on unscanned water, CAST on a workable hole —
	# only while the action would actually do something (uses left, valid tile).
	var can_act := game_started and not game_over and active_tray == "" and not board.is_empty()
	action_blink["stat_finds"] = can_act and _can_find_here()
	action_blink["stat_casts"] = can_act and casts_remaining > 0 and _can_attempt_cast_here()
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
	if not ui.has("weather_strip"):
		return
	var strip: HBoxContainer = ui["weather_strip"]
	for child in strip.get_children():
		child.queue_free()
	strip.add_child(_weather_day_card(current_weather, 0, true))
	for i in range(min(3, forecast.size())):
		strip.add_child(_weather_day_card(forecast[i], i + 1, false))
	strip.add_child(_weather_peek_card())


func _update_top_market() -> void:
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
		var trophy := _icon_texture_rect(ICON_TROPHY_SOLID if earned else ICON_TROPHY_OUTLINE, Vector2(19, 19), GOLD if earned else Color("#5b6480"))
		trophy.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(trophy)

		var name := _label(species.to_upper(), 16, TEXT_PRIMARY if earned else TEXT_MUTED)
		name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		name.clip_text = true
		row.add_child(name)

		var price := _label("$%d" % int(market_prices[species]), 18, GOLD, HORIZONTAL_ALIGNMENT_RIGHT)
		price.custom_minimum_size = Vector2(56, 0)
		price.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(price)
		if market_flip.has(species):
			_odometer_flip_price(price, int(market_flip[species]), int(market_prices[species]), 0.9 + 0.12 * float(SPECIES.find(species)))
	market_flip.clear()


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

	# Boat in the dock → label hugs the left so the ship sits on the right; otherwise centered.
	if dock_label:
		if docked:
			dock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			dock_label.offset_left = 16.0
			dock_label.offset_right = 0.0
		else:
			dock_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			dock_label.offset_left = 0.0
			dock_label.offset_right = 0.0

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
	var at_sea_keys: Array[String] = []
	if versus_mode and not docked and not _bot_is_docked() and _distance_to_bot() <= 2:
		at_sea_keys = ["attack"]
	var at_dock_keys: Array[String] = ["upgrade", "repair"]
	var visible_keys: Array[String] = at_dock_keys if docked else at_sea_keys

	for k in action_buttons.keys():
		var b: Button = action_buttons[k]
		b.visible = visible_keys.has(k)
		b.disabled = game_over or active_tray != ""
		b.set_meta("action_prompt", false)
		b.set_meta("action_subdued", false)

	if action_buttons.has("attack") and action_buttons["attack"].visible:
		action_buttons["attack"].disabled = action_buttons["attack"].disabled or not _can_player_attack_bot()

	for k in action_buttons.keys():
		_apply_action_visual_state(action_buttons[k])

	if ui.has("live_well_sell"):
		var sell: Button = ui["live_well_sell"]
		sell.disabled = game_over or not _is_docked() or live_well.is_empty()
		_apply_action_visual_state(sell)

	if ui.has("action_heading"):
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
	_refresh_upgrade_store_lanes()
	if ui.has("shop_day_count"):
		(ui["shop_day_count"] as Label).text = "DAY %d / %d" % [day, _season_days()]
	if ui.has("extra_night_owned"):
		var owned: Label = ui["extra_night_owned"]
		owned.text = "Already added: +%d night%s" % [extra_nights, "" if extra_nights == 1 else "s"] if extra_nights > 0 else "No extra nights yet"
		owned.add_theme_color_override("font_color", CYAN if extra_nights > 0 else TEXT_DIM)
	if ui.has("extra_night_buy"):
		var buy: Button = ui["extra_night_buy"]
		buy.disabled = game_over or not _is_docked() or money < EXTRA_NIGHT_COST


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
		var row_style := _styled(BG_PANEL_DARK if age % 2 == 0 else BG_PANEL, BORDER_DARK, 0, 5)
		row_style.content_margin_left = 9
		row_style.content_margin_right = 9
		row_style.content_margin_top = 5
		row_style.content_margin_bottom = 5
		wrap.add_theme_stylebox_override("panel", row_style)
		wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(wrap)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 10)
		wrap.add_child(row)

		var age_color := TEXT_PRIMARY
		var age_tag := _age_name(age).to_upper()
		if age == cap:
			age_color = GOLD
			age_tag = "SPOILS"
		elif age >= cap - 1 and cap > 1:
			age_color = CYAN
		var age_lbl := _label(age_tag, 15, age_color)
		age_lbl.custom_minimum_size = Vector2(74, 0)
		age_lbl.clip_text = true
		row.add_child(age_lbl)

		var batch_parts: Array[String] = []
		var count_today := 0
		for batch in live_well:
			if int(batch["age"]) == age:
				batch_parts.append("%d %s" % [int(batch["quantity"]), str(batch["species"])])
				count_today += int(batch["quantity"])

		var fish_text := ", ".join(batch_parts) if not batch_parts.is_empty() else "—"
		var fish_color := TEXT_PRIMARY if not batch_parts.is_empty() else TEXT_DIM
		var fish_lbl := _label(fish_text, 15, fish_color)
		fish_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		fish_lbl.clip_text = true
		row.add_child(fish_lbl)

		var count_lbl := _label("%d" % count_today, 16, age_color if count_today > 0 else TEXT_DIM, HORIZONTAL_ALIGNMENT_RIGHT)
		count_lbl.custom_minimum_size = Vector2(30, 0)
		row.add_child(count_lbl)

	(ui["live_well_status"] as Label).text = "%d ABOARD" % total_fish if total_fish > 0 else "EMPTY"


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
			var bot_lbl := _label("%s: $%d · %d fish · %d trophies · %s" % [BOT_NAME, bot_money, _bot_total_fish(), _bot_trophy_count(), bot_place], FONT_SMALL, RED)
			bot_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			bot_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lines.add_child(bot_lbl)
			log_limit = 5
		for i in range(min(log_limit, log_lines.size())):
			var line_lbl := _label(log_lines[i], FONT_SMALL, TEXT_PRIMARY if i == 0 else TEXT_MUTED)
			line_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			line_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lines.add_child(line_lbl)


const BOAT_METER_BLUE := Color("#00bafc")
const BOAT_STATUS_UP_LABELS := {"motor": "MOTOR", "fish_finder": "FINDS", "nets": "NETS", "live_well": "WELL", "cannons": "GUNS", "defense": "DEFS"}
const BOAT_STATUS_COND_LABELS := {"hull": "HULL", "propeller": "PROP", "rudder": "RUDDER", "nets": "NETS"}

func _update_compact_ship_cards() -> void:
	if not ui.has("boat_status_cols"):
		return
	var cols: Array = ui["boat_status_cols"]
	if cols.size() < 3:
		return
	for c in cols:
		for child in (c as Control).get_children():
			child.queue_free()

	# Col 1 & 2: upgrade levels (blue meters). Col 3: hull/systems condition (green→red).
	for key in ["motor", "fish_finder", "nets", "live_well"]:
		(cols[0] as Control).add_child(_boat_status_meter(str(BOAT_STATUS_UP_LABELS[key]), int(upgrades.get(key, 0)), UPGRADE_MAX_LEVEL, 5, BOAT_METER_BLUE, ""))
	for key in ["cannons", "defense"]:
		(cols[1] as Control).add_child(_boat_status_meter(str(BOAT_STATUS_UP_LABELS[key]), int(upgrades.get(key, 0)), UPGRADE_MAX_LEVEL, 5, BOAT_METER_BLUE, ""))
	for key in CONDITION_KEYS:
		var value := int(conditions.get(key, CONDITION_MAX))
		var ratio := float(value) / float(CONDITION_MAX)
		var accent := GREEN if ratio >= 0.7 else (GOLD if ratio >= 0.4 else RED)
		(cols[2] as Control).add_child(_boat_status_meter(str(BOAT_STATUS_COND_LABELS[key]), value, CONDITION_MAX, 5, accent, key))


# A little card that doubles as a power meter: label + segmented bar. Condition cards
# (repair_key set) are tappable at the docks to repair one segment.
func _boat_status_meter(label_text: String, value: int, max_v: int, segs: int, accent: Color, repair_key: String) -> Control:
	# No card background — the label + meter sit directly on the slate panel.
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := _styled(Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0, 0)
	style.content_margin_top = 3
	style.content_margin_bottom = 3
	style.content_margin_left = 2
	style.content_margin_right = 2
	card.add_theme_stylebox_override("panel", style)

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 8)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(row)

	var lbl := _label(label_text, 20, TEXT_PRIMARY)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(lbl)

	var bar := _meter_bar(float(value), float(max_v), segs, accent)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(bar)

	if repair_key != "":
		var btn := Button.new()
		btn.flat = true
		btn.focus_mode = Control.FOCUS_NONE
		_anchor_fill(btn)
		for st in ["normal", "hover", "pressed", "focus", "disabled"]:
			btn.add_theme_stylebox_override(st, _transparent_style())
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		btn.pressed.connect(_on_status_repair_pressed.bind(repair_key))
		card.add_child(btn)
	return card


func _meter_bar(value: float, max_v: float, segs: int, accent: Color) -> Control:
	# A row of overlapping little "cards" that reads as a stacked progress/health
	# meter: lit cards are bright with a thick white border and sit in front (left),
	# unlit cards are dark navy and recede to the right.
	var card_w := 23.0
	var card_h := 36.0
	var overlap := 9.0
	var stride := card_w - overlap
	var step: float = max_v / float(segs)
	var box := Control.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.custom_minimum_size = Vector2(card_w + stride * float(segs - 1), card_h)
	# Add right-to-left so the leftmost (lit) cards draw on top of the ones behind them.
	for i in range(segs - 1, -1, -1):
		var frac := clampf((value - float(i) * step) / step, 0.0, 1.0)
		var lit := frac > 0.5
		var seg := Panel.new()
		seg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		seg.size = Vector2(card_w, card_h)
		seg.position = Vector2(stride * float(i), 0.0)
		var s: StyleBoxFlat
		if lit:
			s = _styled_shadow(accent, REF_BORDER, 3, 6, 2)
			s.shadow_offset = Vector2(2, 2)
		else:
			s = _styled(REF_BG_NAVY, Color("#5a74a0"), 2, 6)
		seg.add_theme_stylebox_override("panel", s)
		box.add_child(seg)
	return box


func _on_status_repair_pressed(key: String) -> void:
	if game_over or active_tray != "":
		return
	if not _is_docked():
		_log("Repairs are done at the docks.")
		return
	if int(conditions.get(key, CONDITION_MAX)) >= CONDITION_MAX:
		return
	_repair_segment(key)


func _on_radio_pressed() -> void:
	if game_over:
		return
	var lines: Array[String] = []
	if versus_mode:
		var place := "the docks" if _bot_is_docked() else "%s water" % str(board[_cell_index(bot_pos)]["zone"])
		lines.append("%s — $%d · %d fish · %d trophies · %s." % [BOT_NAME, bot_money, _bot_total_fish(), _bot_trophy_count(), place])
		lines.append("")
	for i in range(min(8, log_lines.size())):
		lines.append(log_lines[i])
	var body := "\n".join(lines) if not lines.is_empty() else "Quiet on the radio tonight."
	_show_info_overlay("RADIO", body)


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
		"Rain", "Squall":
			return ICON_STORM_TEXTURE
		"Hurricane":
			return ICON_HURRICANE_TEXTURE
	return ICON_CLEAR_TEXTURE


# Central metadata for the four weather types (Calm / Rain / Squall / Hurricane):
# full label, short label (narrow forecast cards), accent colour, full-size card art.
func _weather_meta(weather_name: String) -> Dictionary:
	match weather_name:
		"Rain":
			return {"label": "RAIN", "short": "RAIN", "accent": GREEN, "card": CARD_WEATHER_RAIN}
		"Squall":
			return {"label": "SQUALL", "short": "SQUALL", "accent": GOLD, "card": CARD_WEATHER_SQUALL}
		"Hurricane":
			return {"label": "HURRICANE", "short": "HURR", "accent": RED, "card": CARD_WEATHER_HURRICANE}
		_:
			return {"label": "CALM", "short": "CALM", "accent": CYAN, "card": CARD_WEATHER_CALM}


# A tiny pixel-art d6 (2D, not the 3D roller) for inline use in text. Cached.
func _pixel_die_texture() -> Texture2D:
	if _pixel_die_tex != null:
		return _pixel_die_tex
	var n := 16
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var body := Color("#f4f1e6")
	var ink := Color("#161616")
	# Ivory body with pixel-rounded corners.
	img.fill_rect(Rect2i(1, 0, n - 2, n), body)
	img.fill_rect(Rect2i(0, 1, n, n - 2), body)
	# Dark 1px outline.
	for x in range(1, n - 1):
		img.set_pixel(x, 0, ink)
		img.set_pixel(x, n - 1, ink)
	for y in range(1, n - 1):
		img.set_pixel(0, y, ink)
		img.set_pixel(n - 1, y, ink)
	img.set_pixel(1, 1, ink)
	img.set_pixel(n - 2, 1, ink)
	img.set_pixel(1, n - 2, ink)
	img.set_pixel(n - 2, n - 2, ink)
	# Five pips (classic die face), 2x2 each.
	for p in [Vector2i(3, 3), Vector2i(11, 3), Vector2i(3, 11), Vector2i(11, 11), Vector2i(7, 7)]:
		img.fill_rect(Rect2i(p.x, p.y, 2, 2), ink)
	_pixel_die_tex = ImageTexture.create_from_image(img)
	return _pixel_die_tex


# BBCode effect blurb for the full-size weather card (uses tonight's strength).
# {DIE} marks where the inline pixel d6 is dropped in by _set_weather_desc.
# +1 for bonus-die weather, -1 for danger-die weather, 0 for Calm. Falls back
# to the legacy numeric "mult" for weather dicts saved before the dice change.
func _weather_dice_sign(weather: Dictionary) -> int:
	if weather.is_empty():
		return 0
	if weather.has("dice"):
		return int(weather["dice"])
	var mult := float(weather.get("mult", 1.0))
	if mult > 1.001:
		return 1
	if mult < 0.999:
		return -1
	return 0


func _weather_effect_desc(weather: Dictionary) -> String:
	var name := str(weather.get("name", "Calm"))
	var s := int(weather.get("strength", 0))
	match name:
		"Rain":
			return "Fish bite in the rain — every catch rolls a [color=#84ed72]bonus die: +1, +2 or +3 fish[/color].\nRoll a {DIE} — below [color=#fcba00]%d[/color] and rough water [color=#fc6060]damages[/color] random systems.\n[color=#5a7993]Safe at the docks.[/color]" % s
		"Squall":
			return "Choppy seas — every catch rolls a [color=#fc6060]danger die: -0, -1 or -2 fish[/color].\nRoll a {DIE} — below [color=#fcba00]%d[/color] and you take [color=#fc6060]damage[/color] to random systems.\n[color=#5a7993]Safe at the docks.[/color]" % s
		"Hurricane":
			return "The worst of the season — every catch rolls a [color=#fc6060]danger die: -0, -1 or -2 fish[/color], plus [color=#fc6060]heavy damage[/color].\nRoll a {DIE} — below [color=#fcba00]%d[/color] and it wrecks random systems.\n[color=#5a7993]Safe at the docks.[/color]" % s
		_:
			return "Flat, quiet water — a [color=#8ad2f0]safe night[/color].\nNo storm damage, and your catch pays the usual rate."


# Populate a RichTextLabel with the weather blurb, inlining the pixel die at {DIE}.
func _set_weather_desc(rt: RichTextLabel, weather: Dictionary) -> void:
	rt.clear()
	var segs := _weather_effect_desc(weather).split("{DIE}")
	for i in range(segs.size()):
		rt.append_text(segs[i])
		if i < segs.size() - 1:
			rt.add_image(_pixel_die_texture(), 26, 26)


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
		return Color("#0648a2")
	if row <= 3:
		return Color("#246cd2")
	return Color("#6696d8")


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
		"shadow_alpha": 0.34,
		"label_font_size": 36,
		"label_border": 2,
		"label_radius": 10,
	}


func _show_catch_card_fan(species: String, quantity: int, multiplier: int = 1, origin_center: Vector2 = Vector2(-1, -1), dice_sign: int = 0, dice_delta: int = 0, catch_base: int = 0) -> void:
	var label := "+%d %s" % [quantity, species]
	var opts := _bloom_fan_options()
	opts["video_entrance"] = true
	# The catch fan plays big over the video — bigger cards and a wider spread.
	opts["card_size_scale"] = 1.5
	opts["spread_viewport"] = 0.84
	opts["spread_max"] = 124.0
	opts["spread_step"] = 116.0
	opts["fan_sag"] = 20.0
	opts["arc_height"] = 96.0
	var fan_quantity := quantity
	if multiplier > 1:
		opts["mult_label"] = "X%d MULT" % multiplier
		opts["mult_accent"] = GOLD
	elif dice_sign != 0:
		# Weather die: fan the BASE catch first, then the 3D die rolls and the
		# outcome adds bonus cards or takes cards away.
		fan_quantity = catch_base
		label = "+%d %s" % [catch_base, species]
		opts["dice_sign"] = dice_sign
		opts["dice_delta"] = dice_delta
		opts["final_label"] = "+%d %s" % [quantity, species]
	_show_card_result_fan(_fish_card_texture(species), fan_quantity, label, _species_accent(species), GREEN, "", Color(0, 0, 0, 0), origin_center, opts)


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


# Comic-book "anime cut": a diagonal strike rips across, then the screen splits open
# along it in both directions to reveal the background video. Returns the time after
# which the screen is clear and the card fan should fire.
# The catch cutscene shown behind the card fan, chosen by tonight's weather:
# calm seas when Calm, a squall in Rain/Squall, big waves in a Hurricane.
func _weather_catch_video() -> VideoStream:
	match str(current_weather.get("name", "Calm")):
		"Rain", "Squall":
			return CATCH_STORM_VIDEO
		"Hurricane":
			return CATCH_WAVES_VIDEO
		_:
			return CATCH_CALM_VIDEO


func _play_catch_video_entrance(token: int) -> float:
	if not ui.has("catch_video") or not ui.has("catch_slash"):
		return 0.0
	var vp := get_viewport().get_visible_rect().size
	var video: VideoStreamPlayer = ui["catch_video"]
	video.stream = _weather_catch_video()
	video.visible = true
	video.stop()
	video.play()

	var slash: Node2D = ui["catch_slash"]
	var cover_a: ColorRect = ui["catch_slash_a"]
	var cover_b: ColorRect = ui["catch_slash_b"]
	var line: ColorRect = ui["catch_slash_line"]
	var flash: ColorRect = ui["catch_flash"]
	var big := 2400.0
	var open_dist := 1300.0

	# Cut runs from the top edge (1/3 in from the right) down to the bottom edge
	# (1/3 in from the left); the strike draws from that top-right end toward bottom-left.
	var a := Vector2(vp.x * 2.0 / 3.0, 0.0)
	var b := Vector2(vp.x / 3.0, vp.y)
	slash.position = (a + b) * 0.5
	slash.rotation = (b - a).angle()
	slash.visible = true
	cover_a.position = Vector2(-big, -big)
	cover_b.position = Vector2(-big, 0.0)
	line.scale = Vector2(0.0, 1.0)
	line.modulate = Color(1, 1, 1, 1)
	line.visible = true

	var strike := 0.16
	var hold := 0.07
	var open := 0.42

	var t := slash.create_tween()
	# Strike: the line rips across the seam, with a white impact flash.
	t.tween_property(line, "scale:x", 1.0, strike).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	t.parallel().tween_callback(func() -> void:
		if not is_instance_valid(flash):
			return
		flash.visible = true
		flash.modulate = Color(1, 1, 1, 0)
		var ft := flash.create_tween()
		ft.tween_property(flash, "modulate:a", 0.55, strike * 0.5)
		ft.tween_property(flash, "modulate:a", 0.0, strike * 0.7)
		ft.tween_callback(func() -> void:
			if is_instance_valid(flash):
				flash.visible = false))
	t.tween_interval(hold)
	# Open: the covers slide apart along the seam normal; the line fades out.
	t.tween_callback(func() -> void:
		if not is_instance_valid(cover_a):
			return
		var ot := cover_a.create_tween()
		ot.set_parallel(true)
		ot.tween_property(cover_a, "position:y", -big - open_dist, open).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		ot.tween_property(cover_b, "position:y", open_dist, open).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		ot.tween_property(line, "modulate:a", 0.0, open * 0.55))
	t.tween_interval(open)
	t.tween_callback(func() -> void:
		if token == catch_card_token and is_instance_valid(slash):
			slash.visible = false)
	return strike + hold + open


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

	# Catch fans open with the comic-cut video reveal; everything else delays by 0.
	var use_video := bool(options.get("video_entrance", false)) and ui.has("catch_video")
	var entrance_seconds := 0.0
	var shade: ColorRect = ui["catch_card_shade"]
	if use_video:
		# Lighter tint so the revealed video reads through behind the cards.
		shade.color = _with_alpha(Color("#03080f"), 0.32)
		entrance_seconds = _play_catch_video_entrance(token)
	else:
		shade.color = _with_alpha(Color("#020b15"), 0.68)
		if ui.has("catch_video"):
			var v: VideoStreamPlayer = ui["catch_video"]
			v.stop()
			v.visible = false
		if ui.has("catch_slash"):
			(ui["catch_slash"] as Node2D).visible = false
		if ui.has("catch_flash"):
			(ui["catch_flash"] as Control).visible = false

	var overlay_tween := overlay.create_tween()
	ui["catch_card_overlay_tween"] = overlay_tween
	overlay_tween.tween_property(overlay, "modulate:a", 1.0, float(options.get("overlay_fade_seconds", 0.10)))

	var viewport_size := get_viewport().get_visible_rect().size
	var card_size := _catch_card_size(viewport_size) * float(options.get("card_size_scale", 1.0))
	# The fan deals `base_count` cards, then any bonus cards arrive as a second
	# wave. A pending weather die reserves its potential bonus slots up front.
	var dice_sign: int = int(options.get("dice_sign", 0))
	var dice_delta: int = int(options.get("dice_delta", 0))
	var has_dice := dice_sign != 0
	var bonus_count: int = maxi(0, int(options.get("bonus_count", 0)))
	if has_dice:
		bonus_count = maxi(0, dice_delta)
	var base_count: int = mini(quantity, CATCH_CARD_MAX_DRAW)
	var card_count: int = mini(quantity + bonus_count, CATCH_CARD_MAX_DRAW)
	var actual_bonus: int = card_count - base_count
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
	var bonus_gap := float(options.get("bonus_gap", 0.6))
	var bonus_stagger := float(options.get("bonus_stagger", 0.42))
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
		var is_bonus := m >= base_count
		var count_at := draw_seconds + float(options.get("unit_pop_pause", 0.14))
		if card_count > 1:
			var pop_accent: Color = options.get("bonus_accent", GOLD) if is_bonus else unit_accent
			_attach_card_unit_pop(cards[m], pop_accent, count_at, options)
		if bool(options.get("plonk", true)):
			var pidx := m
			var plonk_sched := layer.create_tween()
			plonk_sched.tween_interval(count_at)
			plonk_sched.tween_callback(func():
				if token != catch_card_token:
					return
				_play_sfx("card_slide", -4.0, 1.0 + 0.03 * float(pidx))
				if is_bonus:
					# Bonus cards land with their own brighter cue.
					_play_catch_plonk(5)
					if audio_catch and m == base_count:
						audio_catch.stop()
						audio_catch.play()
				else:
					_play_catch_plonk(pidx)
			)

	# Drive the cascade: one card per stagger beat. Base wave first, then the bonus wave.
	var driver := layer.create_tween()
	ui["catch_card_driver_tween"] = driver
	if entrance_seconds > 0.0:
		driver.tween_interval(entrance_seconds)
	for m in range(base_count):
		if m > 0:
			driver.tween_interval(draw_stagger)
		driver.tween_callback(deal_card.bind(m))
	if actual_bonus > 0 and not has_dice:
		if base_count > 0:
			driver.tween_interval(bonus_gap)
		# A clear "bonus" callout as the extra weather cards arrive.
		var bonus_center := total_center + Vector2(0, -float(options.get("label_height", 74.0)) * 0.5 - 30.0)
		var bonus_text := str(options.get("bonus_label", "+%d EXTRA" % actual_bonus))
		var bonus_acc: Color = options.get("bonus_accent", GOLD)
		var bonus_opts := options.duplicate()
		bonus_opts["label_font_size"] = int(options.get("bonus_font_size", 34))
		bonus_opts["label_height"] = 58.0
		bonus_opts["label_width_min"] = 200.0
		bonus_opts["label_hold"] = 0.95
		bonus_opts["label_scale_peak"] = 1.18
		driver.tween_callback(func() -> void:
			if token == catch_card_token:
				_schedule_catch_total_bug(layer, bonus_text, bonus_acc, bonus_center, 0.0, token, bonus_opts)
		)
		for m in range(base_count, card_count):
			if m > base_count:
				driver.tween_interval(bonus_stagger)
			driver.tween_callback(deal_card.bind(m))

	# Stack concept: after the suspense beat, the whole pile fans open at once.
	if growth_mode == "stack" and card_count > 1:
		var spread_delay := float(options.get("spread_delay", 0.2))
		var spread_seconds := float(options.get("spread_seconds", 0.46))
		var spread_stagger := float(options.get("spread_stagger", 0.022))
		var spread_at := entrance_seconds + float(card_count - 1) * draw_stagger + draw_seconds + spread_delay
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
	var total_delay := entrance_seconds + _catch_total_appear_delay(card_count, options)
	if actual_bonus > 0:
		# The species total lands after the bonus wave has settled, not the base wave.
		total_delay = entrance_seconds + maxf(0.0, float(base_count - 1)) * draw_stagger + draw_seconds \
			+ bonus_gap + maxf(0.0, float(actual_bonus - 1)) * bonus_stagger + draw_seconds \
			+ float(options.get("total_pop_delay", CATCH_TOTAL_POP_DELAY))
	if not has_dice:
		_schedule_catch_total_bug(layer, total_label, total_accent, total_center, total_delay, token, options)
	else:
		# The weather-die beat: base cards land → the 3D die tumbles → outcome
		# pill → cards fly in (bonus) or away (danger) → the FINAL total slams.
		var base_done := entrance_seconds + maxf(0.0, float(base_count - 1)) * draw_stagger + draw_seconds
		var dice_sched := layer.create_tween()
		dice_sched.tween_interval(base_done + 0.6)
		dice_sched.tween_callback(func() -> void:
			if token != catch_card_token:
				return
			_play_dice_roll(func() -> void:
				if token != catch_card_token:
					return
				var pill_text := "WEATHER DIE  ±0"
				var pill_accent := CYAN
				if dice_delta > 0:
					pill_text = "WEATHER DIE  +%d" % dice_delta
					pill_accent = GREEN
				elif dice_delta < 0:
					pill_text = "WEATHER DIE  %d" % dice_delta
					pill_accent = RED
				var pill_center := total_center + Vector2(0, float(options.get("label_height", 74.0)) * 0.5 + 34.0)
				var pill_opts := options.duplicate()
				pill_opts["label_font_size"] = 30
				pill_opts["label_height"] = 54.0
				pill_opts["label_width_min"] = 250.0
				pill_opts["label_hold"] = 1.8
				pill_opts["label_scale_peak"] = 1.16
				_schedule_catch_total_bug(layer, pill_text, pill_accent, pill_center, 0.0, token, pill_opts)
				if dice_delta > 0:
					_play_sfx("card_flip")
				elif dice_delta < 0:
					_play_bonk()
				var settle := 0.5
				if dice_delta > 0:
					var wave := layer.create_tween()
					wave.tween_interval(0.35)
					for m in range(base_count, card_count):
						if m > base_count:
							wave.tween_interval(bonus_stagger)
						wave.tween_callback(deal_card.bind(m))
					settle = 0.35 + maxf(0.0, float(card_count - base_count - 1)) * bonus_stagger + draw_seconds + 0.2
				elif dice_delta < 0:
					var gone := mini(-dice_delta, base_count - 1)
					var out := layer.create_tween()
					out.tween_interval(0.35)
					for i in range(gone):
						out.tween_callback(_fly_out_fan_card.bind(cards, base_count - 1 - i))
						out.tween_interval(0.14)
					# Close the gap: re-fan the survivors once the losses are away.
					var keep := base_count - gone
					out.tween_callback(func() -> void:
						if token != catch_card_token or keep < 1:
							return
						var layout := _fan_layout(keep, center, card_size, viewport_size, options)
						for i in range(keep):
							_retarget_fan_card(cards, card_anims, i, layout[i], 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT, float(i) * 0.02))
					settle = 0.35 + float(gone) * 0.14 + 0.55
				var fin := layer.create_tween()
				fin.tween_interval(settle)
				fin.tween_callback(func() -> void:
					if token != catch_card_token:
						return
					_schedule_catch_total_bug(layer, str(options.get("final_label", total_label)), total_accent, total_center, 0.0, token, options))))
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

	# Optional "base + extra" breakdown pill, stacked below the mult pill.
	var extra_label := str(options.get("extra_label", ""))
	if extra_label != "":
		var extra_accent: Color = options.get("extra_accent", GREEN)
		var stacked := 1.0 if mult_label != "" else 0.0
		var extra_center := total_center + Vector2(0, float(options.get("label_height", 74.0)) * 0.5 + 34.0 + stacked * 56.0)
		var extra_opts := options.duplicate()
		extra_opts["label_font_size"] = 26
		extra_opts["label_height"] = 48.0
		extra_opts["label_width_base"] = 90.0
		extra_opts["label_width_min"] = 160.0
		extra_opts["label_scale_peak"] = 1.1
		extra_opts["label_rotation_degrees"] = -2.0
		_schedule_catch_total_bug(layer, extra_label, extra_accent, extra_center, total_delay + 0.18, token, extra_opts)

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
	var mm := _card_shell_metrics(card_size)
	var face := _gallery_face(card_texture, float(mm["step"]), int(mm["inner_steps"]))
	face.position = Vector2(m, m)
	face.size = Vector2(card_size.x - 2.0 * m, card_size.y - 2.0 * m)
	card.add_child(face)

	if badge_text != "":
		_add_card_badge(card, card_size, badge_text, badge_accent, options)
	return card


# ── Card-edge gallery ──────────────────────────────────────────────────────
# Four techniques for a lightly-rounded, pixel-square full card with an inner
# white edge that follows the rounding. Preview via ?catch_preview=cardgallery.

func _gallery_face(tex: Texture2D, notch: float = 0.0, notch_steps: int = 2) -> Control:
	if notch <= 0.0:
		var flat := TextureRect.new()
		flat.texture = tex
		flat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		flat.stretch_mode = TextureRect.STRETCH_SCALE
		# Card illustrations are high-res sources downscaled 3-20x on screen —
		# trilinear (mipmapped) sampling is what keeps them from shimmering.
		# Card imports set mipmaps/generate=true + size_limit=1024 to match.
		flat.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		flat.mouse_filter = Control.MOUSE_FILTER_IGNORE
		flat.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		flat.size_flags_vertical = Control.SIZE_EXPAND_FILL
		return flat
	# Notched: draw the art as horizontal strips whose corners step in with the
	# card border's inner radius, so the white frame rounds on BOTH edges.
	var face := Control.new()
	face.mouse_filter = Control.MOUSE_FILTER_IGNORE
	face.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	face.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	face.size_flags_vertical = Control.SIZE_EXPAND_FILL
	face.resized.connect(face.queue_redraw)
	face.draw.connect(func() -> void:
		var fw := face.size.x
		var fh := face.size.y
		if fw <= 2.0 * notch * float(notch_steps) or fh <= 2.0 * notch * float(notch_steps):
			return
		var ts := Vector2(float(tex.get_width()), float(tex.get_height()))
		var sc := Vector2(ts.x / fw, ts.y / fh)
		var strips: Array[Rect2] = []
		for i in range(notch_steps):
			var inset := float(notch_steps - i) * notch
			strips.append(Rect2(inset, float(i) * notch, fw - 2.0 * inset, notch))
			strips.append(Rect2(inset, fh - float(i + 1) * notch, fw - 2.0 * inset, notch))
		strips.append(Rect2(0.0, float(notch_steps) * notch, fw, fh - 2.0 * float(notch_steps) * notch))
		for r in strips:
			face.draw_texture_rect_region(tex, r, Rect2(r.position * sc, r.size * sc)))
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
				if ui.has("catch_video"):
					var v: VideoStreamPlayer = ui["catch_video"]
					v.stop()
					v.visible = false
				if ui.has("catch_slash"):
					(ui["catch_slash"] as Node2D).visible = false
		)
	)


func _add_halftone_card_shadow(card: Control, card_size: Vector2, options: Dictionary = {}) -> void:
	var shadow := Control.new()
	shadow.position = options.get("shadow_offset", Vector2(13, 15))
	shadow.size = card_size
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# A proper halftone screen: square pixel dots on a staggered (45-degree)
	# lattice at uniform size and alpha — tight and organized, not scattered.
	var spacing := float(options.get("shadow_spacing", 7.0))
	var dot := float(options.get("shadow_dot_size", 3.0))
	var col := _with_alpha(Color("#00152d"), float(options.get("shadow_alpha", 0.4)))
	var w := card_size.x
	var h := card_size.y
	shadow.draw.connect(func() -> void:
		var row := 0
		var y := 0.0
		while y <= h - dot:
			var x := spacing * 0.5 if row % 2 == 1 else 0.0
			while x <= w - dot:
				shadow.draw_rect(Rect2(x, y, dot, dot), col)
				x += spacing
			y += spacing * 0.5
			row += 1)
	card.add_child(shadow)


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


# A danger-die loss: the card tumbles off the bottom of the fan and fades.
func _fly_out_fan_card(cards: Array, idx: int) -> void:
	if idx < 0 or idx >= cards.size():
		return
	var card := cards[idx] as Control
	if card == null or not is_instance_valid(card):
		return
	_play_sfx("card_slide", -4.0, 0.85)
	var t := card.create_tween()
	t.set_parallel(true)
	t.tween_property(card, "position", card.position + Vector2(randf_range(-90.0, 90.0), 430.0), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(card, "rotation_degrees", card.rotation_degrees + randf_range(-55.0, 55.0), 0.5)
	t.tween_property(card, "modulate:a", 0.0, 0.42)
	t.chain().tween_callback(func() -> void:
		if is_instance_valid(card):
			card.visible = false)


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


# Long-press on a board square: pop the full-size card peek. Known squares fly
# up their real card with the details; unknown squares fly up the card back.
func _show_board_card_tooltip(pos: Vector2i) -> bool:
	if pos.x < 0 or pos.x >= GRID_COLS or pos.y < 0 or pos.y >= GRID_ROWS:
		return false
	if game_over or active_tray != "":
		return false
	var src: Control = null
	var index := _cell_index(pos)
	if index >= 0 and index < cell_buttons.size():
		src = cell_buttons[index]
	_open_board_card_preview(pos, src)
	return true


# A plain known-empty / fished-out square face: dark water, one quiet word.
func _board_preview_plain_card(word: String, cw: float, ch: float) -> Control:
	var holder := Control.new()
	holder.size = Vector2(cw, ch)
	holder.pivot_offset = Vector2(cw, ch) * 0.5
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_add_squarestep_card_shell(holder, Vector2(cw, ch), Color("#0c1a30"), {
		"show_shadow": true,
		"shadow_offset": Vector2(10, 14),
		"card_border_px": 9,
		"card_step_px": 5,
	})
	var lbl := _label(word, 30, TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	lbl.anchor_left = 0.0
	lbl.anchor_right = 1.0
	lbl.anchor_top = 0.42
	lbl.anchor_bottom = 0.42
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(lbl)
	return holder


func _open_board_card_preview(pos: Vector2i, source: Control = null) -> void:
	var tile: Dictionary = board[_cell_index(pos)]
	var known := bool(tile.get("found", false)) or bool(tile.get("revealed", false)) or bool(tile.get("depleted", false))
	var zone := str(tile.get("zone", "Open"))

	if not known:
		# The square under the boat gets "you're here" copy, not "sail here".
		var unknown_bb := "Uncharted [color=#8ad2f0]%s[/color] water.\nSail here and [color=#c889ff]FIND FISH[/color] to scan it — or spend a cast and see what bites." % zone
		if pos == boat_pos:
			unknown_bb = "You're floating on uncharted [color=#8ad2f0]%s[/color] water.\n[color=#c889ff]FIND FISH[/color] to scan it — or spend a cast and see what bites." % zone
		_open_card_preview({
			"title": "UNKNOWN",
			"accent": TEXT_MUTED,
			"front": func(cw: float, ch: float) -> Control: return _weather_preview_back_card(cw, ch),
			"fill_desc": func(rt: RichTextLabel) -> void:
				rt.clear()
				rt.append_text(unknown_bb),
		}, source)
		return

	var content := str(tile.get("content", "empty"))
	if content == "fish":
		var species := str(tile.get("species", "Fish"))
		var remaining := int(tile.get("casts_remaining", 0))
		var total := int(tile.get("casts_total", 0))
		var depleted := bool(tile.get("depleted", false))
		var price := int(market_prices.get(species, 0))
		var bb := ""
		if depleted:
			bb = "[color=#fc6060]Fished out.[/color] This hole gave everything it had."
		else:
			bb = "A [color=#8ad2f0]%s[/color] hole with [color=#84ed72]%d of %d[/color] casts left.\nThe market pays [color=#fcba00]$%d[/color] each today." % [zone, remaining, total, price]
		_open_card_preview({
			"title": species.to_upper(),
			"accent": _species_accent(species),
			"front": func(cw: float, ch: float) -> Control: return _build_result_card(_fish_card_texture(species), Vector2(cw, ch)),
			"fill_desc": func(rt: RichTextLabel) -> void:
				rt.clear()
				rt.append_text(bb),
		}, source)
		return

	if content == "treasure":
		var recovered := bool(tile.get("depleted", false))
		var is_night := _is_paid_night_treasure(tile)
		var value := int(tile.get("value", 0))
		var t_title := "PAID NIGHT" if is_night else "TREASURE"
		var t_accent: Color = CYAN if is_night else GOLD
		var t_tex: Texture2D = CARD_TREASURE_NIGHT_TEXTURE if is_night else _treasure_card_texture(value)
		# Neutral "recovered" phrasing — in versus games the bot may have taken it.
		var t_bb := ""
		if is_night:
			t_bb = "[color=#84ed72]Recovered[/color] — it stretched the season one more night." if recovered else "An extra [color=#8ad2f0]night at sea[/color] waits below — cast here to claim it."
		else:
			t_bb = "[color=#84ed72]Recovered.[/color] The chest held [color=#fcba00]$%d[/color]." % value if recovered else "A chest worth [color=#fcba00]$%d[/color] waits below — cast here to raise it." % value
		_open_card_preview({
			"title": t_title,
			"accent": t_accent,
			"front": func(cw: float, ch: float) -> Control: return _build_result_card(t_tex, Vector2(cw, ch)),
			"fill_desc": func(rt: RichTextLabel) -> void:
				rt.clear()
				rt.append_text(t_bb),
		}, source)
		return

	# Known-empty water (scanned or fished blind).
	_open_card_preview({
		"title": "EMPTY WATER",
		"accent": TEXT_MUTED,
		"front": func(cw: float, ch: float) -> Control: return _board_preview_plain_card("EMPTY", cw, ch),
		"fill_desc": func(rt: RichTextLabel) -> void:
			rt.clear()
			rt.append_text("Nothing but cold water down there. Save your casts for livelier %s." % ("water" if zone == "" else "%s water" % zone.to_lower())),
	}, source)


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
	b.button_down.connect(_play_button_sfx.bind(b))
	return b


# Flat filled button (Boat Setup style): no stroke, soft corners, big text —
# just a solid color slab with a contact shadow and a darker pressed state.
func _flat_button(text: String, min_w: int, min_h: int, fill: Color, label_color: Color, font_size: int = 30, radius: int = 16) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.add_theme_font_override("font", FONT_BALATRO)
	b.add_theme_font_size_override("font_size", font_size)
	b.add_theme_color_override("font_color", label_color)
	b.add_theme_color_override("font_hover_color", label_color)
	b.add_theme_color_override("font_pressed_color", label_color)
	b.add_theme_color_override("font_disabled_color", TEXT_DIM)
	b.custom_minimum_size = Vector2(min_w, min_h)
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var normal := _styled_shadow(fill, Color(0, 0, 0, 0), 0, radius, 4)
	normal.shadow_color = Color(0, 0, 0, 0.35)
	normal.shadow_offset = Vector2(0, 4)
	var hover := _styled_shadow(fill.lightened(0.06), Color(0, 0, 0, 0), 0, radius, 4)
	hover.shadow_color = Color(0, 0, 0, 0.35)
	hover.shadow_offset = Vector2(0, 4)
	var press := _styled(fill.darkened(0.14), Color(0, 0, 0, 0), 0, radius)
	# Deep darken so the TEXT_DIM disabled label stays readable on bright fills
	# (a 0.42 darken of GOLD is equiluminant with TEXT_DIM — invisible text).
	var disabled := _styled(fill.darkened(0.62), Color(0, 0, 0, 0), 0, radius)
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", press)
	b.add_theme_stylebox_override("disabled", disabled)
	b.add_theme_stylebox_override("focus", _transparent_style())
	_add_press_pop(b, b)
	b.button_down.connect(_play_button_sfx.bind(b))
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
func _counter_button(key: String, icon: Texture2D, title: String, accent: Color, dark: Color, on_pressed: Callable) -> Control:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(0, 96)
	card.clip_contents = false
	# Solid bright colour fill, no stroke — just a soft contact shadow for chunk.
	# `dark` (sampled from the study) is the recessed well + the label/icon ink.
	var ink := dark
	var style := _styled_shadow(accent, accent, 0, 16, 6)
	style.shadow_color = Color(0, 0, 0, 0.4)
	style.shadow_offset = Vector2(0, 4)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 13
	card.add_theme_stylebox_override("panel", style)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 8)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(col)

	var head := HBoxContainer.new()
	head.alignment = BoxContainer.ALIGNMENT_CENTER
	head.add_theme_constant_override("separation", 8)
	head.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(head)
	var ic := _icon_texture_rect(icon, Vector2(28, 28), ink)
	ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(ic)
	var title_label := _label(title, 21, ink, HORIZONTAL_ALIGNMENT_CENTER)
	title_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(title_label)

	# Recessed value "well" — a darker shade of the fill, value text in bright ink.
	var well := PanelContainer.new()
	well.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	well.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var well_style := _styled(dark, Color(0, 0, 0, 0), 0, 13)
	well_style.content_margin_top = 4
	well_style.content_margin_bottom = 6
	well_style.content_margin_left = 10
	well_style.content_margin_right = 10
	well.add_theme_stylebox_override("panel", well_style)
	col.add_child(well)
	var value_label := _label("0", 40, accent, HORIZONTAL_ALIGNMENT_CENTER)
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_label.add_theme_constant_override("outline_size", 3)
	value_label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.35))
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


# Gentle attention blink on actionable left-rail buttons (FIND FISH / CAST):
# a slow brightness pulse while the action would actually accomplish something.
func _update_action_blink() -> void:
	var pulse := 0.925 + 0.225 * sin(action_blink_time * 5.0)  # 0.7 .. 1.15
	# Don't pulse "act now" behind the weather-card popup (it blocks all input).
	var covered: bool = ui.has("weather_preview_overlay") \
		and (ui["weather_preview_overlay"] as Control).visible
	for key in action_blink.keys():
		if not ui.has(key):
			continue
		var card: Control = ui[key]
		if not is_instance_valid(card):
			continue
		if bool(action_blink[key]) and game_started and not game_over and not covered:
			card.modulate = Color(pulse, pulse, pulse, 1.0)
			card.set_meta("blinking", true)
		elif bool(card.get_meta("blinking", false)):
			card.set_meta("blinking", false)
			# Restore the lit/greyed state _counter_set manages.
			var btn := card.get_meta("button") as Button
			card.modulate = Color(1, 1, 1, 1) if (btn == null or not btn.disabled) else Color(0.5, 0.56, 0.64, 0.8)


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


# Physical "push/pop" — scale down on press, overshoot back on release. The
# target's scale at first press is its rest scale (sell KEEP cards sit at 0.96,
# not 1.0 — always restore to where the card actually lives).
func _add_press_pop(target: Control, trigger: BaseButton) -> void:
	trigger.button_down.connect(func() -> void:
		if not is_instance_valid(target):
			return
		if not target.has_meta("press_pop_rest"):
			target.set_meta("press_pop_rest", target.scale)
		var rest: Vector2 = target.get_meta("press_pop_rest")
		target.pivot_offset = target.size * 0.5
		var t := target.create_tween()
		t.tween_property(target, "scale", rest * 0.93, 0.06).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT))
	trigger.button_up.connect(func() -> void:
		if not is_instance_valid(target):
			return
		var rest: Vector2 = target.get_meta("press_pop_rest") if target.has_meta("press_pop_rest") else Vector2.ONE
		target.pivot_offset = target.size * 0.5
		var t := target.create_tween()
		t.tween_property(target, "scale", rest, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT))


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
# One calendar day-card. Neutral slate body; the only coloured element is the multiplier
# pill at the bottom (green boost / red cut / grey neutral).
func _weather_day_card(weather: Dictionary, day_offset: int, is_tonight: bool) -> Control:
	var weather_name := str(weather["name"])
	var meta := _weather_meta(weather_name)

	# Solid navy chip, thick white border, weather name up top, mult pill at the bottom.
	# No art — tapping it pops the full-size illustrated card.
	var body_fill := REF_CARD_NAVY.lightened(0.08) if is_tonight else REF_CARD_NAVY
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(WEATHER_DAY_CARD_WIDTH, 0)
	card.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var style := _styled_shadow(body_fill, REF_BORDER, 4, 12, 2)
	style.content_margin_left = 9
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	card.add_theme_stylebox_override("panel", style)
	card.clip_contents = true

	var col := VBoxContainer.new()
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 2)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(col)

	var name_label := _label(str(meta["short"]), 18, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_LEFT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.clip_text = true
	col.add_child(name_label)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(spacer)

	var chip_dice := _weather_dice_sign(weather)
	if chip_dice != 0:
		# A die icon on a green (bonus) or red (danger) pill: an upcoming roll
		# decides this weather's fate at every catch.
		var pill_accent := GREEN if chip_dice > 0 else RED
		var pill := PanelContainer.new()
		pill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		var pill_style := _styled(pill_accent, pill_accent.darkened(0.18), 0, 6)
		pill_style.content_margin_left = 7
		pill_style.content_margin_right = 7
		pill_style.content_margin_top = 2
		pill_style.content_margin_bottom = 2
		pill.add_theme_stylebox_override("panel", pill_style)
		col.add_child(pill)
		var die_icon := TextureRect.new()
		die_icon.texture = _pixel_die_texture()
		die_icon.custom_minimum_size = Vector2(15, 15)
		die_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		die_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		die_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pill.add_child(die_icon)

	var btn := Button.new()
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	_anchor_fill(btn)
	for st in ["normal", "hover", "pressed", "focus", "disabled"]:
		btn.add_theme_stylebox_override(st, _transparent_style())
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.pressed.connect(_open_weather_card_preview.bind(weather.duplicate(true), card))
	card.add_child(btn)
	return card


# --- Full-size weather card popup (tap a forecast card) -------------------

func _build_weather_card_preview_overlay() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 216
	add_child(overlay)
	ui["weather_preview_overlay"] = overlay

	var backdrop := ColorRect.new()
	backdrop.color = Color(0.01, 0.04, 0.11, 0.8)
	_anchor_fill(backdrop)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.gui_input.connect(_on_weather_preview_backdrop_input)
	overlay.add_child(backdrop)
	ui["weather_preview_backdrop"] = backdrop

	# Centered stage: illustrated card on the left, title + effect on the right.
	var stage := HBoxContainer.new()
	stage.anchor_left = 0.5
	stage.anchor_right = 0.5
	stage.anchor_top = 0.5
	stage.anchor_bottom = 0.5
	stage.offset_left = -450
	stage.offset_right = 450
	stage.offset_top = -280
	stage.offset_bottom = 280
	stage.alignment = BoxContainer.ALIGNMENT_CENTER
	stage.add_theme_constant_override("separation", 44)
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(stage)

	var card_slot := Control.new()
	var cw := 372.0
	card_slot.custom_minimum_size = Vector2(cw, cw * 1.337)
	card_slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	card_slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	card_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(card_slot)
	ui["weather_preview_slot"] = card_slot

	var info := VBoxContainer.new()
	info.custom_minimum_size = Vector2(400, 0)
	info.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	info.alignment = BoxContainer.ALIGNMENT_CENTER
	info.add_theme_constant_override("separation", 18)
	info.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(info)
	ui["weather_preview_info"] = info

	ui["weather_preview_title"] = _label("", FONT_TITLE + 10, GOLD, HORIZONTAL_ALIGNMENT_LEFT)
	ui["weather_preview_title"].add_theme_constant_override("outline_size", 3)
	ui["weather_preview_title"].add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
	info.add_child(ui["weather_preview_title"])

	var desc := RichTextLabel.new()
	desc.bbcode_enabled = true
	desc.fit_content = true
	desc.scroll_active = false
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_override("normal_font", FONT_BALATRO)
	desc.add_theme_font_override("bold_font", FONT_BALATRO)
	desc.add_theme_font_size_override("normal_font_size", FONT_CELL)
	desc.add_theme_font_size_override("bold_font_size", FONT_CELL)
	desc.add_theme_color_override("default_color", TEXT_PRIMARY)
	desc.add_theme_constant_override("line_separation", 4)
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	info.add_child(desc)
	ui["weather_preview_desc"] = desc

	var close_btn := _close_x_button()
	close_btn.anchor_left = 1.0
	close_btn.anchor_right = 1.0
	close_btn.offset_left = -92
	close_btn.offset_right = -32
	close_btn.offset_top = 30
	close_btn.offset_bottom = 90
	close_btn.pressed.connect(_close_weather_card_preview)
	overlay.add_child(close_btn)


func _on_weather_preview_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_close_weather_card_preview()


# Build a full-size weather card visual (chunky shell + illustration + mult chip)
# inside a fixed-size holder so it can travel/scale/flip as one unit.
func _weather_preview_front_card(weather: Dictionary, cw: float, ch: float) -> Control:
	var meta := _weather_meta(str(weather.get("name", "Calm")))
	var holder := Control.new()
	holder.size = Vector2(cw, ch)
	holder.pivot_offset = Vector2(cw, ch) * 0.5
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# The unified shell returns the exact art inset — face meets the border.
	var frame := _add_squarestep_card_shell(holder, Vector2(cw, ch), Color("#0a1024"), {
		"show_shadow": true,
		"shadow_offset": Vector2(10, 14),
	})
	var wmm := _card_shell_metrics(Vector2(cw, ch))
	var face := _gallery_face(meta["card"], float(wmm["step"]), int(wmm["inner_steps"]))
	face.position = Vector2(frame, frame)
	face.size = Vector2(cw - frame * 2.0, ch - frame * 2.0)
	holder.add_child(face)

	# Dice chip pinned to the card's bottom-right, when this weather rolls one.
	var chip_dice := _weather_dice_sign(weather)
	if chip_dice != 0:
		var chip_accent := GREEN if chip_dice > 0 else RED
		var chip := PanelContainer.new()
		var chip_style := _styled_shadow(chip_accent, chip_accent.darkened(0.3), 0, 10, 3)
		chip_style.content_margin_left = 15
		chip_style.content_margin_right = 15
		chip_style.content_margin_top = 5
		chip_style.content_margin_bottom = 6
		chip.add_theme_stylebox_override("panel", chip_style)
		chip.anchor_left = 1.0
		chip.anchor_top = 1.0
		chip.anchor_right = 1.0
		chip.anchor_bottom = 1.0
		chip.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		chip.grow_vertical = Control.GROW_DIRECTION_BEGIN
		chip.offset_left = -28
		chip.offset_top = -28
		chip.offset_right = -28
		chip.offset_bottom = -28
		chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.add_child(chip)
		var chip_row := HBoxContainer.new()
		chip_row.add_theme_constant_override("separation", 8)
		chip_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		chip.add_child(chip_row)
		var chip_die := TextureRect.new()
		chip_die.texture = _pixel_die_texture()
		chip_die.custom_minimum_size = Vector2(24, 24)
		chip_die.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		chip_die.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		chip_die.mouse_filter = Control.MOUSE_FILTER_IGNORE
		chip_row.add_child(chip_die)
		var chip_lbl := _label("+1·+2·+3" if chip_dice > 0 else "-0·-1·-2", FONT_CELL_BIG, Color("#10131a"), HORIZONTAL_ALIGNMENT_CENTER)
		chip_row.add_child(chip_lbl)
	return holder


# The face-down side of the weather card: same chunky shell, shared card-back art.
func _weather_preview_back_card(cw: float, ch: float) -> Control:
	var holder := Control.new()
	holder.size = Vector2(cw, ch)
	holder.pivot_offset = Vector2(cw, ch) * 0.5
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var frame := _add_squarestep_card_shell(holder, Vector2(cw, ch), Color("#0a1024"), {
		"show_shadow": true,
		"shadow_offset": Vector2(10, 14),
	})
	var kmm := _card_shell_metrics(Vector2(cw, ch))
	var back := _gallery_face(CARD_BACK_TEXTURE, float(kmm["step"]), int(kmm["inner_steps"]))
	back.position = Vector2(frame, frame)
	back.size = Vector2(cw - frame * 2.0, ch - frame * 2.0)
	holder.add_child(back)
	return holder


# Stop any in-flight open/close animation and drop its fly card.
func _kill_weather_preview_anim() -> void:
	if weather_preview_tween != null and weather_preview_tween.is_valid():
		weather_preview_tween.kill()
	weather_preview_tween = null
	if weather_preview_fly != null and is_instance_valid(weather_preview_fly):
		weather_preview_fly.queue_free()
	weather_preview_fly = null
	weather_preview_fly_front = null
	weather_preview_fly_back = null
	weather_preview_closing = false


# Weather chip tap → the generic card preview with the weather card + effect copy.
func _open_weather_card_preview(weather: Dictionary, source: Control = null) -> void:
	var w := weather.duplicate(true)
	var meta := _weather_meta(str(w.get("name", "Calm")))
	_open_card_preview({
		"title": str(meta["label"]),
		"accent": meta["accent"],
		"front": func(cw: float, ch: float) -> Control: return _weather_preview_front_card(w, cw, ch),
		"fill_desc": func(rt: RichTextLabel) -> void: _set_weather_desc(rt, w),
	}, source)


func _open_card_preview(spec: Dictionary, source: Control = null) -> void:
	if not ui.has("weather_preview_overlay"):
		return
	weather_preview_seq += 1
	var seq := weather_preview_seq
	_kill_weather_preview_anim()
	weather_preview_spec = spec
	weather_preview_source_rect = Rect2()
	weather_preview_source = source
	if source != null and is_instance_valid(source):
		weather_preview_source_rect = source.get_global_rect()

	var title: Label = ui["weather_preview_title"]
	title.text = str(spec.get("title", ""))
	title.add_theme_color_override("font_color", spec.get("accent", CYAN))
	(spec["fill_desc"] as Callable).call(ui["weather_preview_desc"] as RichTextLabel)

	# Seat the real card in the slot now (hidden) — the fly card animates on top,
	# then hands off to it so resizes keep the layout correct afterwards.
	var slot: Control = ui["weather_preview_slot"]
	for c in slot.get_children():
		c.queue_free()
	var cw := slot.custom_minimum_size.x
	var ch := slot.custom_minimum_size.y
	slot.pivot_offset = Vector2(cw, ch) * 0.5
	slot.scale = Vector2.ONE
	slot.rotation = 0.0
	slot.modulate = Color(1, 1, 1, 0)
	slot.add_child((spec["front"] as Callable).call(cw, ch))

	var overlay := ui["weather_preview_overlay"] as Control
	var backdrop := ui["weather_preview_backdrop"] as Control
	var info := ui["weather_preview_info"] as Control
	backdrop.modulate = Color(1, 1, 1, 0)
	info.modulate = Color(1, 1, 1, 0)
	overlay.move_to_front()
	overlay.visible = true
	_play_catch_plonk(0)

	# Let the (previously hidden) centered stage lay out so the slot rect is real.
	weather_preview_opening = true
	await get_tree().process_frame
	weather_preview_opening = false
	if seq != weather_preview_seq or not overlay.visible:
		return

	var dest := slot.get_global_rect()
	var dest_center := dest.position + dest.size * 0.5
	if weather_preview_source_rect.size.x <= 1.0:
		# No chip to fly from — plain center pop.
		slot.scale = Vector2(0.5, 0.5)
		slot.rotation = deg_to_rad(-6.0)
		var pt := create_tween()
		weather_preview_tween = pt
		pt.set_parallel(true)
		pt.tween_property(backdrop, "modulate:a", 1.0, 0.16)
		pt.tween_property(slot, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		pt.tween_property(slot, "rotation", 0.0, 0.26).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		pt.tween_property(slot, "modulate:a", 1.0, 0.16)
		pt.tween_property(info, "modulate:a", 1.0, 0.2).set_delay(0.1)
		return

	# Fly-up flip: the card lifts off the tapped forecast chip face-down, flips
	# to the illustration mid-flight, and lands in the slot with a little pop.
	var src_center := weather_preview_source_rect.position + weather_preview_source_rect.size * 0.5
	var start_scale := clampf(weather_preview_source_rect.size.x / cw, 0.12, 0.6)
	var fly := Control.new()
	fly.size = Vector2(cw, ch)
	fly.pivot_offset = Vector2(cw, ch) * 0.5
	fly.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(fly)
	var fly_back := _weather_preview_back_card(cw, ch)
	fly.add_child(fly_back)
	var fly_front: Control = (spec["front"] as Callable).call(cw, ch)
	fly_front.scale = Vector2(0.0, 1.0)  # edge-on until the flip
	fly.add_child(fly_front)
	fly.position = src_center - fly.pivot_offset
	fly.scale = Vector2(start_scale, start_scale)
	fly.rotation = deg_to_rad(-9.0)
	weather_preview_fly = fly
	weather_preview_fly_front = fly_front
	weather_preview_fly_back = fly_back

	_play_sfx("card_slide")
	var flip_cue := create_tween()
	flip_cue.tween_interval(0.12)
	flip_cue.tween_callback(_play_sfx.bind("card_flip"))
	var t := create_tween()
	weather_preview_tween = t
	t.set_parallel(true)
	t.tween_property(backdrop, "modulate:a", 1.0, 0.2)
	t.tween_property(fly, "position", dest_center - fly.pivot_offset, 0.44).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(fly, "scale", Vector2.ONE, 0.44).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(fly, "rotation", 0.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# The "3D" flip: collapse the back edge-on, then sweep the front open.
	t.tween_property(fly_back, "scale:x", 0.0, 0.14).set_delay(0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.tween_property(fly_front, "scale:x", 1.0, 0.16).set_delay(0.24).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_property(info, "modulate:a", 1.0, 0.18).set_delay(0.26)
	t.set_parallel(false)
	t.tween_callback(_play_catch_plonk.bind(3))
	t.tween_property(fly, "scale", Vector2(1.06, 1.06), 0.09).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(fly, "scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_callback(func() -> void:
		slot.modulate = Color(1, 1, 1, 1)
		if is_instance_valid(fly):
			fly.queue_free()
		if weather_preview_fly == fly:
			weather_preview_fly = null
			weather_preview_fly_front = null
			weather_preview_fly_back = null
			weather_preview_tween = null)


func _close_weather_card_preview() -> void:
	if not ui.has("weather_preview_overlay"):
		return
	var overlay := ui["weather_preview_overlay"] as Control
	if not overlay.visible or weather_preview_closing:
		return
	weather_preview_seq += 1  # abort any open still waiting on layout
	if weather_preview_opening:
		# The open is still waiting on layout — nothing is visible yet (backdrop
		# and slot are at alpha 0), so just hide instantly instead of animating
		# a return flight from a rect that hasn't been laid out.
		weather_preview_opening = false
		_kill_weather_preview_anim()
		overlay.visible = false
		return
	if weather_preview_tween != null and weather_preview_tween.is_valid():
		weather_preview_tween.kill()
	weather_preview_tween = null
	_play_sfx("card_slide")
	# Re-read the chip's rect — layout may have shifted since open (e.g. resize).
	if weather_preview_source != null and is_instance_valid(weather_preview_source) \
			and weather_preview_source.is_inside_tree():
		weather_preview_source_rect = weather_preview_source.get_global_rect()

	var slot: Control = ui["weather_preview_slot"]
	var backdrop := ui["weather_preview_backdrop"] as Control
	var info := ui["weather_preview_info"] as Control
	var cw := slot.custom_minimum_size.x
	var ch := slot.custom_minimum_size.y

	if weather_preview_source_rect.size.x <= 1.0:
		# No chip to shrink back into — plain fade out.
		weather_preview_closing = true
		var pt := create_tween()
		weather_preview_tween = pt
		pt.set_parallel(true)
		pt.tween_property(info, "modulate:a", 0.0, 0.12)
		pt.tween_property(slot, "modulate:a", 0.0, 0.16)
		pt.tween_property(slot, "scale", Vector2(0.7, 0.7), 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		pt.tween_property(backdrop, "modulate:a", 0.0, 0.2)
		pt.set_parallel(false)
		pt.tween_callback(func() -> void:
			overlay.visible = false
			weather_preview_closing = false
			weather_preview_tween = null)
		return

	# Shrink-back flip: reuse the in-flight fly card if the open is mid-animation,
	# otherwise lift the seated card off the slot; either way it flips face-down
	# and shrinks home into the forecast chip.
	var fly := weather_preview_fly
	var fly_front := weather_preview_fly_front
	var fly_back := weather_preview_fly_back
	var have_fly := fly != null and is_instance_valid(fly) \
		and fly_front != null and is_instance_valid(fly_front) \
		and fly_back != null and is_instance_valid(fly_back)
	if not have_fly:
		_kill_weather_preview_anim()
		fly = Control.new()
		fly.size = Vector2(cw, ch)
		fly.pivot_offset = Vector2(cw, ch) * 0.5
		fly.mouse_filter = Control.MOUSE_FILTER_IGNORE
		overlay.add_child(fly)
		fly_front = (weather_preview_spec["front"] as Callable).call(cw, ch) if weather_preview_spec.has("front") else _weather_preview_back_card(cw, ch)
		fly.add_child(fly_front)
		fly_back = _weather_preview_back_card(cw, ch)
		fly_back.scale = Vector2(0.0, 1.0)
		fly.add_child(fly_back)
		var dest := slot.get_global_rect()
		fly.position = dest.position + dest.size * 0.5 - fly.pivot_offset
		weather_preview_fly = fly
		weather_preview_fly_front = fly_front
		weather_preview_fly_back = fly_back
	slot.modulate = Color(1, 1, 1, 0)
	weather_preview_closing = true
	_play_catch_plonk(1)

	var src_center := weather_preview_source_rect.position + weather_preview_source_rect.size * 0.5
	var end_scale := clampf(weather_preview_source_rect.size.x / cw, 0.12, 0.6)
	var t := create_tween()
	weather_preview_tween = t
	t.set_parallel(true)
	t.tween_property(info, "modulate:a", 0.0, 0.14)
	t.tween_property(backdrop, "modulate:a", 0.0, 0.26).set_delay(0.12)
	t.tween_property(fly, "position", src_center - fly.pivot_offset, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t.tween_property(fly, "scale", Vector2(end_scale, end_scale), 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	t.tween_property(fly, "rotation", deg_to_rad(-7.0), 0.36).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Flip back face-down on the way home. If an interrupted open froze the flip
	# mid-way (front never opened), skip the collapse and just restore the back —
	# otherwise the card would ride home as a half-collapsed sliver.
	if fly_front.scale.x <= 0.01:
		fly_front.scale.x = 0.0
		t.tween_property(fly_back, "scale:x", 1.0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		t.tween_property(fly_front, "scale:x", 0.0, 0.13).set_delay(0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		t.tween_property(fly_back, "scale:x", 1.0, 0.13).set_delay(0.21).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.set_parallel(false)
	t.tween_callback(func() -> void:
		overlay.visible = false
		if is_instance_valid(fly):
			fly.queue_free()
		if weather_preview_fly == fly:
			weather_preview_fly = null
			weather_preview_fly_front = null
			weather_preview_fly_back = null
			weather_preview_tween = null
		weather_preview_closing = false)


# A stack of light-blue cards peeking off the edge — "more days ahead".
func _weather_peek_card() -> Control:
	var holder := Control.new()
	holder.custom_minimum_size = Vector2(WEATHER_DAY_CARD_WIDTH, 0)
	holder.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for i in range(3):
		var c := Panel.new()
		c.add_theme_stylebox_override("panel", _styled_shadow(Color("#6696d8"), REF_BORDER, 4, 12, 1))
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var off := float(2 - i) * 7.0
		c.anchor_right = 1.0
		c.anchor_bottom = 1.0
		c.offset_left = off
		c.offset_top = off
		c.offset_right = off
		c.offset_bottom = off
		holder.add_child(c)
	return holder


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
	shade.color = Color(0.008, 0.03, 0.1, 0.92)
	shade.anchor_right = 1.0
	shade.anchor_bottom = 1.0
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(shade)

	# One centered column — the whole ending fits on a single screen.
	var center := CenterContainer.new()
	_anchor_fill(center)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(center)

	var col := VBoxContainer.new()
	col.custom_minimum_size = Vector2(660, 0)
	col.add_theme_constant_override("separation", 10)
	center.add_child(col)
	ui["game_over_col"] = col


# The whole season distilled into one bragging number: every banked dollar,
# plus $300 a trophy, $40 a ship level, and $2 a fish sold.
func _season_score() -> int:
	return money + _trophy_count() * 300 + _upgrade_total(upgrades) * 40 + _total_fish_sold() * 2


func _format_thousands(n: int) -> String:
	var s := str(absi(n))
	var out := ""
	while s.length() > 3:
		out = "," + s.substr(s.length() - 3, 3) + out
		s = s.substr(0, s.length() - 3)
	out = s + out
	return ("-" + out) if n < 0 else out


# Wordle-style plaintext brag — emoji travel fine in a clipboard string.
func _share_score_text() -> String:
	var trophy_row := ""
	for species in SPECIES:
		trophy_row += "🏆" if bool(trophies.get(species, false)) else "⬜"
	var lines: Array[String] = []
	lines.append("⚓ RAIDER BAY — SEASON SCORE")
	lines.append("⭐ %s ⭐" % _format_thousands(_season_score()))
	lines.append("%s  💰 $%s  🐟 %d sold" % [trophy_row, _format_thousands(money), _total_fish_sold()])
	if captain_name != "" and boat_name != "":
		lines.append("Capt. %s · %s" % [captain_name, boat_name])
	var outcome := _game_over_outcome()
	lines.append("Day %d/%d — %s" % [mini(day, _season_days()), _season_days(), str(outcome["title"])])
	return "\n".join(lines)


func _share_score() -> void:
	var text := _share_score_text()
	DisplayServer.clipboard_set(text)
	if OS.has_feature("web"):
		# Mobile browsers get the native share sheet; the clipboard write above
		# is the universal fallback.
		JavaScriptBridge.eval("(function(){try{var t=%s;if(navigator.share){navigator.share({text:t}).catch(function(){});}else if(navigator.clipboard){navigator.clipboard.writeText(t).catch(function(){});}}catch(e){}})();" % JSON.stringify(text), true)
	if ui.has("game_over_share"):
		var btn := ui["game_over_share"] as Button
		btn.text = "COPIED!"
		# Rapid re-presses shouldn't let an older revert cut this flash short.
		if btn.has_meta("copied_tween"):
			var old = btn.get_meta("copied_tween")
			if old is Tween and (old as Tween).is_valid():
				(old as Tween).kill()
		var t := btn.create_tween()
		btn.set_meta("copied_tween", t)
		t.tween_interval(1.4)
		t.tween_callback(func() -> void:
			if is_instance_valid(btn):
				btn.text = "SHARE SCORE")
	_log("Score copied — go brag.")


# Solid bright stat chip (no stroke): small caption, big dark-ink value.
func _go_stat_chip(caption: String, value: String, fill: Color) -> Control:
	var chip := PanelContainer.new()
	var s := _styled_shadow(fill, Color(0, 0, 0, 0), 0, 14, 4)
	s.shadow_color = Color(0, 0, 0, 0.35)
	s.shadow_offset = Vector2(0, 4)
	s.content_margin_left = 18
	s.content_margin_right = 18
	s.content_margin_top = 8
	s.content_margin_bottom = 10
	chip.add_theme_stylebox_override("panel", s)
	chip.custom_minimum_size = Vector2(180, 0)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chip.add_child(v)
	v.add_child(_label(caption, 14, Color(0.05, 0.07, 0.1, 0.72), HORIZONTAL_ALIGNMENT_CENTER))
	v.add_child(_label(value, 30, Color("#10131a"), HORIZONTAL_ALIGNMENT_CENTER))
	return chip


func _show_game_over_screen() -> void:
	if not ui.has("game_over_overlay") or not ui.has("game_over_col"):
		return
	_play_sfx("modal_open")

	var col: VBoxContainer = ui["game_over_col"]
	for child in col.get_children():
		child.queue_free()

	var outcome := _game_over_outcome()
	var score_rank := _record_high_score()
	var score := _season_score()

	# Outcome — huge and bright.
	var title_lbl := _label(str(outcome["title"]), 46, outcome["title_color"], HORIZONTAL_ALIGNMENT_CENTER)
	title_lbl.add_theme_constant_override("outline_size", 4)
	title_lbl.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.65))
	title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title_lbl)

	var subtitle := _label(str(outcome["subtitle"]), 18, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
	subtitle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(subtitle)

	# The one number that matters, counting up to land with a pop.
	var score_caption := _label("SEASON SCORE", 20, _with_alpha(GOLD, 0.85), HORIZONTAL_ALIGNMENT_CENTER)
	score_caption.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(score_caption)

	var score_lbl := _label("0", 74, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	score_lbl.add_theme_constant_override("outline_size", 5)
	score_lbl.add_theme_color_override("font_outline_color", Color("#3a2a00"))
	score_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(score_lbl)
	var st := score_lbl.create_tween()
	st.tween_method(func(v: float) -> void: score_lbl.text = _format_thousands(int(round(v))), 0.0, float(score), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	st.tween_callback(func() -> void:
		score_lbl.pivot_offset = score_lbl.size * 0.5
		var pop := score_lbl.create_tween()
		pop.tween_property(score_lbl, "scale", Vector2(1.1, 1.1), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		pop.tween_property(score_lbl, "scale", Vector2.ONE, 0.12).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT))

	# How the number is built — so players know what to chase next run.
	var formula := _label("BANK $  +  $300 A TROPHY  +  $40 AN UPGRADE  +  $2 A FISH SOLD", 14, TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	formula.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(formula)

	# Losing runs (sunk / out-raced) still show their rank, but don't celebrate.
	var lost_run := str(outcome["title"]) == "SUNK!" or str(outcome["title"]) == "DEFEATED"
	if score_rank > 0 and score_rank <= 10:
		var rank_text := "NEW BEST — HIGH SCORE #1" if (score_rank == 1 and not lost_run) else "HIGH SCORE #%d" % score_rank
		var rank_lbl := _label(rank_text, 18, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
		rank_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(rank_lbl)

	# Trophy shelf — the Wordle row, in real hardware.
	var shelf := HBoxContainer.new()
	shelf.alignment = BoxContainer.ALIGNMENT_CENTER
	shelf.add_theme_constant_override("separation", 16)
	shelf.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(shelf)
	for species in SPECIES:
		var earned := bool(trophies.get(species, false))
		shelf.add_child(_icon_texture_rect(ICON_TROPHY_SOLID if earned else ICON_TROPHY_OUTLINE, Vector2(46, 46), GOLD if earned else Color("#39445e")))

	# Three bright stat chips: banked cash, fish sold, days survived.
	var chips := HBoxContainer.new()
	chips.alignment = BoxContainer.ALIGNMENT_CENTER
	chips.add_theme_constant_override("separation", 16)
	chips.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(chips)
	chips.add_child(_go_stat_chip("BANKED", "$%s" % _format_thousands(money), GOLD))
	chips.add_child(_go_stat_chip("FISH SOLD", "%d" % _total_fish_sold(), PURPLE))
	chips.add_child(_go_stat_chip("DAYS", "%d/%d" % [mini(day, _season_days()), _season_days()], CYAN))

	if captain_name != "" and boat_name != "":
		var crew := _label("Capt. %s · %s" % [captain_name, boat_name], 16, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
		crew.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(crew)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 6)
	gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(gap)

	# CTAs: share the brag, or get straight back on the water.
	var btn_row := HBoxContainer.new()
	btn_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_row.add_theme_constant_override("separation", 14)
	col.add_child(btn_row)

	var share_btn := _flat_button("SHARE SCORE", 0, 76, GOLD, Color("#3a2a00"), 28, 18)
	share_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	share_btn.pressed.connect(_share_score)
	btn_row.add_child(share_btn)
	ui["game_over_share"] = share_btn

	var again_btn := _flat_button("NEW TRIP", 0, 76, GREEN_DEEP, TEXT_PRIMARY, 28, 18)
	again_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	again_btn.pressed.connect(func() -> void:
		_hide_game_over_screen()
		_new_game(versus_mode))
	btn_row.add_child(again_btn)

	# Quiet exit back to the title screen.
	var title_link := _flat_button("BACK TO TITLE", 0, 44, Color(1, 1, 1, 0.06), TEXT_MUTED, 17, 12)
	title_link.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	title_link.custom_minimum_size = Vector2(240, 44)
	title_link.pressed.connect(func() -> void:
		_hide_game_over_screen()
		_show_start_screen())
	col.add_child(title_link)

	# A weather-card popup may still be up (e.g. opened during the bot's turn) —
	# hard-close it so it can't draw over or eat input meant for this screen.
	_kill_weather_preview_anim()
	if ui.has("weather_preview_overlay"):
		(ui["weather_preview_overlay"] as Control).visible = false

	_save_game()
	var go_overlay := ui["game_over_overlay"] as Control
	go_overlay.move_to_front()  # tree-order input picking: last sibling wins
	go_overlay.visible = true

	# A champion season or a new personal best deserves the confetti cannon —
	# but never for a run that ended at the bottom of the bay.
	if _trophy_count() >= TROPHY_WIN_COUNT or (score_rank == 1 and not lost_run):
		_burst_confetti()


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


func _record_high_score() -> int:
	if high_score_recorded:
		return last_high_score_rank

	var scores := _load_high_scores()
	var outcome := _game_over_outcome()
	var entry_id := "%d-%d" % [int(Time.get_unix_time_from_system()), rng.randi()]
	var entry := {
		"schema": 1,
		"id": entry_id,
		"score": _season_score(),
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
	# Native leaderboard (Google Play Games / Game Center) — solo runs only, and a
	# safe no-op unless the plugin + a real leaderboard ID are present (Phase 2+).
	if not versus_mode:
		Leaderboards.submit_solo_run(_trophy_count(), money)
	return last_high_score_rank


func _sort_high_scores(scores: Array) -> void:
	scores.sort_custom(_is_high_score_better)


# A recorded run's season score — stored on new entries, derived from the same
# formula for legacy entries (they carry every ingredient).
func _entry_season_score(entry: Dictionary) -> int:
	if entry.has("score"):
		return int(entry["score"])
	return int(entry.get("money", 0)) + int(entry.get("trophies", 0)) * 300 \
		+ int(entry.get("upgrade_total", 0)) * 40 + _entry_fish_count(entry) * 2


func _is_high_score_better(a, b) -> bool:
	var ad: Dictionary = a if a is Dictionary else {}
	var bd: Dictionary = b if b is Dictionary else {}
	# SEASON SCORE is the headline metric — it ranks first; the old columns
	# stay on as tiebreaks.
	var score_diff := _entry_season_score(ad) - _entry_season_score(bd)
	if score_diff != 0:
		return score_diff > 0
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
	# Reopening the screen while a slow fetch is in flight would hit ERR_BUSY
	# (engine console error + stuck status) — cancel is a safe no-op when idle.
	global_scores_fetch_request.cancel_request()
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
		# --- Story first: who you are and why you're here ---
		{"title": "WELCOME TO RAIDER BAY", "accent": GOLD, "visual": "story_boat",
			"body": "Cold water, big fish, bigger money. You're a captain in Raider Bay, Alaska — one boat, one short season, and a bay stacked with the richest fishing grounds in the north."},
		{"title": "MAKE YOUR FORTUNE", "accent": GOLD, "visual": "story_goal",
			"body": "The job is simple: catch fish, sell them at the docks, and pour the money back into your boat. When the season ends, your cash and trophies are your score — the bay remembers its best captains."},
		# --- Then the rules, in the order you'll meet them ---
		{"title": "THE BAY IS A DECK", "accent": CYAN, "visual": "board",
			"body": "Every card on the board is a fishing spot. Deep water at the top hides the biggest, most valuable fish — but it's a long sail home to your dock at the bottom."},
		{"title": "YOUR DAILY BUDGET", "accent": Color("#8ad5f3"), "visual": "counters",
			"body": "Each day brings a few MOVES to sail and one CAST to reel in fish — FINDS from your Fish Finder scan the water first. Spend it all, then END DAY and the weather rolls in."},
		{"title": "SAIL THE BAY", "accent": Color("#ff6161"), "visual": "board_boat",
			"body": "Tap a card next to your boat to sail there — straight or diagonal, one move each. Long-press any card to peek at what you know about it."},
		{"title": "FIND, THEN CAST", "accent": Color("#84ed72"), "visual": "find_cast",
			"body": "FIND FISH scans the spot under your boat and flips the card. Found something? CAST rolls the die to see how many you reel in — each spot only has so many casts."},
		{"title": "SELL BEFORE IT SPOILS", "accent": GOLD, "visual": "sell",
			"body": "Your catch rides in the live well, and it won't stay fresh forever. Sail back to THE DOCKS and sell before it spoils — or roll the dice on a HAGGLE for a better price."},
		{"title": "UPGRADE AT THE SHOP", "accent": PURPLE, "visual": "ship",
			"body": "At the docks, spend your earnings on ship cards: motors add moves, fish finders add scans, nets haul bigger catches, and a live well keeps fish fresh longer."},
		{"title": "WEATHER THE SEASON", "accent": CYAN, "visual": "weather",
			"body": "Every night the weather turns. Rain fattens your haul, squalls and hurricanes cut it — and any rough night can smash your gear. Survive the whole season and post your best score!"},
	]


func _build_deck_training_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.z_index = 500
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
	box.add_theme_constant_override("separation", 20)
	_anchor_fill(box)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(box)

	# A real slice of the game instead of a flat icon, held in a fixed-height stage
	# so the title and body stay anchored as you page between slides.
	var stage := CenterContainer.new()
	stage.custom_minimum_size = Vector2(0, 204)
	stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(stage)
	var visual := _deck_slide_visual(str(slide.get("visual", "")), accent)
	visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(visual)

	var title := _label(slide["title"], 40, accent, HORIZONTAL_ALIGNMENT_CENTER)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	title.add_theme_constant_override("outline_size", 3)
	title.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.6))
	box.add_child(title)

	var body := _label(slide["body"], 22, _with_alpha(TEXT_PRIMARY, 0.96), HORIZONTAL_ALIGNMENT_CENTER)
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.custom_minimum_size = Vector2(640, 0)
	body.add_theme_constant_override("line_spacing", 6)
	box.add_child(body)

	root.set_meta("visual", visual)
	root.set_meta("title", title)
	root.set_meta("body", body)
	return root


# Each slide shows a real slice of the game the player is about to touch,
# looping a little demonstration of the rule it teaches.
func _deck_slide_visual(kind: String, accent: Color) -> Control:
	match kind:
		"story_boat":
			return _deck_visual_story_boat()
		"story_goal":
			return _deck_visual_goal()
		"board":
			return _deck_visual_board(accent, false)
		"board_boat":
			return _deck_visual_board(accent, true)
		"counters":
			return _deck_visual_counters()
		"find_cast":
			return _deck_visual_find_cast()
		"sell":
			return _deck_visual_sell()
		"ship":
			return _deck_visual_ship()
		"weather":
			return _deck_visual_weather()
	return _deck_visual_board(accent, false)


# A single mini board cell, styled like the real card-table cells (white rim, depth fill).
func _deck_board_card(w: float, h: float, fill: Color, border: Color) -> Control:
	var card := Control.new()
	card.custom_minimum_size = Vector2(w, h)
	card.size = Vector2(w, h)
	card.pivot_offset = Vector2(w, h) * 0.5
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_draw_squarestep_card(card, Vector2(w, h), fill, border, 0, 0, 0)
	return card


# The bay: a mini grid of depth-tinted cards (deeper rows = darker), optionally with the
# boat parked at the dock and its reachable neighbours lit up. Loops a little demo:
# the boat sails to a neighbouring card and back; without the boat, the deep row shimmers.
func _deck_visual_board(accent: Color, with_boat: bool) -> Control:
	var cols := 6
	var rows := 4
	var cw := 46.0
	var ch := 34.0
	var gap := 6.0
	var gw := float(cols) * cw + float(cols - 1) * gap
	var gh := float(rows) * ch + float(rows - 1) * gap
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(gw, gh)
	wrap.size = Vector2(gw, gh)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var items: Array = []
	var depth_rows := [0, 2, 4, 5]
	var boat_col := 2
	var boat_row := rows - 1
	for r in range(rows):
		var fill := _board_zone_card_color(int(depth_rows[r]))
		for c in range(cols):
			# Moves allow diagonals, so light the full ring around the boat.
			var adjacent := with_boat and maxi(absi(c - boat_col), absi(r - boat_row)) == 1
			var border: Color = accent.lightened(0.25) if adjacent else Color("#e7f0f5")
			var card := _deck_board_card(cw, ch, fill, border)
			card.position = Vector2(float(c) * (cw + gap), float(r) * (ch + gap))
			wrap.add_child(card)
			items.append(card)
	if with_boat:
		var boat := _icon_texture_rect(ICON_CARD_SHIP_TEXTURE, Vector2(28, 28), Color("#ffffff"))
		boat.mouse_filter = Control.MOUSE_FILTER_IGNORE
		boat.pivot_offset = Vector2(14, 14)  # pop from the center, not the corner
		boat.position = Vector2(float(boat_col) * (cw + gap) + (cw - 28.0) * 0.5, float(boat_row) * (ch + gap) + (ch - 28.0) * 0.5)
		wrap.add_child(boat)
		items.append(boat)
		# Demo loop: sail one card right, pause, sail diagonally home.
		var home := boat.position
		var side := home + Vector2(cw + gap, 0.0)
		var up := home + Vector2(0.0, -(ch + gap))
		var bt := boat.create_tween().set_loops()
		bt.tween_interval(1.0)
		bt.tween_property(boat, "position", side, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		bt.tween_interval(0.9)
		bt.tween_property(boat, "position", up, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		bt.tween_interval(0.9)
		bt.tween_property(boat, "position", home, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	else:
		# Deep water breathes: the top row's cards swell gently, phase-shifted.
		for c in range(cols):
			var deep: Control = items[c]
			var st := deep.create_tween().set_loops()
			st.tween_interval(0.5 + 0.17 * float(c))
			st.tween_property(deep, "scale", Vector2(1.08, 1.08), 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			st.tween_property(deep, "scale", Vector2.ONE, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wrap.set_meta("anim_items", items)
	wrap.set_meta("anim_pop", true)
	return wrap


# One static counter chip, mirroring the chunky left-rail counters.
func _deck_mini_counter(icon_tex: Texture2D, title: String, value: String, accent: Color) -> Control:
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(100, 108)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := _styled_shadow(accent.darkened(0.66), accent.darkened(0.04), 4, 9, 5)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 9
	style.content_margin_bottom = 10
	card.add_theme_stylebox_override("panel", style)
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 5)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(col)
	var ic := _icon_texture_rect(icon_tex, Vector2(26, 26), accent.lightened(0.35))
	ic.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(ic)
	var ttl := _label(title, 12, accent.lightened(0.2), HORIZONTAL_ALIGNMENT_CENTER)
	ttl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ttl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(ttl)
	var well := PanelContainer.new()
	well.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	well.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ws := _styled(Color(0, 0, 0, 0.34), accent.darkened(0.24), 1, 6)
	ws.content_margin_left = 14
	ws.content_margin_right = 14
	ws.content_margin_top = 1
	ws.content_margin_bottom = 2
	well.add_theme_stylebox_override("panel", ws)
	col.add_child(well)
	var val := _label(value, 22, Color("#ffffff"), HORIZONTAL_ALIGNMENT_CENTER)
	val.mouse_filter = Control.MOUSE_FILTER_IGNORE
	well.add_child(val)
	card.set_meta("value_label", val)
	return card


# Loop a label through a sequence of texts (the "spending your budget" tick).
func _deck_loop_ticker(label: Label, seq: Array, step: float) -> void:
	if label == null:
		return
	var t := label.create_tween().set_loops()
	for v in seq:
		var text := str(v)
		t.tween_interval(step)
		t.tween_callback(func() -> void: label.text = text)


# The daily budget: MOVES / FIND FISH / CAST, exactly the chips on the left rail —
# each one ticks down as if a day were being spent, then the next day resets it.
func _deck_visual_counters() -> Control:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 14)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var items: Array = []
	# Real day-one numbers (for a boat with a Fish Finder aboard): 3 moves,
	# finder-level finds, one cast.
	var specs := [
		[ICON_MOVES_TEXTURE, "MOVES", "3", Color("#ff6161"), ["2", "1", "0", "3"]],
		[ICON_FIND_FISH_TEXTURE, "FIND FISH", "1", Color("#c889ff"), ["0", "1"]],
		[ICON_CAST_TEXTURE, "CAST", "1", Color("#84ed72"), ["0", "1"]],
	]
	for s in specs:
		var c := _deck_mini_counter(s[0], s[1], s[2], s[3])
		row.add_child(c)
		items.append(c)
		_deck_loop_ticker(c.get_meta("value_label") as Label, s[4], 1.05)
	row.set_meta("anim_items", items)
	row.set_meta("anim_pop", false)
	return row


# Casting: a fanned hand of real fish cards (with price tags for the sell slide).
func _deck_visual_cards(species_list: Array, badge_list: Array, badge_accent: Color) -> Control:
	var cw := 84.0
	var ch := 116.0
	var n := species_list.size()
	var spread := 68.0
	var ww := cw + float(max(0, n - 1)) * spread + 36.0
	var wh := ch + 34.0
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(ww, wh)
	wrap.size = Vector2(ww, wh)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var items: Array = []
	for i in range(n):
		var t := float(i) - float(n - 1) / 2.0
		var badge: String = str(badge_list[i]) if i < badge_list.size() else ""
		var acc: Color = badge_accent if badge != "" else Color(0, 0, 0, 0)
		var card := _build_result_card(_fish_card_texture(str(species_list[i])), Vector2(cw, ch), badge, acc)
		card.position = Vector2(ww * 0.5 - cw * 0.5 + t * spread, wh * 0.5 - ch * 0.5 + absf(t) * 9.0)
		card.rotation_degrees = t * 8.5
		wrap.add_child(card)
		items.append(card)
	wrap.set_meta("anim_items", items)
	wrap.set_meta("anim_pop", true)
	return wrap


# Loop a stacked card flip: back collapses edge-on, front sweeps open, then reverses.
# Both must be pivot-centered siblings occupying the same spot.
func _deck_loop_flip(front: Control, back: Control, hold: float) -> void:
	var t := front.create_tween().set_loops()
	t.tween_interval(hold)
	t.tween_property(back, "scale:x", 0.0, 0.13).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.tween_property(front, "scale:x", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_interval(hold + 0.5)
	t.tween_property(front, "scale:x", 0.0, 0.13).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.tween_property(back, "scale:x", 1.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


# Loop a label counting up to a total (the register ringing a sale up), then hold.
func _deck_loop_count(label: Label, prefix: String, from_v: int, to_v: int, dur: float, hold: float) -> void:
	var t := label.create_tween().set_loops()
	t.tween_method(func(v: float) -> void: label.text = "%s%d" % [prefix, int(round(v))], float(from_v), float(to_v), dur)
	t.tween_interval(hold)


# Upgrades: a fanned hand of the REAL ship cards from the dock shop; the last one
# keeps flipping over from its card back — the shop's purchase reveal, on loop.
func _deck_visual_ship() -> Control:
	var cw := 96.0
	var csize := Vector2(cw, cw * CATCH_CARD_ASPECT)
	var specs := ["motor", "fish_finder", "nets"]
	var spread := 96.0
	var n := specs.size()
	var ww := csize.x + float(n - 1) * spread + 40.0
	var wh := csize.y + 36.0
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(ww, wh)
	wrap.size = Vector2(ww, wh)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var opts := {"show_shadow": true, "card_border_px": 6, "card_step_px": 3}
	var items: Array = []
	for i in range(n):
		var t := float(i) - float(n - 1) / 2.0
		var pos := Vector2(ww * 0.5 - csize.x * 0.5 + t * spread, wh * 0.5 - csize.y * 0.5 + absf(t) * 8.0)
		var rot := t * 7.5
		var front := _build_store_card_visual(str(specs[i]), 1, true, csize, opts)
		front.position = pos
		front.rotation_degrees = rot
		if i == n - 1:
			# The reveal demo: back card on top, front sweeps open on a loop.
			var back := _build_store_card_visual(str(specs[i]), 1, false, csize, opts)
			back.position = pos
			back.rotation_degrees = rot
			front.scale = Vector2(0.0, 1.0)
			wrap.add_child(front)
			wrap.add_child(back)
			items.append(back)
			_deck_loop_flip(front, back, 1.35)
		else:
			wrap.add_child(front)
			items.append(front)
	wrap.set_meta("anim_items", items)
	wrap.set_meta("anim_pop", true)
	return wrap


# One forecast chip in the real weather-strip style (solid navy, white rim, name up
# top, mult pill at the bottom) — minus the tap-to-preview button.
func _deck_weather_chip(weather_name: String, mult: float, w: float, h: float) -> Control:
	var meta := _weather_meta(weather_name)
	var chip := PanelContainer.new()
	chip.custom_minimum_size = Vector2(w, h)
	chip.size = Vector2(w, h)
	chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := _styled_shadow(REF_CARD_NAVY, REF_BORDER, 4, 12, 2)
	style.content_margin_left = 9
	style.content_margin_right = 8
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	chip.add_theme_stylebox_override("panel", style)
	var col := VBoxContainer.new()
	col.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 2)
	col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	chip.add_child(col)
	var name_label := _label(str(meta["short"]), 16, TEXT_PRIMARY, HORIZONTAL_ALIGNMENT_LEFT)
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.clip_text = true
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(name_label)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	col.add_child(spacer)
	if absf(mult - 1.0) > 0.001:
		var pill := PanelContainer.new()
		pill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var accent: Color = GREEN if mult > 1.0 else RED
		var pill_style := _styled(accent, accent.darkened(0.18), 0, 6)
		pill_style.content_margin_left = 7
		pill_style.content_margin_right = 7
		pill_style.content_margin_top = 1
		pill_style.content_margin_bottom = 2
		pill.add_theme_stylebox_override("panel", pill_style)
		col.add_child(pill)
		var pill_label := _label("%.1fx" % mult, 13, Color("#10131a"), HORIZONTAL_ALIGNMENT_CENTER)
		pill_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pill.add_child(pill_label)
	return chip


# Weather + the season prize: three real forecast chips riding a swell, and the
# trophy they're all fishing for.
func _deck_visual_weather() -> Control:
	var chip_w := 92.0
	var chip_h := 106.0
	var gap := 22.0
	var ww := chip_w * 3.0 + gap * 2.0
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(ww, 176)
	wrap.size = Vector2(ww, 176)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var items: Array = []
	var specs := [["Rain", 1.3], ["Calm", 1.0], ["Squall", 0.9]]
	for i in range(specs.size()):
		var chip := _deck_weather_chip(str(specs[i][0]), float(specs[i][1]), chip_w, chip_h)
		chip.position = Vector2(float(i) * (chip_w + gap), 4.0)
		wrap.add_child(chip)
		items.append(chip)
		# Chips ride a gentle swell, phase-shifted like days rolling in.
		var bt := chip.create_tween().set_loops()
		bt.tween_interval(0.3 * float(i))
		bt.tween_property(chip, "position:y", 12.0, 1.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		bt.tween_property(chip, "position:y", 4.0, 1.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var trophy := PanelContainer.new()
	trophy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tstyle := _styled_shadow(GOLD.darkened(0.62), GOLD, 3, 16, 4)
	tstyle.content_margin_left = 16
	tstyle.content_margin_right = 16
	tstyle.content_margin_top = 8
	tstyle.content_margin_bottom = 8
	trophy.add_theme_stylebox_override("panel", tstyle)
	var trow := HBoxContainer.new()
	trow.alignment = BoxContainer.ALIGNMENT_CENTER
	trow.add_theme_constant_override("separation", 10)
	trow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	trophy.add_child(trow)
	var tic := _icon_texture_rect(ICON_TROPHY_SOLID, Vector2(30, 30), GOLD.lightened(0.25))
	tic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	trow.add_child(tic)
	var tlbl := _label("BEST CAPTAIN", 17, GOLD.lightened(0.2), HORIZONTAL_ALIGNMENT_CENTER)
	tlbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	trow.add_child(tlbl)
	trophy.position = Vector2(ww * 0.5 - 108.0, 130.0)
	trophy.pivot_offset = Vector2(108, 23)  # rock about the center, not the corner
	trophy.rotation_degrees = -1.5
	wrap.add_child(trophy)
	items.append(trophy)
	var tt := trophy.create_tween().set_loops()
	tt.tween_property(trophy, "rotation_degrees", 1.5, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tt.tween_property(trophy, "rotation_degrees", -1.5, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wrap.set_meta("anim_items", items)
	wrap.set_meta("anim_pop", false)
	return wrap


# A rounded strip of water for the story stage.
func _deck_wave_strip(color: Color, w: float, h: float) -> Control:
	var strip := PanelContainer.new()
	strip.custom_minimum_size = Vector2(w, h)
	strip.size = Vector2(w, h)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var st := _styled(color, Color(0, 0, 0, 0), 0, int(h * 0.5))
	strip.add_theme_stylebox_override("panel", st)
	return strip


# Story: one of the real player boats riding a swell in the bay.
func _deck_visual_story_boat() -> Control:
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(380, 196)
	wrap.size = Vector2(380, 196)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var back_wave := _deck_wave_strip(Color("#16457a"), 380, 26)
	back_wave.position = Vector2(0, 138)
	wrap.add_child(back_wave)

	# The boat art rides in a white-rimmed navy card (same framing as the Boat
	# Setup carousel — the source PNGs have a solid navy background).
	var boat := PanelContainer.new()
	boat.custom_minimum_size = Vector2(160, 160)
	boat.size = Vector2(160, 160)
	var boat_style := _styled_shadow(REF_CARD_NAVY, REF_BORDER, 4, 14, 3)
	boat_style.content_margin_left = 5
	boat_style.content_margin_right = 5
	boat_style.content_margin_top = 5
	boat_style.content_margin_bottom = 5
	boat.add_theme_stylebox_override("panel", boat_style)
	boat.position = Vector2(110, 2)
	boat.pivot_offset = Vector2(80, 80)
	boat.rotation_degrees = -2.0
	boat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var boat_img := TextureRect.new()
	boat_img.texture = BOAT_TEXTURES[0]
	boat_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boat_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boat_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boat.add_child(boat_img)
	wrap.add_child(boat)

	var front_wave := _deck_wave_strip(Color("#0d3059"), 400, 36)
	front_wave.position = Vector2(-10, 158)
	wrap.add_child(front_wave)

	# The swell: the boat bobs and rocks; the water drifts underneath it.
	var bob := boat.create_tween().set_loops()
	bob.tween_property(boat, "position:y", 12.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob.tween_property(boat, "position:y", 2.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var rock := boat.create_tween().set_loops()
	rock.tween_property(boat, "rotation_degrees", 2.0, 2.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	rock.tween_property(boat, "rotation_degrees", -2.0, 2.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var bw := back_wave.create_tween().set_loops()
	bw.tween_property(back_wave, "position:x", -14.0, 1.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bw.tween_property(back_wave, "position:x", 0.0, 1.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var fw := front_wave.create_tween().set_loops()
	fw.tween_property(front_wave, "position:x", 4.0, 1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	fw.tween_property(front_wave, "position:x", -10.0, 1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	wrap.set_meta("anim_items", [back_wave, boat, front_wave])
	wrap.set_meta("anim_pop", false)
	return wrap


# Story: the point of it all — money piling up and trophies on the wall.
func _deck_visual_goal() -> Control:
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(360, 186)
	wrap.size = Vector2(360, 186)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var pill := PanelContainer.new()
	pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pstyle := _styled_shadow(GOLD, GOLD_DEEP, 0, 12, 4)
	pstyle.content_margin_left = 26
	pstyle.content_margin_right = 26
	pstyle.content_margin_top = 8
	pstyle.content_margin_bottom = 10
	pill.add_theme_stylebox_override("panel", pstyle)
	pill.position = Vector2(112, 22)
	pill.pivot_offset = Vector2(68, 28)
	wrap.add_child(pill)
	var money := _label("$0", 34, Color("#3a2a00"), HORIZONTAL_ALIGNMENT_CENTER)
	money.custom_minimum_size = Vector2(84, 0)
	money.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pill.add_child(money)
	_deck_loop_count(money, "$", 0, 640, 1.6, 1.1)

	var items: Array = [pill]
	for i in range(3):
		var trophy := _icon_texture_rect(ICON_TROPHY_SOLID, Vector2(42, 42), GOLD.lightened(0.15))
		trophy.position = Vector2(104.0 + float(i) * 58.0, 118.0 - (10.0 if i == 1 else 0.0))
		trophy.pivot_offset = Vector2(21, 21)
		trophy.mouse_filter = Control.MOUSE_FILTER_IGNORE
		wrap.add_child(trophy)
		items.append(trophy)
		var bt := trophy.create_tween().set_loops()
		bt.tween_interval(0.25 * float(i))
		bt.tween_property(trophy, "position:y", trophy.position.y - 8.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		bt.tween_property(trophy, "position:y", trophy.position.y, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	wrap.set_meta("anim_items", items)
	wrap.set_meta("anim_pop", true)
	return wrap


# Find & cast: a real spot card flipping from face-down to a fish (the FIND), with
# the cast die hopping beside it (the CAST roll).
func _deck_visual_find_cast() -> Control:
	var cw := 104.0
	var ch := cw * CATCH_CARD_ASPECT
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(330, ch + 16.0)
	wrap.size = Vector2(330, ch + 16.0)
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var slot := Vector2(64, 8)
	var back := _weather_preview_back_card(cw, ch)
	back.position = slot
	wrap.add_child(back)
	var front := _build_result_card(_fish_card_texture("Tuna"), Vector2(cw, ch))
	front.position = slot
	front.pivot_offset = Vector2(cw, ch) * 0.5
	front.scale = Vector2(0.0, 1.0)
	wrap.add_child(front)
	_deck_loop_flip(front, back, 1.25)

	var die := _icon_texture_rect(_pixel_die_texture(), Vector2(48, 48), Color(1, 1, 1))
	die.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	die.position = Vector2(226, ch * 0.5 - 16.0)
	die.pivot_offset = Vector2(24, 24)
	die.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wrap.add_child(die)
	var die_y := die.position.y
	var hop := die.create_tween().set_loops()
	hop.tween_interval(1.1)
	hop.tween_property(die, "position:y", die_y - 20.0, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	hop.tween_property(die, "position:y", die_y, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	var spin := die.create_tween().set_loops()
	spin.tween_property(die, "rotation_degrees", 9.0, 1.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	spin.tween_property(die, "rotation_degrees", -9.0, 1.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	wrap.set_meta("anim_items", [back, die])
	wrap.set_meta("anim_pop", false)
	return wrap


# Selling: the fan of caught fish with their price tags, and the till ringing up
# the total underneath.
func _deck_visual_sell() -> Control:
	var fan := _deck_visual_cards(["Tuna", "Halibut"], ["$74", "$112"], GOLD)
	var fan_size: Vector2 = fan.custom_minimum_size
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(fan_size.x, fan_size.y + 46.0)
	wrap.size = wrap.custom_minimum_size
	wrap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fan.position = Vector2.ZERO
	wrap.add_child(fan)

	var pill := PanelContainer.new()
	pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pstyle := _styled_shadow(GOLD, GOLD_DEEP, 0, 10, 3)
	pstyle.content_margin_left = 18
	pstyle.content_margin_right = 18
	pstyle.content_margin_top = 4
	pstyle.content_margin_bottom = 6
	pill.add_theme_stylebox_override("panel", pstyle)
	pill.position = Vector2(fan_size.x * 0.5 - 62.0, fan_size.y + 6.0)
	pill.pivot_offset = Vector2(62, 18)
	wrap.add_child(pill)
	var total := _label("$0", 22, Color("#3a2a00"), HORIZONTAL_ALIGNMENT_CENTER)
	total.custom_minimum_size = Vector2(88, 0)
	total.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pill.add_child(total)
	_deck_loop_count(total, "$", 0, 186, 1.2, 1.3)

	var items: Array = []
	items.append_array(fan.get_meta("anim_items", []))
	items.append(pill)
	wrap.set_meta("anim_items", items)
	wrap.set_meta("anim_pop", true)
	return wrap


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


# Staggered, GPU-friendly entrance: the visual's pieces deal in one by one (like the
# real board/catch), then the title and body fade in beneath them.
func _animate_deck_slide_in(slide: Control) -> void:
	var visual: Control = slide.get_meta("visual")
	var title: Control = slide.get_meta("title")
	var body: Control = slide.get_meta("body")

	var items: Array = []
	if visual != null and is_instance_valid(visual):
		items = visual.get_meta("anim_items", [])
		if items.is_empty():
			items = [visual]
	var pop: bool = visual.get_meta("anim_pop", false) if (visual != null and is_instance_valid(visual)) else false
	var stagger := clampf(0.55 / float(max(1, items.size())), 0.018, 0.07)
	for i in range(items.size()):
		var it: Control = items[i]
		if not is_instance_valid(it):
			continue
		it.modulate = Color(1, 1, 1, 0)
		if pop:
			it.scale = Vector2(0.62, 0.62)
		var it_t := it.create_tween()
		it_t.tween_interval(0.03 + float(i) * stagger)
		it_t.set_parallel(true)
		it_t.tween_property(it, "modulate:a", 1.0, 0.18)
		if pop:
			it_t.tween_property(it, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	title.modulate = Color(1, 1, 1, 0)
	var tt := title.create_tween()
	tt.tween_interval(0.14)
	tt.tween_property(title, "modulate:a", 1.0, 0.22)

	body.modulate = Color(1, 1, 1, 0)
	var bt := body.create_tween()
	bt.tween_interval(0.2)
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
	_play_sfx("modal_open")
	deck_training_index = 0
	deck_training_animating = false
	if deck_training_slide_node != null and is_instance_valid(deck_training_slide_node):
		deck_training_slide_node.queue_free()
	deck_training_slide_node = null
	_render_deck_training_slide(0)
	if ui.has("deck_training_overlay"):
		var ov := ui["deck_training_overlay"] as Control
		ov.move_to_front()  # top-most sibling so input can't fall through to the title behind it
		ov.visible = true


func _hide_deck_training() -> void:
	# Free the slide so its looping demo tweens die with it — hiding the overlay
	# alone would leave them processing every frame for the rest of the session.
	if deck_training_slide_node != null and is_instance_valid(deck_training_slide_node):
		deck_training_slide_node.queue_free()
	deck_training_slide_node = null
	deck_training_animating = false
	if ui.has("deck_training_overlay"):
		(ui["deck_training_overlay"] as Control).visible = false
	if not seen_training:
		seen_training = true
		_save_prefs()


# ---------------------------------------------------------------------------
# Boat Setup screen (shown before every new game)
# ---------------------------------------------------------------------------

func _pick_phrase(arr: Array) -> String:
	return str(arr[rng.randi_range(0, arr.size() - 1)])


func _random_boat_name() -> String:
	return "The %s %s" % [_pick_phrase(BOAT_ADJ), _pick_phrase(BOAT_NOUN)]


func _random_captain_name() -> String:
	return "%s %s" % [_pick_phrase(CAPTAIN_FIRST), _pick_phrase(CAPTAIN_LAST)]


# The codebase's first text input — a themed LineEdit that matches the design system.
func _line_edit(placeholder_text: String, max_len: int, font_size: int = FONT_CELL) -> LineEdit:
	var le := LineEdit.new()
	le.placeholder_text = placeholder_text
	le.max_length = max_len
	le.alignment = HORIZONTAL_ALIGNMENT_CENTER
	le.add_theme_font_override("font", FONT_BALATRO)
	le.add_theme_font_size_override("font_size", font_size)
	le.add_theme_color_override("font_color", TEXT_PRIMARY)
	le.add_theme_color_override("font_placeholder_color", TEXT_DIM)
	le.add_theme_color_override("caret_color", CYAN)
	le.add_theme_color_override("selection_color", Color(CYAN.r, CYAN.g, CYAN.b, 0.35))
	var pad := maxi(11, int(font_size * 0.4))
	var normal := _styled(REF_INSET, BORDER_FRAME, 2, 8)
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	normal.content_margin_top = pad
	normal.content_margin_bottom = pad
	le.add_theme_stylebox_override("normal", normal)
	var focus := _styled(REF_INSET.lightened(0.05), BORDER_HI, 2, 8)
	focus.content_margin_left = 16
	focus.content_margin_right = 16
	focus.content_margin_top = pad
	focus.content_margin_bottom = pad
	le.add_theme_stylebox_override("focus", focus)
	le.custom_minimum_size = Vector2(0, font_size + 36)
	le.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return le


func _build_boat_setup_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 205
	add_child(overlay)
	ui["boat_setup_overlay"] = overlay

	var bg := ColorRect.new()
	bg.color = REF_BG_NAVY
	_anchor_fill(bg)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(bg)

	var center := CenterContainer.new()
	_anchor_fill(center)
	overlay.add_child(center)

	var col := VBoxContainer.new()
	col.custom_minimum_size = Vector2(1140, 0)
	col.add_theme_constant_override("separation", 24)
	center.add_child(col)

	var title := _label("OUTFIT YOUR BOAT", FONT_TITLE + 6, GOLD, HORIZONTAL_ALIGNMENT_CENTER)
	title.add_theme_constant_override("outline_size", 3)
	title.add_theme_color_override("font_outline_color", Color("#3a2a00"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(title)

	# Boat picker (left) and name picker (right), side by side.
	var main_row := HBoxContainer.new()
	main_row.add_theme_constant_override("separation", 52)
	main_row.alignment = BoxContainer.ALIGNMENT_CENTER
	main_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(main_row)

	# --- LEFT: boat carousel + position dots ---
	var picker := VBoxContainer.new()
	picker.add_theme_constant_override("separation", 16)
	picker.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	main_row.add_child(picker)

	var carousel := HBoxContainer.new()
	carousel.add_theme_constant_override("separation", 14)
	carousel.alignment = BoxContainer.ALIGNMENT_CENTER
	picker.add_child(carousel)

	var left_arrow := _flat_button("<", 92, 92, BG_PANEL_LIGHT, CYAN, 44, 18)
	left_arrow.size_flags_vertical = Control.SIZE_SHRINK_CENTER  # keep it square
	left_arrow.pressed.connect(func(): _boat_setup_cycle(-1))
	carousel.add_child(left_arrow)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(340, 340)
	var cs := _styled_shadow(REF_CARD_NAVY, REF_BORDER, 4, 16, 4)
	cs.content_margin_left = 10
	cs.content_margin_right = 10
	cs.content_margin_top = 10
	cs.content_margin_bottom = 10
	card.add_theme_stylebox_override("panel", cs)
	carousel.add_child(card)

	var boat_img := TextureRect.new()
	boat_img.texture = BOAT_TEXTURES[0]
	boat_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boat_img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boat_img.custom_minimum_size = Vector2(320, 320)
	card.add_child(boat_img)
	ui["boat_setup_image"] = boat_img

	var right_arrow := _flat_button(">", 92, 92, BG_PANEL_LIGHT, CYAN, 44, 18)
	right_arrow.size_flags_vertical = Control.SIZE_SHRINK_CENTER  # keep it square
	right_arrow.pressed.connect(func(): _boat_setup_cycle(1))
	carousel.add_child(right_arrow)

	var dots := HBoxContainer.new()
	dots.alignment = BoxContainer.ALIGNMENT_CENTER
	dots.add_theme_constant_override("separation", 12)
	dots.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	picker.add_child(dots)
	ui["boat_setup_dots"] = dots
	for i in range(BOAT_TEXTURES.size()):
		var dot := PanelContainer.new()
		dot.custom_minimum_size = Vector2(16, 16)
		dot.add_theme_stylebox_override("panel", _styled(TEXT_DIM, Color(0, 0, 0, 0), 0, 8))
		dots.add_child(dot)

	# This boat's free starting perk — accent pill, refreshed with the carousel.
	var perk_pill := PanelContainer.new()
	perk_pill.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var perk_style := _styled(GOLD, Color(0, 0, 0, 0), 0, 12)
	perk_style.content_margin_left = 18
	perk_style.content_margin_right = 18
	perk_style.content_margin_top = 5
	perk_style.content_margin_bottom = 7
	perk_pill.add_theme_stylebox_override("panel", perk_style)
	picker.add_child(perk_pill)
	var perk_label := _label("STARTS WITH +1 MOTOR", FONT_CELL + 4, Color("#10131a"), HORIZONTAL_ALIGNMENT_CENTER)
	perk_pill.add_child(perk_label)
	ui["boat_setup_perk_pill"] = perk_pill
	ui["boat_setup_perk"] = perk_label

	# --- RIGHT: captain + boat name fields (2x fonts) ---
	var names := VBoxContainer.new()
	names.add_theme_constant_override("separation", 8)
	names.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	names.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	main_row.add_child(names)

	var cap_label := _label("CAPTAIN", FONT_HEADER * 2, CYAN, HORIZONTAL_ALIGNMENT_LEFT)
	names.add_child(cap_label)
	var cap_edit := _line_edit("Captain's name", 22, FONT_CELL * 2)
	names.add_child(cap_edit)
	ui["boat_setup_captain"] = cap_edit

	var name_gap := Control.new()
	name_gap.custom_minimum_size = Vector2(0, 18)
	names.add_child(name_gap)

	var boat_label := _label("BOAT NAME", FONT_HEADER * 2, CYAN, HORIZONTAL_ALIGNMENT_LEFT)
	names.add_child(boat_label)
	var boat_edit := _line_edit("Boat name", 24, FONT_CELL * 2)
	names.add_child(boat_edit)
	ui["boat_setup_boat"] = boat_edit

	# Buttons: SHUFFLE + SET SAIL
	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 16)
	btn_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_child(btn_row)

	var shuffle_btn := _flat_button("SHUFFLE", 220, 74, BG_PANEL_LIGHT, TEXT_MUTED, 32, 18)
	shuffle_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shuffle_btn.pressed.connect(_boat_setup_shuffle)
	btn_row.add_child(shuffle_btn)

	var sail_btn := _flat_button("SET SAIL", 300, 74, GOLD, Color("#3a2a00"), 34, 18)
	sail_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sail_btn.pressed.connect(_boat_setup_set_sail)
	btn_row.add_child(sail_btn)

	# Close X (top-right) returns to the title screen
	var close_btn := _close_x_button()
	close_btn.anchor_left = 1.0
	close_btn.anchor_right = 1.0
	close_btn.offset_left = -86
	close_btn.offset_right = -26
	close_btn.offset_top = 26
	close_btn.offset_bottom = 86
	close_btn.pressed.connect(_boat_setup_back)
	overlay.add_child(close_btn)


func _refresh_boat_carousel() -> void:
	if ui.has("boat_setup_image"):
		(ui["boat_setup_image"] as TextureRect).texture = BOAT_TEXTURES[boat_choice]
	if ui.has("boat_setup_dots"):
		var dots: HBoxContainer = ui["boat_setup_dots"]
		for i in range(dots.get_child_count()):
			var dot := dots.get_child(i) as PanelContainer
			var sb := dot.get_theme_stylebox("panel") as StyleBoxFlat
			if sb != null:
				sb.bg_color = GOLD if i == boat_choice else TEXT_DIM
	if ui.has("boat_setup_perk"):
		var perk_key := BOAT_PERKS[clampi(boat_choice, 0, BOAT_PERKS.size() - 1)]
		(ui["boat_setup_perk"] as Label).text = "STARTS WITH +1 %s" % _upgrade_name(perk_key).to_upper()
		var pill: PanelContainer = ui["boat_setup_perk_pill"]
		var pill_sb := pill.get_theme_stylebox("panel") as StyleBoxFlat
		if pill_sb != null:
			pill_sb.bg_color = _upgrade_accent(perk_key)


func _show_boat_setup(versus: bool) -> void:
	_play_sfx("modal_open")
	pending_versus = versus
	_hide_solo_save_chooser()  # don't let the New Trip / Continue chooser sit over it
	boat_choice = rng.randi_range(0, BOAT_TEXTURES.size() - 1)
	if ui.has("boat_setup_captain"):
		(ui["boat_setup_captain"] as LineEdit).text = _random_captain_name()
	if ui.has("boat_setup_boat"):
		(ui["boat_setup_boat"] as LineEdit).text = _random_boat_name()
	_refresh_boat_carousel()
	if ui.has("boat_setup_overlay"):
		var ov := ui["boat_setup_overlay"] as Control
		ov.move_to_front()  # top-most sibling so input reaches this screen
		ov.visible = true


func _hide_boat_setup() -> void:
	if ui.has("boat_setup_overlay"):
		(ui["boat_setup_overlay"] as Control).visible = false


func _boat_setup_back() -> void:
	_stop_dice_roll()
	_hide_boat_setup()
	_show_start_screen()


func _boat_setup_cycle(dir: int) -> void:
	boat_choice = wrapi(boat_choice + dir, 0, BOAT_TEXTURES.size())
	_refresh_boat_carousel()


func _boat_setup_shuffle() -> void:
	boat_choice = rng.randi_range(0, BOAT_TEXTURES.size() - 1)
	if ui.has("boat_setup_captain"):
		(ui["boat_setup_captain"] as LineEdit).text = _random_captain_name()
	if ui.has("boat_setup_boat"):
		(ui["boat_setup_boat"] as LineEdit).text = _random_boat_name()
	_refresh_boat_carousel()
	_play_dice_roll()


func _boat_setup_set_sail() -> void:
	captain_name = (ui["boat_setup_captain"] as LineEdit).text.strip_edges()
	boat_name = (ui["boat_setup_boat"] as LineEdit).text.strip_edges()
	if captain_name == "":
		captain_name = _random_captain_name()
	if boat_name == "":
		boat_name = _random_boat_name()
	_stop_dice_roll()  # don't let a mid-shuffle die tumble onto the board
	_hide_boat_setup()
	_new_game(pending_versus, true)


# ---------------------------------------------------------------------------
# Reusable 3D dice roll — a real tumbling die composited over the 2D UI via a
# transparent 3D SubViewport. Built lazily and reused. The shuffle roll is
# cosmetic (doesn't settle on a face); gameplay callers can wait on on_done.
# ---------------------------------------------------------------------------

func _ensure_dice_rig() -> void:
	if ui.has("dice_overlay"):
		return
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	# Purely cosmetic effect layer: it move_to_front()s on every roll, so it MUST
	# stay MOUSE_FILTER_IGNORE (and all its children too) or it would swallow input
	# from whatever screen it rolled over (Godot input picking is sibling-order).
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.visible = false
	overlay.z_index = 600
	add_child(overlay)
	ui["dice_overlay"] = overlay

	var svc := SubViewportContainer.new()
	svc.stretch = true
	svc.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_anchor_fill(svc)
	overlay.add_child(svc)

	var sv := SubViewport.new()
	sv.own_world_3d = true
	sv.transparent_bg = true
	sv.msaa_3d = Viewport.MSAA_2X
	# Idle until a roll starts; _play_dice_roll flips this to ALWAYS so the 3D die
	# only costs render time while it's on-screen.
	sv.render_target_update_mode = SubViewport.UPDATE_DISABLED
	svc.add_child(sv)
	ui["dice_viewport"] = sv

	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_PERSPECTIVE
	cam.fov = 42.0
	cam.position = Vector3(0, 0, 11)
	sv.add_child(cam)

	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-42, -28, 0)
	key.light_energy = 1.5
	sv.add_child(key)

	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(24, 140, 0)
	fill.light_energy = 0.55
	sv.add_child(fill)

	var die := _build_die_node()
	sv.add_child(die)
	ui["dice_node"] = die


# A white cube with correctly-laid-out black pips (opposite faces sum to 7).
func _build_die_node() -> Node3D:
	var root := Node3D.new()

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("#f4f1e6")
	mat.roughness = 0.5
	mat.metallic = 0.0
	# Rounded die: a cube intersected with a sphere shaves the corners and
	# softens the edges while the pip faces stay flat (classic casino die).
	var body := CSGBox3D.new()
	body.size = Vector3(1.8, 1.8, 1.8)
	body.material = mat
	var rounder := CSGSphere3D.new()
	rounder.operation = CSGShape3D.OPERATION_INTERSECTION
	rounder.radius = 1.22
	rounder.radial_segments = 48
	rounder.rings = 24
	rounder.material = mat
	body.add_child(rounder)
	root.add_child(body)

	var pip_mat := StandardMaterial3D.new()
	pip_mat.albedo_color = Color("#161616")
	pip_mat.roughness = 0.6

	var half := 0.9
	var o := 0.48
	var layouts := {
		1: [Vector2(0, 0)],
		2: [Vector2(-o, o), Vector2(o, -o)],
		3: [Vector2(-o, o), Vector2(0, 0), Vector2(o, -o)],
		4: [Vector2(-o, o), Vector2(o, o), Vector2(-o, -o), Vector2(o, -o)],
		5: [Vector2(-o, o), Vector2(o, o), Vector2(0, 0), Vector2(-o, -o), Vector2(o, -o)],
		6: [Vector2(-o, o), Vector2(o, o), Vector2(-o, 0), Vector2(o, 0), Vector2(-o, -o), Vector2(o, -o)],
	}
	var faces := [
		{"n": Vector3(0, 0, 1), "u": Vector3(1, 0, 0), "v": Vector3(0, 1, 0), "count": 1},
		{"n": Vector3(0, 0, -1), "u": Vector3(-1, 0, 0), "v": Vector3(0, 1, 0), "count": 6},
		{"n": Vector3(1, 0, 0), "u": Vector3(0, 0, -1), "v": Vector3(0, 1, 0), "count": 2},
		{"n": Vector3(-1, 0, 0), "u": Vector3(0, 0, 1), "v": Vector3(0, 1, 0), "count": 5},
		{"n": Vector3(0, 1, 0), "u": Vector3(1, 0, 0), "v": Vector3(0, 0, -1), "count": 3},
		{"n": Vector3(0, -1, 0), "u": Vector3(1, 0, 0), "v": Vector3(0, 0, 1), "count": 4},
	]
	for face in faces:
		var pips: Array = layouts[int(face["count"])]
		var n: Vector3 = face["n"]
		var u: Vector3 = face["u"]
		var v: Vector3 = face["v"]
		for p in pips:
			var pip := MeshInstance3D.new()
			var sph := SphereMesh.new()
			sph.radius = 0.15
			sph.height = 0.30
			pip.mesh = sph
			pip.material_override = pip_mat
			pip.position = n * (half + 0.02) + u * p.x + v * p.y
			pip.scale = Vector3.ONE - n.abs() * 0.65
			root.add_child(pip)
	return root


func _play_dice_roll(on_done: Callable = Callable()) -> void:
	_ensure_dice_rig()
	var overlay := ui["dice_overlay"] as Control
	var die := ui["dice_node"] as Node3D

	# Kill any in-flight roll so rapid presses don't fight.
	if overlay.has_meta("dice_tweens"):
		for old in overlay.get_meta("dice_tweens"):
			if old is Tween and old.is_valid():
				old.kill()

	overlay.move_to_front()
	overlay.visible = true
	(ui["dice_viewport"] as SubViewport).render_target_update_mode = SubViewport.UPDATE_ALWAYS
	if dice_sfx_player != null and is_instance_valid(dice_sfx_player):
		dice_sfx_player.stop()  # mashed re-roll: restart the rattle, don't stack it
	dice_sfx_player = _play_sfx("dice_roll")

	die.position = Vector3(-7.5, -0.3, 0.0)
	die.rotation = Vector3(rng.randf() * TAU, rng.randf() * TAU, rng.randf() * TAU)
	die.scale = Vector3.ONE

	var dur := 0.95
	var target_rot := die.rotation + Vector3(
		TAU * rng.randf_range(2.0, 3.0),
		TAU * rng.randf_range(2.5, 3.5),
		TAU * rng.randf_range(1.5, 2.5))

	var t := overlay.create_tween()
	t.set_parallel(true)
	t.tween_property(die, "position:x", 7.5, dur)
	t.tween_property(die, "rotation", target_rot, dur)
	t.chain().tween_callback(_on_dice_roll_done.bind(overlay, on_done))

	var ty := overlay.create_tween()
	ty.tween_property(die, "position:y", 1.1, dur * 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	ty.tween_property(die, "position:y", -0.6, dur * 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	overlay.set_meta("dice_tweens", [t, ty])


func _on_dice_roll_done(overlay: Control, on_done: Callable) -> void:
	overlay.visible = false
	if ui.has("dice_viewport"):
		(ui["dice_viewport"] as SubViewport).render_target_update_mode = SubViewport.UPDATE_DISABLED
	if on_done.is_valid():
		on_done.call()


# Abort an in-flight cosmetic roll (e.g. leaving the setup screen mid-shuffle).
func _stop_dice_roll() -> void:
	if dice_sfx_player != null and is_instance_valid(dice_sfx_player):
		dice_sfx_player.stop()
		dice_sfx_player = null
	if not ui.has("dice_overlay"):
		return
	var overlay := ui["dice_overlay"] as Control
	if overlay.has_meta("dice_tweens"):
		for old in overlay.get_meta("dice_tweens"):
			if old is Tween and old.is_valid():
				old.kill()
	overlay.visible = false
	if ui.has("dice_viewport"):
		(ui["dice_viewport"] as SubViewport).render_target_update_mode = SubViewport.UPDATE_DISABLED


# ---------------------------------------------------------------------------
# Celebration FX — multi-colour confetti (good luck) and a BONK stamp (bad luck)
# ---------------------------------------------------------------------------

func _ensure_confetti_rig() -> void:
	if ui.has("confetti_overlay"):
		return
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.z_index = 620
	add_child(overlay)
	ui["confetti_overlay"] = overlay

	var img := Image.create(10, 14, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	var tex := ImageTexture.create_from_image(img)

	var vp := get_viewport().get_visible_rect().size
	var emitters: Array = []
	for c in [GOLD, GREEN, CYAN, PURPLE, RED, INDIGO]:
		var p := CPUParticles2D.new()
		p.emitting = false
		p.one_shot = true
		p.amount = 24
		p.lifetime = 2.1
		p.explosiveness = 0.92
		p.texture = tex
		p.position = Vector2(vp.x * 0.5, -20.0)
		p.direction = Vector2(0, 1)
		p.spread = 42.0
		p.gravity = Vector2(0, 640)
		p.initial_velocity_min = 150.0
		p.initial_velocity_max = 360.0
		p.angular_velocity_min = -560.0
		p.angular_velocity_max = 560.0
		p.scale_amount_min = 0.8
		p.scale_amount_max = 1.7
		p.color = c
		p.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		p.emission_rect_extents = Vector2(vp.x * 0.5, 6.0)
		overlay.add_child(p)
		emitters.append(p)
	ui["confetti_emitters"] = emitters


func _burst_confetti(with_sfx: bool = true) -> void:
	if with_sfx:
		_play_sfx("confetti")
	_ensure_confetti_rig()
	(ui["confetti_overlay"] as Control).move_to_front()
	for p in ui["confetti_emitters"]:
		var emitter := p as CPUParticles2D
		emitter.restart()
		emitter.emitting = true


# A comedic "BONK!" stamp that slams in with a red flash, then fades. Transient.
func _play_bonk() -> void:
	_play_sfx("bonk_1" if rng.randf() < 0.5 else "bonk_2")
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.z_index = 625
	add_child(overlay)

	var flash := ColorRect.new()
	flash.color = Color(RED.r, RED.g, RED.b, 0.0)
	_anchor_fill(flash)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(flash)

	var stamp := _label("BONK!", 120, RED, HORIZONTAL_ALIGNMENT_CENTER)
	stamp.add_theme_constant_override("outline_size", 8)
	stamp.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	stamp.rotation_degrees = -9.0
	var sz := stamp.get_minimum_size()
	stamp.size = sz
	stamp.pivot_offset = sz * 0.5
	stamp.anchor_left = 0.5
	stamp.anchor_top = 0.5
	stamp.anchor_right = 0.5
	stamp.anchor_bottom = 0.5
	stamp.offset_left = -sz.x * 0.5
	stamp.offset_top = -sz.y * 0.5
	stamp.offset_right = sz.x * 0.5
	stamp.offset_bottom = sz.y * 0.5
	stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	overlay.add_child(stamp)

	stamp.scale = Vector2(2.4, 2.4)
	stamp.modulate = Color(1, 1, 1, 0)
	var t := overlay.create_tween()
	t.tween_property(stamp, "modulate:a", 1.0, 0.09)
	t.parallel().tween_property(stamp, "scale", Vector2.ONE, 0.34).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(flash, "color:a", 0.32, 0.09)
	t.tween_property(flash, "color:a", 0.0, 0.28)
	t.tween_interval(0.5)
	t.tween_property(stamp, "modulate:a", 0.0, 0.32)
	t.tween_callback(overlay.queue_free)


func _build_high_scores_screen() -> void:
	var overlay := Control.new()
	overlay.anchor_right = 1.0
	overlay.anchor_bottom = 1.0
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.visible = false
	overlay.z_index = 210
	add_child(overlay)
	ui["high_scores_overlay"] = overlay

	# Solid deep-navy screen (design-system background), not a translucent modal.
	var bg := ColorRect.new()
	bg.color = REF_BG_NAVY
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(bg)

	# Root layout: fixed header (title + X) up top, scrolling score list below.
	var root := VBoxContainer.new()
	root.anchor_right = 1.0
	root.anchor_bottom = 1.0
	root.offset_left = 26
	root.offset_right = -26
	root.offset_top = 22
	root.offset_bottom = -22
	root.add_theme_constant_override("separation", 14)
	overlay.add_child(root)

	# --- Fixed header: trophy + big title on the left, chunky X on the right ---
	var header := HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_constant_override("separation", 16)
	root.add_child(header)

	var title_icon := _icon_texture_rect(ICON_TROPHY_SOLID, Vector2(48, 48), GOLD)
	title_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	header.add_child(title_icon)

	var title := _label("HIGH SCORES", FONT_TITLE + 8, GOLD, HORIZONTAL_ALIGNMENT_LEFT)
	title.add_theme_constant_override("shadow_offset_y", 4)
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	title.add_theme_constant_override("outline_size", 3)
	title.add_theme_color_override("font_outline_color", Color("#3a2a00"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	header.add_child(title)
	ui["high_scores_title"] = title

	var close_btn := _close_x_button()
	close_btn.pressed.connect(_return_from_high_scores)
	header.add_child(close_btn)
	ui["high_scores_back"] = close_btn

	# Status line under the header (loading / local vs global).
	var status := _label("", FONT_BODY, TEXT_MUTED, HORIZONTAL_ALIGNMENT_LEFT)
	status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_child(status)
	ui["high_scores_status"] = status

	# --- Scrolling list of chunky score cards ---
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 9)
	scroll.add_child(col)
	ui["high_scores_col"] = col


func _show_high_scores_screen() -> void:
	# On mobile with a configured native leaderboard, open the platform UI instead
	# of the in-game global screen. No-ops elsewhere (falls through to the screen).
	if Leaderboards.native_available():
		Leaderboards.show_leaderboard()
		return
	if not ui.has("high_scores_overlay") or not ui.has("high_scores_col"):
		return
	_play_sfx("modal_open")

	global_scores_status = "Loading global scores..." if _global_scores_enabled() else "Local scores on this device."
	_render_high_scores_screen(_load_high_scores(), "HIGH SCORES", global_scores_status)
	var overlay := ui["high_scores_overlay"] as Control
	# GUI input picking walks siblings by tree order (not z_index), so become the
	# top-most sibling — otherwise clicks/scroll fall through to the still-visible
	# start screen behind us. Same fix as _show_deck_training().
	overlay.move_to_front()
	overlay.visible = true
	_fetch_global_high_scores()


# A chunky red X close button for the top-right of the high-scores screen.
func _close_x_button() -> Button:
	var b := _tactile_button("X", 60, 60, Color("#7a2323"), RED, Color("#ffe4e4"))
	b.add_theme_font_size_override("font_size", 30)
	b.set_meta("sfx", "tap_cancel")
	b.mouse_filter = Control.MOUSE_FILTER_STOP
	b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return b


# Big medal-style rank chip: gold #1, silver #2, bronze #3, slate beyond.
func _hs_rank_badge(rank: int) -> Control:
	var accent := REF_PANEL
	var text_col := TEXT_PRIMARY
	match rank:
		1:
			accent = GOLD
			text_col = Color("#3a2a00")
		2:
			accent = Color("#c6d4e0")
			text_col = Color("#1c2a3a")
		3:
			accent = Color("#e0954e")
			text_col = Color("#2a1600")
	var badge := PanelContainer.new()
	badge.custom_minimum_size = Vector2(54, 54)
	badge.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var s := _styled_shadow(accent, REF_BORDER, 3, 12, 2)
	s.content_margin_left = 0
	s.content_margin_right = 0
	s.content_margin_top = 0
	s.content_margin_bottom = 0
	badge.add_theme_stylebox_override("panel", s)
	var l := _label("%d" % rank, FONT_CELL_BIG, text_col, HORIZONTAL_ALIGNMENT_CENTER)
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	badge.add_child(l)
	return badge


# Icon + value stat block (trophies, money) — the primary, colorful figures.
func _hs_stat_block(icon: Texture2D, value: String, color: Color, min_w: int) -> Control:
	var h := HBoxContainer.new()
	h.custom_minimum_size = Vector2(min_w, 0)
	h.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_theme_constant_override("separation", 7)
	var ic := _icon_texture_rect(icon, Vector2(30, 30), color)
	ic.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(ic)
	var l := _label(value, FONT_CELL_BIG, color, HORIZONTAL_ALIGNMENT_LEFT)
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	h.add_child(l)
	return h


# Small captioned stat (UPG / FISH / DAY) — value on top, tiny label beneath.
func _hs_mini_stat(caption: String, value: String, color: Color) -> Control:
	var v := VBoxContainer.new()
	v.custom_minimum_size = Vector2(64, 0)
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	v.add_theme_constant_override("separation", 0)
	var val := _label(value, FONT_CELL, color, HORIZONTAL_ALIGNMENT_CENTER)
	val.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(val)
	var cap := _label(caption, FONT_SMALL - 2, TEXT_DIM, HORIZONTAL_ALIGNMENT_CENTER)
	cap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(cap)
	return v


# Mode + outcome chip on the right edge (gold champion / red sunk / cyan otherwise).
func _hs_result_chip(outcome: String, is_vs: bool) -> Control:
	var accent := CYAN
	if outcome == "CHAMPION!":
		accent = GOLD
	elif outcome == "SUNK!" or outcome == "DEFEATED":
		accent = RED
	var mode_text := "VS" if is_vs else "SOLO"
	var text := mode_text if outcome == "" else "%s · %s" % [mode_text, outcome]
	var chip := PanelContainer.new()
	chip.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var s := _styled(BG_PANEL_DARK.lerp(accent, 0.14), accent, 2, 9)
	s.content_margin_left = 13
	s.content_margin_right = 13
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	chip.add_theme_stylebox_override("panel", s)
	var l := _label(text, FONT_BODY, accent, HORIZONTAL_ALIGNMENT_CENTER)
	chip.add_child(l)
	return chip


func _render_high_scores_screen(scores: Array, title_text: String, status_text: String = "") -> void:
	if ui.has("high_scores_title"):
		(ui["high_scores_title"] as Label).text = title_text
	if ui.has("high_scores_status"):
		var status_lbl: Label = ui["high_scores_status"]
		status_lbl.text = status_text
		status_lbl.visible = status_text != ""

	var col: VBoxContainer = ui["high_scores_col"]
	for child in col.get_children():
		child.queue_free()

	if scores.is_empty():
		var empty_card := PanelContainer.new()
		empty_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var es := _styled(REF_CARD_NAVY.darkened(0.12), Color(REF_BORDER.r, REF_BORDER.g, REF_BORDER.b, 0.4), 2, 12)
		es.content_margin_top = 40
		es.content_margin_bottom = 40
		empty_card.add_theme_stylebox_override("panel", es)
		col.add_child(empty_card)
		var empty := _label("No voyages logged yet — cast off and set a score!", FONT_CELL, TEXT_MUTED, HORIZONTAL_ALIGNMENT_CENTER)
		empty.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		empty_card.add_child(empty)
		return

	for i in range(scores.size()):
		var entry: Dictionary = scores[i]
		var rank := i + 1
		var is_top := rank <= 3

		var card := PanelContainer.new()
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var fill := REF_CARD_NAVY.lightened(0.10) if rank == 1 else (REF_CARD_NAVY if is_top else REF_CARD_NAVY.darkened(0.20))
		var border := GOLD if rank == 1 else (REF_BORDER if is_top else Color(REF_BORDER.r, REF_BORDER.g, REF_BORDER.b, 0.42))
		var bw := 4 if rank == 1 else (3 if is_top else 2)
		var cs := _styled_shadow(fill, border, bw, 12, 3)
		cs.content_margin_left = 12
		cs.content_margin_right = 14
		cs.content_margin_top = 10
		cs.content_margin_bottom = 10
		card.add_theme_stylebox_override("panel", cs)
		col.add_child(card)

		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 14)
		card.add_child(row)

		row.add_child(_hs_rank_badge(rank))

		# The ranking metric leads the row — this is the number the list sorts by.
		# (Trend-arrow icon: white-fill, so the gold tint applies cleanly.)
		row.add_child(_hs_stat_block(ICON_MOVES_TEXTURE, _format_thousands(_entry_season_score(entry)), GOLD if is_top else GOLD.darkened(0.12), 138))

		var t_count := int(entry.get("trophies", 0))
		row.add_child(_hs_stat_block(ICON_TROPHY_SOLID, "%d" % t_count, GOLD, 84))

		var money_val := int(entry.get("money", 0))
		var money_color := GREEN.lightened(0.08) if is_top else TEXT_PRIMARY
		row.add_child(_hs_stat_block(ICON_FUNDS_TEXTURE, "$%s" % _format_thousands(money_val), money_color, 140))

		row.add_child(_hs_mini_stat("UPG", "%d" % int(entry.get("upgrade_total", 0)), CYAN if is_top else TEXT_MUTED))
		row.add_child(_hs_mini_stat("FISH", "%d" % _entry_fish_count(entry), TEXT_PRIMARY if is_top else TEXT_MUTED))
		row.add_child(_hs_mini_stat("DAY", "%d/%d" % [int(entry.get("day", 0)), int(entry.get("season_days", 14))], TEXT_MUTED))

		var spacer := Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(spacer)

		var is_vs := str(entry.get("mode", MODE_SOLO)) == MODE_VERSUS
		row.add_child(_hs_result_chip(str(entry.get("outcome", "")), is_vs))


func _return_from_high_scores() -> void:
	_hide_high_scores_screen()
	_show_start_screen()


func _hide_high_scores_screen() -> void:
	if ui.has("high_scores_overlay"):
		(ui["high_scores_overlay"] as Control).visible = false
