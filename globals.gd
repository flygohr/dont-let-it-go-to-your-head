extends Node

# day / night system one day
# var bg_color_day: Color = Color.html("#80592e")
# var bg_color_night: Color = Color.html("#302b25")

var hunger: int = 0
var health: int = 100
var infamy: int = 0
var coin: int = 5

var lives: int = 3

var tutorial_played: bool = false

const save_file_name: String = "user://dligtyh_save_16.json"

var is_mobile: bool = false

var default_card_data: Dictionary = {
	"name": "Very long card name",
	"type": "Theft",
	"rarity": "common",
	"effect": {
		"infamy": 0,
		"hunger": 0,
		"health": 0,
		"coin": 0
	}
}

var default_card_data_new: Dictionary =  {
	"name": "placeholder",
	"type": "theft", # I know it's redundant, but idk how else to structure the data and I don't want to waste all day on this
	"rarity": "common",
	"effect": {
		"infamy": {
			"min": -1,
			"max": 1
		},
		"hunger": {
			"min": -1,
			"max": 1
		},
		"health": {
			"min": -1,
			"max": 1
		},
		"coin": {
			"min": -1,
			"max": 1
		}
	}
}

var default_event_data: Dictionary = {
	"name": "ALL QUIET",
	"text": "Nothing unusual...",
	"effect": {
		"infamy": 0,
		"hunger": 0,
		"health": 0,
		"coin": 0
	}
}

var default_save_data: Dictionary = {
	"high_score_weeks": 0,
	"high_score_days": 0,
	"lives": 3,
	"current_week": 0,
	"current_day": 1,
	"time_of_day": "Day",
	"hunger": 0,
	"health": 100,
	"infamy": 0,
	"coin": 5,
	"current_cards": [default_card_data,default_card_data,default_card_data],
	"new_game": true,
	"current_event": default_event_data,
	"tutorial_played": false
}

const hunger_gained_per_day: int = 10

var high_score_weeks: int = 0
var high_score_days: int = 0

var current_week: int = 0
var current_day: int = 1

var color_green: String = "#A6F043"
var color_yellow: String = "#ca7c3b"
var color_red: String = "#ff1b18"

var color_legendary: Color = Color.html("#fcb100")
var color_epic: Color = Color.html("#ae4fce")
var color_rare: Color = Color.html("#4fa1d9")
var color_uncommon: Color = Color.html("#3ec427")
var color_common: Color = Color.html("#ffffff")

var color_hover: Color = Color.html("#e6dac5")
var color_select: Color = Color.html("#9c4429")

var color_progress_green: Color = Color.html("#96c359")
var color_progress_yellow: Color = Color.html("#ca7c3b")
var color_progress_red: Color = Color.html("#9c4429")

var card_bg_theft: Color = Color.html("#ca7c3b")
var card_bg_rest: Color = Color.html("#7899bf")
var card_bg_move: Color = Color.html("#606a40")
var card_bg_event: Color = Color.html("#7a6260")

var current_screen: String = "title"

var cards_list: Array = []

var current_event: Dictionary = {}

# signal bus
@warning_ignore_start("unused_signal")

signal card_selected(node)
signal generate_cards()
signal populate_card_slot()
signal apply_effect()
signal not_enough_gold()
signal change_confirm_text(text: String)
signal pick_event()
signal play_death(title: String, text: String) # https://github.com/godotengine/godot-docs-user-notes/discussions/5#discussioncomment-8124099
signal display_message(title: String, text: String)
signal enable_confirm_button()
signal disable_confirm_button()
signal render_event()
signal advance_day()
signal play_tutorial()
signal move_game_screen_away()
signal move_game_screen_in()
