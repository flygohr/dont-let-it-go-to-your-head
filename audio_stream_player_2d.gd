extends AudioStreamPlayer2D

var is_audio_playing: bool = true

var master_bus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.toggle_audio.connect(toggle_audio)
	globals.lower_volume.connect(lower_volume)
	globals.reset_volume.connect(reset_volume)
	master_bus = AudioServer.get_bus_index("Master")

func toggle_audio() -> void:
	if is_audio_playing == true:
		AudioServer.set_bus_mute(master_bus,true)
		is_audio_playing = false
	else:
		AudioServer.set_bus_mute(master_bus,false)
		is_audio_playing = true


func _on_finished() -> void:
	play()

func lower_volume() -> void:
	volume_db = -8
	
func reset_volume() -> void:
	volume_db = -2
