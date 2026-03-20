extends Node2D

# generation parameters need to go here, as dictionary

var base_infamy:int = 5
var base_hunger:int = 5
var base_health:int = 5
var base_coin:int = 1

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.generate_cards.connect(generate_new_cards)


func generate_new_cards() -> void:
	
	# in the future, implement better rarity. for now it could be simplified as number of positive effects, if 4 is rare. the rest of the card can be generated randomly
	
	print("Generating new cards")
	globals.cards_list.clear()
	for i in (3):
		var card_data: Dictionary = globals.default_card_data.duplicate()
		var temp_rarity: int = 0
		
		var picked_list = [theft_cards, rest_cards, move_cards].pick_random()
		var picked_card = picked_list.pick_random()
		
		card_data["name"] = picked_card["name"]
		
		# calculate infamy and score rarity
		if(picked_card["infamy"][0] != 0 and picked_card["infamy"][1] != 0):
			card_data["effect"]["infamy"] = base_infamy*round(randf_range(picked_card["infamy"][0],picked_card["infamy"][1]))
		else:
			card_data["effect"]["infamy"] = 0
		
		if(card_data["effect"]["infamy"] < 0):
			temp_rarity += 1
		
		# calculate hunger and score rarity
		if(picked_card["hunger"][0] != 0 and picked_card["hunger"][1] != 0):
			card_data["effect"]["hunger"] = base_hunger*round(randf_range(picked_card["hunger"][0],picked_card["hunger"][1]))
		else:
			card_data["effect"]["hunger"] = 0
		
		if(card_data["effect"]["hunger"] < 0):
			temp_rarity += 1
		
		# calculate health and score rarity
		if(picked_card["health"][0] != 0 and picked_card["health"][1] != 0):
			card_data["effect"]["health"] = base_health*round(randf_range(picked_card["health"][0],picked_card["health"][1]))
		else:
			card_data["effect"]["health"] = 0
		
		if(card_data["effect"]["health"] > 0):
			temp_rarity += 1			
		
		# calculate coin and score rarity
		if(picked_card["coin"][0] != 0 and picked_card["coin"][1] != 0):
			card_data["effect"]["coin"] = base_coin*round(randf_range(picked_card["coin"][0],picked_card["coin"][1]))
		else:
			card_data["effect"]["coin"] = 0
		
		if(card_data["effect"]["coin"] > 0):
			temp_rarity += 1	
		
		match temp_rarity:
			1: card_data["rarity"] = "common"
			2: card_data["rarity"] = "uncommon"
			3: card_data["rarity"] = "rare"
			4: card_data["rarity"] = "epic"
				
		# print(card_data)
		globals.cards_list.push_back(card_data.duplicate_deep())
		# print(globals.cards_list)
	
	#TODO: check for gold softlock, and re-do the generation if needed
	
	globals.populate_card_slot.emit()
