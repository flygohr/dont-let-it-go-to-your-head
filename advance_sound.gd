extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_advance.connect(play_advance)

func play_advance() -> void:
	play()
