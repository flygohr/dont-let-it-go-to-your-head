extends AudioStreamPlayer2D

var is_audio_playing: bool = true

var master_bus

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.toggle_audio.connect(toggle_audio)
	master_bus = AudioServer.get_bus_index("Master")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_audio() -> void:
	if is_audio_playing == true:
		AudioServer.set_bus_mute(master_bus,true)
		is_audio_playing = false
	else:
		AudioServer.set_bus_mute(master_bus,false)
		is_audio_playing = true
