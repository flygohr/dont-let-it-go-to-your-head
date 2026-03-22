extends Node2D

const DLIGTYH_PIXELART_EAR_1 = preload("uid://l4gcd2r10unx")
const DLIGTYH_PIXELART_EAR_2 = preload("uid://cnnpg2w00810q")
const DLIGTYH_PIXELART_EVENT = preload("uid://kt1hgxmroq7y")
const DLIGTYH_PIXELART_FINGER_1 = preload("uid://bli67cirmuypy")
const DLIGTYH_PIXELART_FINGER_2 = preload("uid://c5qvfq64bksmf")
const DLIGTYH_PIXELART_HEAD = preload("uid://thi2nn2ukgxo")

@onready var ear_life: Sprite2D = $EarLife
@onready var finger_life: Sprite2D = $FingerLife
@onready var head_life: Sprite2D = $HeadLife

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match globals.lives:
		3: 
			finger_life.texture = DLIGTYH_PIXELART_FINGER_1
			ear_life.texture = DLIGTYH_PIXELART_EAR_1
		2: 
			finger_life.texture = DLIGTYH_PIXELART_FINGER_2
			ear_life.texture = DLIGTYH_PIXELART_EAR_1
		1: 
			finger_life.texture = DLIGTYH_PIXELART_FINGER_2
			ear_life.texture = DLIGTYH_PIXELART_EAR_2
