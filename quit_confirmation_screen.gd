extends Node2D

var is_screen_out: bool = false

@onready var game_screen: Node2D = $"../GameScreen"
@onready var text_next_to_button: RichTextLabel = $"../GameScreen/BottomSection/TextNextToButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.toggle_quit_screen.connect(toggle_screen)

func toggle_screen() -> void:
	if is_screen_out == false:
		position = Vector2(0,160)
		var tween = get_tree().create_tween()
		tween.tween_property(game_screen, "position", Vector2(0,-160), 0.2)
		var tween_b = get_tree().create_tween()
		tween_b.tween_property(self, "position", Vector2(0,0), 0.2)
		is_screen_out = true
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(game_screen, "position", Vector2(0,0), 0.2)
		var tween_b = get_tree().create_tween()
		tween_b.tween_property(self, "position", Vector2(0,160), 0.2)
		is_screen_out = false

func _on_no_pressed() -> void:
	globals.toggle_quit_screen.emit()

func _on_yes_pressed() -> void:
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(self, "position", Vector2(0,-160), 0.2)
	is_screen_out = false
	text_next_to_button.text = str("Pick a card")
	globals.play_death.emit("GAME OVER","You can always try again...")
