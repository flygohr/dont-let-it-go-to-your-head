extends Node2D

# generation parameters need to go here, as dictionary

var base_infamy:int = 10
var base_hunger:int = 10
var base_health:int = 10
var base_coin:int = 1

var card_data:Dictionary = {}

var card_data_file: String = "res://assets/all-cards.json"

var theft_cards: Array = [
	{
		"name": "Pickpocketing",
		"infamy": [1,3],
		"hunger": [0,0],
		"health": [0,0],
		"coin": [1,3]
	},
	{
		"name": "Rob food vendor",
		"infamy": [2,5],
		"hunger": [-2,-5],
		"health": [0,0],
		"coin": [0,0]
	},
	{
		"name": "Rob a church",
		"infamy": [3,6],
		"hunger": [0,2],
		"health": [0,0],
		"coin": [10,30]
	}	
]

var rest_cards: Array = [
	{
		"name": "Soup kitchen",
		"infamy": [0,0],
		"hunger": [-1,-3],
		"health": [0,0],
		"coin": [0,0]
	},
	{
		"name": "Cheap Laech",
		"infamy": [0,0],
		"hunger": [0,0],
		"health": [1,3],
		"coin": [-1,-10]
	},
	{
		"name": "Good samaritan",
		"infamy": [0,0],
		"hunger": [-1,-1],
		"health": [0,0],
		"coin": [1,5]
	}
]

var move_cards: Array = [
	{
		"name": "Move town",
		"infamy": [-2,-4],
		"hunger": [1,3],
		"health": [0,-1],
		"coin": [-10,-50]
	},
	{
		"name": "Move principality",
		"infamy": [-4,-8],
		"hunger": [2,4],
		"health": [-2,-4],
		"coin": [-20,-100]
	},
	{
		"name": "Move kingdom",
		"infamy": [-6,-10],
		"hunger": [4,8],
		"health": [-3,-6],
		"coin": [-50,-200]
	}
]

var new_card_data: Dictionary = {
	"common": {
		"theft": [],
		"rest": [],
		"move": [],
		"event": []
	},
	"uncommon": {
		"theft": [],
		"rest": [],
		"move": [],
		"event": []
	},
	"rare": {
		"theft": [],
		"rest": [],
		"move": [],
		"event": []
	},
	"epic": {
		"theft": [],
		"rest": [],
		"move": [],
		"event": []
	},
	"legendary": {
		"theft": [],
		"rest": [],
		"move": [],
		"event": []
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.generate_cards.connect(generate_new_cards)
	
	load_card_data()

func generate_new_cards() -> void:
	
	# in the future, implement better rarity. for now it could be simplified as number of positive effects, if 4 is rare. the rest of the card can be generated randomly
	
	# check for softlock with a while loop
	print("Generating new cards")
	globals.cards_list.clear()
	
	var not_enough_gold_cards: int = 0
	
	for i in (3):
		card_data = globals.default_card_data_new.duplicate()
		
		# pick card rarity
		var picked_rarity: String = pick_card_rarity()
		var picked_type: String = pick_card_type()
		
		var picked_list: Array = new_card_data[picked_rarity][picked_type] # should return an Array
		# pick random from types
		var picked_card: Dictionary = picked_list.pick_random()
		
		card_data["rarity"] = picked_card["rarity"]
		card_data["type"] = picked_card["type"]
		card_data["name"] = picked_card["name"]
		
		var picked_card_effects: Dictionary = picked_card["effect"]
		
		
		card_data["effect"]["infamy"] = base_infamy*round(randf_range(picked_card_effects["infamy"]["min"],picked_card_effects["infamy"]["max"]))
		card_data["effect"]["hunger"] = base_hunger*round(randf_range(picked_card_effects["hunger"]["min"],picked_card_effects["hunger"]["max"]))
		card_data["effect"]["health"] = base_health*round(randf_range(picked_card_effects["health"]["min"],picked_card_effects["health"]["max"]))
		card_data["effect"]["coin"] = base_coin*round(randf_range(picked_card_effects["coin"]["min"],picked_card_effects["coin"]["max"]))
		# print(card_data)
		globals.cards_list.push_back(card_data.duplicate_deep())
		
		if ((globals.coin + card_data["effect"]["coin"]) <0 ): not_enough_gold_cards += 1
		
		# print(globals.cards_list)
	
	#check for gold softlock, and re-do the generation if needed
	
	if (not_enough_gold_cards < 3): globals.populate_card_slot.emit()
	else: 
		globals.generate_cards.emit()
		print("Preventing softlock, generating cards again")

func load_card_data() -> void:
	var data_file = FileAccess.open(card_data_file, FileAccess.READ)
	var parsed_data: Array = JSON.parse_string(data_file.get_as_text())
	
	# to achieve, I need to export the CSV as an arrayed JSON, find the link back here
	# then, knowing the position of each item in the array, build the dictionary row by row
	
	# now, for each row of the imported data, I "append" (with duplicate_deep) an object that is each card
	for x in parsed_data:
		var parsed_card_data = globals.default_card_data_new.duplicate_deep()
		parsed_card_data["rarity"] = x[0]
		parsed_card_data["type"] = x[1].to_lower() # temporary case fix
		parsed_card_data["name"] = x[2]
		parsed_card_data["effect"]["infamy"]["min"] = x[3]
		parsed_card_data["effect"]["infamy"]["max"] = x[4]
		parsed_card_data["effect"]["hunger"]["min"] = x[5]
		parsed_card_data["effect"]["hunger"]["max"] = x[6]
		parsed_card_data["effect"]["health"]["min"] = x[7]
		parsed_card_data["effect"]["health"]["max"] = x[8]
		parsed_card_data["effect"]["coin"]["min"] = x[9]
		parsed_card_data["effect"]["coin"]["max"] = x[10]
		# print(parsed_card_data) card has been parsed successfully

		new_card_data[parsed_card_data["rarity"]][parsed_card_data["type"]].append(parsed_card_data.duplicate_deep())

	# print(new_card_data) data has been correctly loaded

func pick_card_rarity() -> String:
	var picker: float = randf()
	
	if picker < 0.6: return "common"
	elif picker >= 0.6 and picker < 0.85: return "uncommon"
	elif picker >= 0.85 and picker < 0.95: return "rare"
	elif picker >= 0.95 and picker < 0.99: return "epic"
	else: return "legendary"

func pick_card_type() -> String:
	var picker: float = randf()
	
	if picker < 0.3: return "theft"
	elif picker >= 0.3 and picker < 0.6: return "rest"
	elif picker >= 0.6 and picker < 0.8: return "event"
	else: return "move"
