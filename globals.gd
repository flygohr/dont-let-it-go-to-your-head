extends Node

# day / night system one day
# var bg_color_day: Color = Color.html("#80592e")
# var bg_color_night: Color = Color.html("#302b25")


var color_green: String = "#A6F043"
var color_yellow: String = "#ca7c3b"
var color_red: String = "#FF2940"

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

var current_screen: String = "title"

var can_proceed = false

@warning_ignore_start("unused_signal")

signal card_selected()

var cards_list: Array = []
var starting_cards: int = 3
var current_cards: int = starting_cards

var default_card_data: Dictionary = {
	"name": "Very long card name",
	"type": "Theft",
	"effect": {
		"infamy": 0,
		"hunger": 0,
		"health": 0,
		"coin": 0
	}
}
