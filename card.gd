extends Node2D

@onready var background_select: Control = $BackgroundSelect
@onready var selection_rect_1: ColorRect = $BackgroundSelect/Rect1
@onready var selection_rect_2: ColorRect = $BackgroundSelect/Rect2
@onready var background_hover: Control = $BackgroundHover
@onready var hover_rect_1: ColorRect = $BackgroundHover/Rect1
@onready var hover_rect_2: ColorRect = $BackgroundHover/Rect2

@onready var rect_1_border: ColorRect = $BackgroundRect/Rect1
@onready var outer_rect: ColorRect = $CardIconRect/OuterRect

@onready var card_name: Label = $CardName
@onready var card_text: RichTextLabel = $CardText
@onready var icon: Label = $CardIconRect/Icon

@export var card_number_in_stack: int = 0

var rarity: String = "common"

var hover: bool = false
var select: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selection_rect_1.color = globals.color_select
	selection_rect_2.color = globals.color_select
	hover_rect_1.color = globals.color_hover
	hover_rect_2.color = globals.color_hover
	globals.card_selected.connect(_card_selected)
	
	# https://stackoverflow.com/questions/77360041/how-to-connect-a-signal-with-extra-arguments-in-godot-4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (globals.current_screen == "game"):
		if (hover == true):
			background_hover.show()
		else:
			background_hover.hide()
			
		if (select == true):
			background_select.show()
		else:
			background_select.hide()
			
		if (hover == true and select == true):
			hover_rect_1.color = globals.color_select
			hover_rect_2.color = globals.color_select
		else:
			hover_rect_1.color = globals.color_hover
			hover_rect_2.color = globals.color_hover
			
	build_card(globals.cards_list[card_number_in_stack-1]) # move this to a signal call to make sure it runs when data is available

func build_card(data: Dictionary) -> void:
	var card_data: Dictionary = globals.default_card_data
	card_data["name"] = data["name"]
	card_name.text = data["name"].to_upper()
	
	card_data["type"] = data["type"]
	
	card_data["effect"] = data["effect"]
	
	# if effect is present, render it at text. then color code and join the text together
	
	# infamy bit
	var infamy_data: int = data["effect"]["infamy"]
	var is_there_infamy: bool = false
	var infamy_text: String = ""
	if (infamy_data == 0):
		pass
	elif (infamy_data > 0):
		is_there_infamy = true
		infamy_text = str("INFAMY [color=",globals.color_red,"]+",infamy_data,"[/color]") # color red
	elif (infamy_data < 0):
		is_there_infamy = true
		infamy_text = str("INFAMY [color=",globals.color_green,"]",infamy_data,"[/color]") # color green
		
	var card_text_content = str(
		infamy_text
	)
	
	card_text.text = card_text_content
	
	if(card_data["type"] == "Theft"):
		icon.text = "T"
	
	# define rarity based on specs
	set_border_color(data["rarity"])

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
	card_name.set("theme_override_colors/font_color", color)

func change_selection_outline_color() -> void:
	pass

func _on_card_collision_mouse_entered() -> void:
	hover = true

func _on_card_collision_mouse_exited() -> void:
	hover = false

func _on_card_collision_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_released("mouseLeft"):
		if (select == false):
			select_this()
		else:
			unselect_this()
			
func select_this() -> void:
	select = true
	hover = true
	globals.card_selected.emit()
	globals.can_proceed = true
	
func unselect_this() -> void:
	select = false
	globals.can_proceed = false
	
func _card_selected() -> void:
	# unselect if not the current card being hovered
	if (hover == false):
		select = false
