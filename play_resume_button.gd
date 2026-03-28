extends Button

func _on_mouse_entered() -> void:
	globals.play_click.emit()
