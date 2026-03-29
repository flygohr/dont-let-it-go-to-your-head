extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_failure_sound.connect(play_failure_sound)

func play_failure_sound() -> void:
	await get_tree().create_timer(0.2).timeout
	play()
