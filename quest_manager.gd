extends Node2D

@onready var quest_manager_quest: Label = $QuestManagerQuest
@onready var quest_manager_text: RichTextLabel = $QuestManagerText

var survive_base: int = 3
var collect_base: int = 50
var spend_base: int = 50
var find_base: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	globals.render_quest.connect(render_quest)
	globals.generate_quest.connect(generate_quest)
	globals.check_quest.connect(check_quest)
	globals.display_quest_end.connect(display_quest_end)

func render_quest() -> void:
	quest_manager_quest.text = str(globals.current_quest["name"]).to_upper()
	
	# build "Expires: X day(s)\n\n" and "Status: X/X\n\n" here
	var expires_text: String = ""
	if globals.current_quest["type"] != "survive":
		expires_text = str(
			"Expires: ", int(globals.current_quest["deadline"] - globals.current_quest["elapsed"]), " days\n\n"
		)
		
	var status_text: String = str("Status: ", int(globals.current_quest["current"]),"/",int(globals.current_quest["target"]))
	
	var final_text: String = str(expires_text,status_text,)
	
	quest_manager_text.text = str(
		final_text, "\n\n",
		globals.current_quest["text"]
		)

func generate_quest() -> void:
	globals.just_completed = false
	globals.quest_just_generated = true
	var number_of_rewards: int 
	if (randf() > .75): number_of_rewards = 2
	else: number_of_rewards = 1
	
	var quest_type: String = ["survive", "collect", "spend"].pick_random() # removed "find", nickels too rare and too much logic
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
	
	var quest_deadline: int = clamp(globals.quest_level,0,8)*3
	# if quest type survive deadline is number of days
	if quest_type == "survive": quest_deadline = quest_target
	
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
			"Reward:\n",
			reward_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper()
		)
		else:
			quest_text = str(
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
				"Rewards:\n",
				reward_1_sign, quest_rewards_dict[quest_reward_1], " ", quest_reward_1.to_upper(), "\n",
				reward_2_sign, quest_rewards_dict[quest_reward_2], " ", quest_reward_2.to_upper()
			)
		else:
			quest_text = str(
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
		"deadline": quest_deadline,
		"elapsed": 0,
		"target": quest_target,
		"current": 0,
		"rewards": quest_rewards_dict,
		"failure": quest_failure_dict,
		"text": quest_text,
		"reward_text": quest_reward_text,
		"failure_text": quest_failure_text
	}
	
	render_quest()
	
func apply_stats(infamy: int, hunger: int, health: int, coin: int) -> void:
	print("Quest resolved: ", infamy," infamy, ", hunger, " hunger", health, " health, ", coin, " coin")
	globals.infamy = clamp(globals.infamy+infamy,0,100)
	globals.hunger = clamp(globals.hunger+hunger,0,100)
	globals.health = clamp(globals.health+health,0,100)
	globals.coin = clamp(globals.coin+coin,0,999)

func quest_complete() -> void:
	globals.play_success_sound.emit()
	globals.just_completed = true
	globals.quests_completed += 1
	if globals.quests_completed % 3 == 0: globals.quest_level += 1 # increase quests level every 3 completed
	display_success()
	
	#apply positive quest effects here
	apply_stats(
		-abs(globals.current_quest["rewards"]["infamy"]),
		-abs(globals.current_quest["rewards"]["hunger"]),
		globals.current_quest["rewards"]["health"],
		globals.current_quest["rewards"]["coin"]
	)
	
	#make sure the death checks are happening after applying quests
		
func quest_failed() -> void:
	globals.play_failure_sound.emit()
	globals.just_completed = true
	display_failure()
	apply_stats(
		globals.current_quest["failure"]["infamy"],
		globals.current_quest["failure"]["hunger"],
		-abs(globals.current_quest["failure"]["health"]),
		-abs(globals.current_quest["failure"]["coin"])
	)

func check_quest(infamy: int, hunger: int, health: int, coin: int) -> void:
	print(str("Checking quest for: infamy ", infamy, ", hunger: ",hunger, ", health: ", health, ", coin: ", coin))
	print(globals.current_quest)
	match globals.current_quest["type"]:
		"survive":
			globals.current_quest["current"] += 1
		"collect":
			if coin > 0: globals.current_quest["current"] += coin
		"spend":
			if coin < 0: globals.current_quest["current"] += abs(coin)
	print(globals.current_quest)
	# update quest text field here
	
	globals.current_quest["elapsed"] += 1
	if globals.current_quest["current"] >= globals.current_quest["target"]:
		quest_complete()
	elif (globals.current_quest["elapsed"] >= globals.current_quest["deadline"]) and globals.just_completed == false:
		quest_failed() 	# advance quest of 1 day, and if over target and not yet completed, fail it
	else: render_quest()
	
func display_quest_end() -> void:
	if globals.current_quest["current"] >= globals.current_quest["target"]:
		display_success()
	elif (globals.current_quest["elapsed"] >= globals.current_quest["deadline"]) and globals.just_completed == false:
		display_failure() 	
	else: render_quest()

func display_success() -> void:
	quest_manager_quest.text = "QUEST COMPLETED!"
	quest_manager_text.text = str(globals.current_quest["reward_text"],"\n\nNew quest tomorrow!")
	
func display_failure() -> void:
	quest_manager_quest.text = "QUEST FAILED!"
	quest_manager_text.text = str(globals.current_quest["failure_text"],"\n\nNew quest tomorrow!")
