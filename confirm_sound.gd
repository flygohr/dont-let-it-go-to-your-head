extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_confirm.connect(play_confirm)

func play_confirm() -> void:
	play()
