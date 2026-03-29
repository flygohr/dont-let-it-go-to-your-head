extends AudioStreamPlayer2D

func _ready() -> void:
	globals.play_success_sound.connect(play_success_sound)

func play_success_sound() -> void:
	await get_tree().create_timer(0.3).timeout
	play()
