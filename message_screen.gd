extends Node2D

@onready var message_screen_label: Label = $MessageScreenLabel
@onready var message_screen_text: Label = $MessageScreenText
@onready var continue_button: Button = $ContinueButton

var tutorial: Array = [
	["YOU ARE A THIEF...","...and you are stuck in medieval Europe. You constantly risk starving to death or succumbing to incurable disease. But, most importantly, you are always on the lookout for the executioner..."],
	["PICK YOUR OPTIONS","You struggle to get by, and your days don't have much choice. Every day, you'll be presented with three cards that will affect your INFAMY, HUNGER, HEALTH and COIN."],
	["INFAMY","If your INFAMY reaches 100, the executioner will get you! First offenders will get their finger cut off. Repeat offenders lose an ear. And if you get caught after that.. they'll get to your head!"],
	["DEATH","Aside from losing your head, you can also die of starvation when your HUNGER reaches 100, or by disease if your HEALTH reaches 0."],
	["YOUR OBJECTIVE","Survive as long as you can! Some days will not be like the others, and will apply modifiers to the card you pick. Use them to offset some of the tougher choices..."]
]

var tutorial_slide: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.display_message.connect(_display_message)
	globals.play_tutorial.connect(play_tutorial)

func _display_message(title, text):
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "position", Vector2(0,0), 0.2)
	position = Vector2(0,0)
	# move game screen out from here?
	message_screen_label.text = title
	message_screen_text.text = text

func _on_continue_button_pressed() -> void:
	globals.play_confirm.emit()
	if globals.tutorial_played == true:
		globals.move_game_screen_in.emit()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(240,0), 0.2)
		position = Vector2(240,0)
	else:
		play_tutorial()

func play_tutorial() -> void:
	if (tutorial_slide < (tutorial.size()-1)):
		_display_message(tutorial[tutorial_slide][0],tutorial[tutorial_slide][1])
		tutorial_slide += 1
	elif (tutorial_slide == (tutorial.size()-1)):
		_display_message(tutorial[tutorial_slide][0],tutorial[tutorial_slide][1])
		tutorial_slide += 1
		continue_button.text = "START PLAYING"
	else: 
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", Vector2(240,0), 0.2)
		position = Vector2(240,0)
		globals.tutorial_played = true
		globals.move_game_screen_in.emit()
		print("Finished tutorial")
		continue_button.text = "CONTINUE"
