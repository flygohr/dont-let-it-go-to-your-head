extends Node2D

@onready var middle_screen_bg_2: ColorRect = $MiddleScreenBG2
@onready var middle_screen_bg_3: ColorRect = $MiddleScreenBG3
@onready var text_section_copy: Label = $TextSectionCopy
@onready var text_section_title: Label = $TextSectionTitle

const events_pool: Array = [
	{
		"name": "BLACK MOON",
		"text": "No moon in the sky!\n-20 on INFAMY picks", #TODO: would be nice if it was color coded
		"effect": {
			"infamy": -20,
			"hunger": 0,
			"health": 0,
			"coin": 0
		},
	},
	{
		"name": "HUNGER",
		"text": "-10 HUNGER on day advance", #TODO: would be nice if it was color coded
		"effect": {
			"infamy": 0,
			"hunger": -10,
			"health": 0,
			"coin": 0
		}
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.pick_event.connect(_pick_event)
	globals.current_event = globals.default_event_data.duplicate_deep()
	render_event()

func _pick_event() -> void:
	var picked_event = events_pool.pick_random()
	globals.current_event = picked_event.duplicate_deep()
	render_event()

func render_event() -> void:
	text_section_title.text = globals.current_event["name"].to_upper()
	text_section_copy.text = globals.current_event["text"]
