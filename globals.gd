extends Node

var color_legendary: Color = Color.html("#fcb100")
var color_epic: Color = Color.html("#ae4fce")
var color_rare: Color = Color.html("#4fa1d9")
var color_uncommon: Color = Color.html("#3ec427")
var color_common: Color = Color.html("#ffffff")

var color_hover: Color = Color.html("#e6dac5")
var color_select: Color = Color.html("#9c4429")

var current_screen: String = "title"

var can_proceed = false

@warning_ignore_start("unused_signal")

signal card_selected()
