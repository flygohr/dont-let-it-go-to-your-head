extends Node2D

# generation parameters need to go here, as dictionary

var theft_probability: int = 40

var generation_parameters: Dictionary = {
	"Theft" : {
		"1": {
			"name": "Pickpocketing",
			"infamy": +10,
			"hunger": 0,
			"health": 0,
			"coin": +5
		},
		"2": {
			"name": "Rob food vendor",
			"infamy": +20,
			"hunger": -20,
			"health": 0,
			"coin": 0
		}
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# randomly generate cards, and append them to globals.card_list dict
	
	for i in (globals.starting_cards): # adjust logic to account for pre-existing game / resuming
		print_debug("Generating a card")
		var card_data: Dictionary = globals.default_card_data
		
		
		
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
