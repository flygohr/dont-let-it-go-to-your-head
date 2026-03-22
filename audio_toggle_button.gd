extends TextureButton

const DLIGTYH_PIXELART_TOGGLE_AUDIO_1 = preload("uid://b6giijpp7ahb")
const DLIGTYH_PIXELART_TOGGLE_AUDIO_2 = preload("uid://c6hu6obbc513m")
const DLIGTYH_PIXELART_TOGGLE_AUDIO_3 = preload("uid://d4gd5yd5ryqqq")
const DLIGTYH_PIXELART_TOGGLE_AUDIO_4 = preload("uid://coujhgiuh0hn2")

var toggle = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_pressed() -> void:
	globals.toggle_audio.emit()
	if toggle == true:
		texture_normal = DLIGTYH_PIXELART_TOGGLE_AUDIO_1
		texture_focused = DLIGTYH_PIXELART_TOGGLE_AUDIO_2
		texture_hover = DLIGTYH_PIXELART_TOGGLE_AUDIO_2
		texture_pressed = DLIGTYH_PIXELART_TOGGLE_AUDIO_2
		toggle = false
	else:
		texture_normal = DLIGTYH_PIXELART_TOGGLE_AUDIO_3
		texture_focused = DLIGTYH_PIXELART_TOGGLE_AUDIO_4
		texture_hover = DLIGTYH_PIXELART_TOGGLE_AUDIO_4
		texture_pressed = DLIGTYH_PIXELART_TOGGLE_AUDIO_4
		toggle = true
