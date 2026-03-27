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
@onready var inner_rect: ColorRect = $CardIconRect/InnerRect

@onready var sprite_theft = preload("res://assets/imgs/DLIGTYH_pixelart_theft.png")
@onready var sprite_rest = preload("res://assets/imgs/DLIGTYH_pixelart_rest.png")
@onready var sprite_move = preload("res://assets/imgs/DLIGTYH_pixelart_move.png")
@onready var sprite_event = preload("res://assets/imgs/DLIGTYH_pixelart_event.png")
@onready var card_img: Sprite2D = $CardIconRect/CardImg

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
		health_text = str("[color=",globals.color_red,"]",health_data,"[/color] HEALTH") # color red
		text_bits.append(health_text)
	elif (health_data > 0):
		health_text = str("[color=",globals.color_green,"]+",health_data,"[/color] HEALTH") # color green
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
	
	match card_data["type"]:
		"theft": 
			#icon.text = "T"
			inner_rect.color = globals.card_bg_theft
			card_img.texture = sprite_theft
		"rest": 
			#icon.text = "R"
			inner_rect.color = globals.card_bg_rest
			card_img.texture = sprite_rest
		"move": 
			#icon.text = "M"
			inner_rect.color = globals.card_bg_move
			card_img.texture = sprite_move
		"event": 
			#icon.text = "E"
			inner_rect.color = globals.card_bg_event
			card_img.texture = sprite_event
		
	
	# define rarity based on specs
	set_border_color(data["rarity"])
	print(str("The card that has been built is: ", card_data)) 
	card_data = card_data.duplicate_deep()

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

func _on_card_collision_mouse_entered() -> void:
	if globals.is_mobile == false:
		hover = true	
	else:
		hover = true
		select_this()

func _on_card_collision_mouse_exited() -> void:
	if globals.is_mobile == false:
		hover = false

func _on_card_collision_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if globals.is_mobile == false:
		if Input.is_action_just_released("mouseLeft"):
			if (select == false):
				select_this()
			else:
				unselect_this()
			
func select_this() -> void:
	select = true
	globals.card_selected.emit(self)
	
	# check if enough gold
	if (card_data["effect"]["coin"] < 0):
		if ((globals.coin + card_data["effect"]["coin"]) < 0):
			print(str(globals.coin + card_data["effect"]["coin"]))
			globals.change_confirm_text.emit(str("[color=",globals.color_red,"]Not enough COIN![/color]"))
			globals.disable_confirm_button.emit()
		else:
			globals.enable_confirm_button.emit()
			globals.change_confirm_text.emit("Are you sure?")	
	else:
		globals.enable_confirm_button.emit()
		globals.change_confirm_text.emit("Are you sure?")
		
func unselect_this() -> void:
	globals.change_confirm_text.emit("Pick a card")
	select = false
	globals.disable_confirm_button.emit()
	
func _card_selected(node) -> void:
	# unselect if not the current card being hovered
	if globals.is_mobile == false:
		if (hover == false):
			select = false
		else: 
			print(str("Selected card data is: ", card_data)) 
	else: # if it's mobile:
		# I need to deselect all the cards that are not the last one touched, but leave the last one touched alone even if I click away
		# easy! I do a flip!
		if self != node: 
			select = false
			hover = false

func _execute_effect() -> void:

	if select == true: # only if this is the card selected
		
		# special card effects here, one day
		
		
		print(str("Applying this card's effects: ", card_data))
		
		# apply hunger-----------------------------------------------------
		
		#if(globals.current_day < 7 and globals.time_of_day == "Night"):
			#globals.hunger = clamp((globals.hunger + globals.hunger_gained_per_day),0,100)
			#print("Increasing hunger for the new day") / add a message clerly displaying this somewhere. or scrap the mechanic completely, or leave it to an event, like "hunger" -30 hunger incoming

		var hunger_value = card_data["effect"]["hunger"]
		print(str("Hunger effect of applied card is ",hunger_value))
			
		if hunger_value != 0:

			globals.hunger = clamp((globals.hunger + hunger_value),0,100)
				
			if globals.hunger == 100: globals.play_death.emit("YOU DIED","You starved to death.")
		
		# apply health -----------------------------------------------------	
		
		var health_value = card_data["effect"]["health"]
		print(str("Health effect of applied card is ",health_value))
		
		if health_value != 0:

			globals.health = clamp((globals.health + health_value),0,100)
			
			if globals.health == 0: globals.play_death.emit("YOU DIED","Disease and sickness got you first")
		
		# apply coin --------------------------------------------------------
		
		var coin_value = card_data["effect"]["coin"]
		print(str("Coin effect of applied card is ",coin_value))
		
		if coin_value != 0:

			globals.coin = clamp((globals.coin + coin_value),0,999)
		
		
				# apply infamy-----------------------------------------------------
		
		var infamy_value = card_data["effect"]["infamy"]
		print(str("Infamy effect of applied card is ",infamy_value))
		
		# the effect from the textbox event needs to be applied to the picked card, not globally
		# each check should apply only if value not 0! AND
		# if it's a bonus to a negative trait, it cannot go above 0 and become a net bonus
		# if it's a debuff to a positive trait, it cannot go below 0 and become a net negative

		if infamy_value != 0:
			
			if (globals.lives == 3):
							
				globals.infamy = clamp((globals.infamy + infamy_value),0,100)
				
				if (globals.infamy == 100):
					globals.infamy = 20
					globals.lives -= 1
					globals.display_message.emit("CAUGHT!","You lost a couple of fingers, the penalty for theft. Your infamy's baseline is now 20.")
					globals.advance_day.emit()
			elif (globals.lives == 2):
				

				globals.infamy = clamp((globals.infamy + infamy_value),20,100)
				
				if (globals.infamy == 100):
					globals.infamy = 50
					globals.lives -= 1
					globals.display_message.emit("CAUGHT AGAIN!","They cut off your left ear, the penalty for repeated theft. Your infamy's baseline is now 50. This is the last warning. They'll want your head if they get you another time!")
					globals.advance_day.emit()
			elif (globals.lives == 1):
				
				globals.infamy = clamp((globals.infamy + infamy_value),50,100)
				
				if (globals.infamy == 100):
					globals.play_death.emit("DECAPITATED","It got to your head in the end.")
		
		
		globals.check_quest.emit(infamy_value, hunger_value, health_value, coin_value)
		
		select = false
	
