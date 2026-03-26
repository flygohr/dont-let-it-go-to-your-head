extends Node2D

@onready var quest_manager_header: Label = $QuestManagerHeader
@onready var quest_manager_quest: Label = $QuestManagerQuest
@onready var quest_manager_text: RichTextLabel = $QuestManagerText

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
	var objective_text: String = ""
	var quest_target: int
	match quest_type:
		"survive": 
			quest_target = survive_base*globals.quest_level
			objective_text = "days"
		"collect": 
			quest_target = collect_base*globals.quest_level
			objective_text = "COIN"
		"spend": 
			quest_target = spend_base*globals.quest_level
			objective_text = "COIN"
		"find": 
			quest_target = find_base*globals.quest_level
			objective_text = "nickels"
			if quest_target == 1: objective_text = "nickel"
	
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
	var quest_reward_text: String
	var quest_failure_text: String
	
	if number_of_rewards == 1:
		# build quest text with one reward here
		quest_rewards_dict[quest_reward_1] = clamp(globals.quest_level,0,8)*10
		quest_failure_dict[quest_failure] = clamp(globals.quest_level,0,8)*10
		
		if (quest_reward_1 == "coin" and quest_type == "collect"): 
			quest_rewards_dict[quest_reward_1] = (quest_rewards_dict[quest_reward_1]/10)*collect_base
		if (quest_reward_1 == "coin" and quest_type == "spend"): 
			quest_rewards_dict[quest_reward_1] = (quest_rewards_dict[quest_reward_1]/10)*spend_base
		
		if (quest_failure == "coin" and quest_type == "collect"): 
			quest_failure_dict[quest_failure] = (quest_failure_dict[quest_failure]/10)*collect_base
		if (quest_failure == "coin" and quest_type == "spend"): 
			quest_failure_dict[quest_failure] = (quest_failure_dict[quest_failure]/10)*spend_base
			
		if quest_type == "survive":
			quest_failure_dict[quest_failure] = 0
	
		var reward_sign: String	= "+"
		var failure_sign: String = "-"
		
		if (quest_reward_1 == "infamy" or quest_reward_1 == "hunger"): reward_sign = "-"
		
		if (quest_failure == "infamy" or quest_failure == "hunger"): failure_sign = "+"
	
		if quest_type == "survive":
			quest_text = str(
			"Status: 0/", quest_target, "\n",
			"Reward:\n",
			reward_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper()
		)
		else:
			quest_text = str(
				"Status: 0/", quest_target, "\n",
				"Reward:\n",
				reward_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper(), "\n\n",
				"Failure:\n",
				failure_sign, quest_failure_dict[quest_failure], " ", quest_failure.to_upper(), "\n"
			)
		
		quest_reward_text = str(
			"You got: \n",
			reward_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper()
		)
		
		quest_failure_text = str(
			"Failed: \n",
			failure_sign, quest_failure_dict[quest_failure], " ", quest_failure.to_upper()
		)
		
	else: # 2 rewards
		quest_rewards_dict[quest_reward_1] = clamp(globals.quest_level,0,8)*10
		quest_rewards_dict[quest_reward_2] = clamp(globals.quest_level,0,8)*10
		quest_failure_dict[quest_failure] = clamp(globals.quest_level,0,8)*10
		
		if (quest_reward_1 == "coin" and quest_type == "collect"): 
			quest_rewards_dict[quest_reward_1] = (quest_rewards_dict[quest_reward_1]/10)*collect_base
		if (quest_reward_1 == "coin" and quest_type == "spend"): 
			quest_rewards_dict[quest_reward_1] = (quest_rewards_dict[quest_reward_1]/10)*spend_base
		
		if (quest_reward_2 == "coin" and quest_type == "collect"): 
			quest_rewards_dict[quest_reward_2] = (quest_rewards_dict[quest_reward_2]/10)*collect_base
		if (quest_reward_2 == "coin" and quest_type == "spend"): 
			quest_rewards_dict[quest_reward_2] = (quest_rewards_dict[quest_reward_2]/10)*spend_base
		
		if (quest_failure == "coin" and quest_type == "collect"): 
			quest_failure_dict[quest_failure] = (quest_failure_dict[quest_failure]/10)*collect_base
		if (quest_failure == "coin" and quest_type == "spend"): 
			quest_failure_dict[quest_failure] = (quest_failure_dict[quest_failure]/10)*spend_base
	
		if quest_type == "survive":
			quest_failure_dict[quest_failure] = 0
	
		var reward_1_sign: String	= "+"
		var reward_2_sign: String	= "+"
		var failure_sign: String = "-"
		
		if (quest_reward_1 == "infamy" or quest_reward_1 == "hunger"): reward_1_sign = "-"
		if (quest_reward_2 == "infamy" or quest_reward_2 == "hunger"): reward_2_sign = "-"
		
		if (quest_failure == "infamy" or quest_failure == "hunger"): failure_sign = "+"
		
		if quest_type == "survive":
			quest_text = str(
				"Status: 0/", quest_target, "\n",
				"Rewards:\n",
				reward_1_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper(), "\n",
				reward_2_sign, quest_rewards_dict[quest_reward_2], " ", quest_reward_2.to_upper()
			)
		else:
			quest_text = str(
				"Status: 0/", quest_target, "\n",
				"Rewards:\n",
				reward_1_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper(), "\n",
				reward_2_sign, quest_rewards_dict[quest_reward_2], " ", quest_reward_2.to_upper(), "\n\n",
				"Failure:\n",
				failure_sign, quest_failure_dict[quest_failure], " ", quest_failure.to_upper(), "\n"
			)
		
		quest_text = str(
			"Status: 0/", quest_target, "\n",
			"Rewards:\n",
			reward_1_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper(), "\n",
			reward_2_sign, quest_rewards_dict[quest_reward_2], " ", quest_reward_2.to_upper(), "\n\n",
			"Failure:\n",
			failure_sign, quest_failure_dict[quest_failure], " ", quest_failure.to_upper(), "\n"
		)
		
		quest_reward_text = str(
			"You got: \n",
			reward_1_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper(), ", ",
			reward_2_sign, quest_rewards_dict[quest_reward_2], " ", quest_reward_2.to_upper()
		)
		
		quest_failure_text = str(
			"Failed: \n",
			failure_sign, quest_failure_dict[quest_failure], " ", quest_failure.to_upper()
		)
		
	var quest_name = str(
		quest_type.capitalize(),
		" ", quest_target,
		" ", objective_text
	)
		
	globals.current_quest = {
		"name": quest_name,
		"type": quest_type,
		"target": quest_target,
		"current": 0,
		"rewards": quest_rewards_dict,
		"failure": quest_failure_dict,
		"text": quest_text,
		"reward_text": quest_reward_text,
		"failure_text": quest_failure_text
	}
	
	globals.render_quest.emit()
	
func advance_quest_status(value: int) -> void:
	globals.current_quest["current"] += value
	if globals.current_quest["current"] >= globals.current_quest["target"]:
		quest_complete()
		
	#TODO: what is failure? there's no fail condition, just forward. did a bunch of work for nothing
	

func quest_complete() -> void:
	globals.just_completed = true
	globals.quests_completed += 1
	if globals.quests_completed % 3 == 0: globals.quest_level += 1 # increase quests level every 3 completed
	quest_manager_header.text = "QUEST COMPLETED!"
	quest_manager_quest.text = "New quest tomorrow!"
	quest_manager_text.text = str(globals.current_quest["reward_text"])
	
func quest_failed() -> void:
	quest_manager_header.text = "QUEST FAILED!"
	quest_manager_quest.text = "New quest tomorrow!"
	quest_manager_text.text = str(globals.current_quest["failure_text"])
