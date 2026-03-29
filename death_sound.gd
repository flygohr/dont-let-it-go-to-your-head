extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_death_sound.connect(play_death_sound)

func play_death_sound() -> void:
	play()
