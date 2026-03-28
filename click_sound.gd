extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_click.connect(play_click)

func play_click() -> void:
	play()
