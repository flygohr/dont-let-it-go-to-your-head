extends Node2D

@onready var message_screen_label: Label = $MessageScreenLabel
@onready var message_screen_text: Label = $MessageScreenText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.display_message.connect(_display_message)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _display_message(title, text):
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0,0), 0.2)
	# move game screen out from here?
	message_screen_label.text = title
	message_screen_text.text = text


func _on_continue_button_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(-160,0), 0.2)
