extends Node2D

@onready var background_select: Control = $BackgroundSelect
@onready var selection_rect_1: ColorRect = $BackgroundSelect/Rect1
@onready var selection_rect_2: ColorRect = $BackgroundSelect/Rect2

@onready var rect_1_border: ColorRect = $BackgroundRect/Rect1
@onready var outer_rect: ColorRect = $CardIconRect/OuterRect

var rarity: String = "common"

var hover: bool = false
var select: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_border_color(rarity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (hover == true):
		background_select.show()
	elif (hover == false):
		background_select.hide()

func set_border_color(rarity_string) -> void:
	var color
	match rarity_string:
		"common":
			color = globals.color_common
		"uncommon":
			color = globals.color_uncommon
		"rare":
			color = globals.color_rare
		"epic":
			color = globals.color_epic
		"legendary":
			color = globals.color_legendary
		_:
			color = globals.color_common
	
	rect_1_border.color = color
	outer_rect.color = color

func change_selection_outline_color() -> void:
	pass


func _on_card_collision_mouse_entered() -> void:
	print_debug("mouse_entered")
	hover = true


func _on_card_collision_mouse_exited() -> void:
	print_debug("mouse_exited")
	hover = false
