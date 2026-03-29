extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_restart_sound.connect(play_restart_sound)

func play_restart_sound() -> void:
	play()
