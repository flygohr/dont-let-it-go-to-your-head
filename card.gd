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

var card_data: Dictionary = globals.default_card_data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selection_rect_1.color = globals.color_select
	selection_rect_2.color = globals.color_select
	hover_rect_1.color = globals.color_hover
	hover_rect_2.color = globals.color_hover
	globals.card_selected.connect(_card_selected)
	globals.populate_card_slot.connect(_start_card_build)
	globals.apply_effect.connect(_execute_effect)
	
	# https://stackoverflow.com/questions/77360041/how-to-connect-a-signal-with-extra-arguments-in-godot-4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
			
func _start_card_build():
	build_card(globals.cards_list[card_number_in_stack-1])

func build_card(data: Dictionary) -> void:
	card_data["name"] = data["name"]
	card_name.text = data["name"].to_upper()
	
	card_data["type"] = data["type"]
	
	card_data["effect"] = data["effect"]
	
	# if effect is present, render it at text. then color code and join the text together
	var text_bits: Array = []
	# infamy bit
	var infamy_data: int = data["effect"]["infamy"]
	var infamy_text: String = ""
	if (infamy_data == 0):
		pass
	elif (infamy_data > 0):
		infamy_text = str("[color=",globals.color_red,"]+",infamy_data,"[/color] INFAMY") # color red
		text_bits.append(infamy_text)
	elif (infamy_data < 0):
		infamy_text = str("[color=",globals.color_green,"]",infamy_data,"[/color] INFAMY") # color green
		text_bits.append(infamy_text)
	
	# hunger bit
	var hunger_data: int = data["effect"]["hunger"]
	var hunger_text: String = ""
	if (hunger_data == 0):
		pass
	elif (hunger_data > 0):
		hunger_text = str("[color=",globals.color_red,"]+",hunger_data,"[/color] HUNGER") # color red
		text_bits.append(hunger_text)
	elif (hunger_data < 0):
		hunger_text = str("[color=",globals.color_green,"]",hunger_data,"[/color] HUNGER") # color green
		text_bits.append(hunger_text)
		
	# health bit
	var health_data: int = data["effect"]["health"]
	var health_text: String = ""
	if (health_data == 0):
		pass
	elif (health_data < 0):
		health_text = str("[color=",globals.color_red,"]+",health_data,"[/color] HEALTH") # color red
		text_bits.append(health_text)
	elif (health_data > 0):
		health_text = str("[color=",globals.color_green,"]",health_data,"[/color] HEALTH") # color green
		text_bits.append(health_text)
		
	# coin bit
	var coin_data: int = data["effect"]["coin"]
	var coin_text: String = ""
	if (coin_data == 0):
		pass
	elif (coin_data < 0):
		coin_text = str("[color=",globals.color_red,"]",coin_data,"[/color] [color=#ffd700]COIN[/color]") # color red
		text_bits.append(coin_text)
	elif (coin_data > 0):
		coin_text = str("[color=",globals.color_green,"]+",coin_data,"[/color] [color=#ffd700]COIN[/color]") # color green	
		text_bits.append(coin_text)
	
	# for loop to iterate over array of text bits
	var complete_text_content: String = ""
	match text_bits.size():
		0: pass
		1: complete_text_content = str(text_bits[0])
		2: complete_text_content = str(text_bits[0],", ",text_bits[1])
		3: complete_text_content = str(text_bits[0],", ",text_bits[1],", ",text_bits[2])
		4: complete_text_content = str(text_bits[0],", ",text_bits[1],", ",text_bits[2],", ",text_bits[3])
	
	card_text.text = complete_text_content
	
	if(card_data["type"] == "Theft"):
		icon.text = "T"
	
	# define rarity based on specs
	set_border_color(data["rarity"])
	# print(str("The card that has been built is: ", card_data)) DATA IS BUILT CORRECTLY

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

func _on_card_collision_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_released("mouseLeft"):
		if (select == false):
			select_this()
		else:
			unselect_this()
			
func select_this() -> void:
	select = true
	globals.card_selected.emit()
	
	#TODO can proceed only if enough gold. and now we move stats to global
	globals.can_proceed = true
	
func unselect_this() -> void:
	select = false
	globals.can_proceed = false
	
func _card_selected() -> void:
	# unselect if not the current card being hovered
	if (hover == false):
		select = false
	else:
		print(str("Selected card data is: ", card_data)) 
		#FIXME every card selected is the same, that's why it doesn't work. specifically, it's the last card that takes precedence
		#basically, every card is processing correctly? because every card actually has the data of the last one? when does the data get changed?
		# data is built correctly. the error is in the select check. it always point to card 3 for some reason?

func _execute_effect() -> void:

	if select == true: # only if this is the card selected
		# apply infamy
		
		print(str("Applying this card's effects: ", card_data))
		var infamy_value = card_data["effect"]["infamy"]
		print(str("Infamy effect of applied card is ",infamy_value))
		if (infamy_value > 0):
			globals.infamy = clamp((globals.infamy + infamy_value),0,100)
			if (globals.infamy == 100): globals.lives -= 1 #TODO: fullscreen warnings here
			if globals.lives == 0: globals.play_death.emit()
		elif (infamy_value < 0):
			globals.infamy = clamp((globals.infamy - infamy_value),0,100)
		
		# apply hunger-----------------------------------------------------
		
		if(globals.current_day < 7 and globals.time_of_day == "Night"):
			globals.hunger += globals.hunger_gained_per_day 
			print("Decreasing hunger for the new day")

		#if (card_data["effect"]["hunger"] > 0):
			#globals.hunger += card_data["effect"]["hunger"]
		#elif (card_data["effect"]["hunger"] < 0):
			#globals.hunger -= card_data["effect"]["hunger"]
		# -----------------------------------------------------------------	
	
		#if (card_data["effect"]["health"] > 0):
			#globals.health += card_data["effect"]["health"]
		#elif (card_data["effect"]["health"] < 0):
			#globals.health -= card_data["effect"]["health"]
			#
		#if (card_data["effect"]["coin"] > 0):
			#globals.coin += card_data["effect"]["coin"]
		#elif (card_data["effect"]["coin"] < 0):
			#globals.coin -= card_data["effect"]["coin"]
			
		#if (globals.hunger < 0): globals.hunger = 0 #clamp values
		#elif (globals.hunger >= 100): globals.play_death.emit()
		#
		#if (globals.health > 100): globals.health = 100 #clamp values
		#elif (globals.health <= 0): globals.play_death.emit()
		
		select = false
	
