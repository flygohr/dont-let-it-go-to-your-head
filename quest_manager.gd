extends Node2D

@onready var quest_manager_header: Label = $QuestManagerHeader
@onready var quest_manager_quest: Label = $QuestManagerQuest
@onready var quest_manager_text: Label = $QuestManagerText

var survive_base: int = 5
var collect_base: int = 50
var spend_base: int = 50
var find_base: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.render_quest.connect(render_quest)
	globals.generate_quest.connect(generate_quest)


func render_quest() -> void:
	quest_manager_header.text = "CURRENT QUEST:"
	quest_manager_quest.text = str(globals.current_quest["name"]).to_upper()
	quest_manager_text.text = str(globals.current_quest["text"])

func generate_quest() -> void:
	var number_of_rewards: int 
	if (randf() > .75): number_of_rewards = 2
	else: number_of_rewards = 1
	
	var quest_type: String = ["survive", "collect", "spend", "find"].pick_random()
	
	var quest_target: int
	match quest_type:
		"survive": quest_target = survive_base*globals.quest_level
		"collect": quest_target = collect_base*globals.quest_level
		"spend": quest_target = spend_base*globals.quest_level
		"find": quest_target = find_base*globals.quest_level
	
	var quest_reward_1: String
	var quest_reward_2: String
	var quest_failure: String
	
	quest_reward_1 = ["infamy", "hunger", "health", "coin"].pick_random()
	quest_reward_2 = ["infamy", "hunger", "health", "coin"].pick_random()
	quest_failure = ["infamy", "hunger", "health", "coin"].pick_random()
	
	while quest_reward_1 == quest_reward_2:
		quest_reward_2 = ["infamy", "hunger", "health", "coin"].pick_random()
		
	var quest_text: String
	var quest_rewards_dict: Dictionary = {
		"infamy": 0,
		"hunger": 0,
		"health": 0,
		"coin": 0
	}
	var quest_failure_dict: Dictionary = quest_rewards_dict.duplicate_deep()
	
	if number_of_rewards == 1:
		# build quest text with one reward here
		quest_rewards_dict[quest_reward_1] = clamp(globals.quest_level,0,8)
		quest_failure_dict[quest_failure] = clamp(globals.quest_level,0,8)
		#TODO: this negative and positive depend on stat
	else: # 2 rewards
		pass # build quest text with two rewards here
	
	# type survive: no failure condition ofc
	
	# type collect money
	
	# type collect 
	
	# pick rewards
	# pick failures
	
	# generate bbcode
