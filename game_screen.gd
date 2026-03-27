extends Node2D

@onready var game_screen: Node2D = $GameScreen

@onready var game_background_outer: ColorRect = $GameScreen/GameBackgroundOuter
@onready var weeks_days_time: Label = $GameScreen/GameTime/WeeksDaysTime

@onready var confirm_button: Button = $GameScreen/BottomSection/ConfirmButton
@onready var confirm_button_bg: ColorRect = $GameScreen/BottomSection/ConfirmButtonBG

@onready var infamy_progress_bar: ProgressBar = $GameScreen/TopStats/InfamyTracker/InfamyProgressBar
@onready var infamy_bar_label: Label = $GameScreen/TopStats/InfamyTracker/InfamyBarLabel
@onready var lives_label: Label = $GameScreen/TopStats/InfamyTracker/LivesLabel

@onready var hunger_progress_bar: ProgressBar = $GameScreen/TopStats/HungerTracker/HungerProgressBar
@onready var hunger_bar_label: Label = $GameScreen/TopStats/HungerTracker/HungerBarLabel

@onready var health_progress_bar: ProgressBar = $GameScreen/TopStats/HealthTracker/HealthProgressBar
@onready var health_bar_label: Label = $GameScreen/TopStats/HealthTracker/HealthBarLabel

@onready var gold_tracker_label: Label = $GameScreen/TopStats/CoinTracker/GoldTrackerLabel

@onready var text_next_to_button: RichTextLabel = $GameScreen/BottomSection/TextNextToButton

@onready var title_screen: Node2D = $TitleScreen
@onready var title_screen_score: Label = $TitleScreen/TitleScreenScore
@onready var play_resume_button: Button = $TitleScreen/PlayResumeButton

@onready var death_screen: Node2D = $DeathScreen
@onready var death_screen_label: Label = $DeathScreen/DeathScreenLabel
@onready var death_screen_text: Label = $DeathScreen/DeathScreenText
@onready var death_screen_score: Label = $DeathScreen/DeathScreenScore

@onready var give_up_button: Button = $GameScreen/BottomSection/GiveUpButton
@onready var give_up_button_bg: ColorRect = $GameScreen/BottomSection/GiveUpButtonBG

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		globals.is_mobile = true
	globals.play_death.connect(play_death)
	globals.not_enough_gold.connect(not_enough_gold)
	globals.change_confirm_text.connect(change_confirm_text)
	globals.advance_day.connect(advance_days)
	globals.move_game_screen_away.connect(move_game_screen_away)
	globals.move_game_screen_in.connect(move_game_screen_in)
	
	var game_data: Dictionary = load_data()
	globals.high_score_weeks = game_data["high_score_weeks"]
	globals.high_score_days = game_data["high_score_days"]
	globals.current_week = game_data["current_week"]
	globals.current_day = game_data["current_day"]
	globals.hunger = game_data["hunger"]
	globals.health = game_data["health"]
	globals.infamy = game_data["infamy"]
	globals.coin = game_data["coin"]
	globals.cards_list = game_data["current_cards"].duplicate_deep()
	globals.lives = game_data["lives"]
	globals.tutorial_played = game_data["tutorial_played"]
	globals.current_quest = game_data["current_quest"].duplicate_deep()
	globals.quests_completed = game_data["quests_completed"]
	globals.quest_level = game_data["quest_level"]
	globals.just_completed = game_data["quest_just_completed"]
	globals.current_screen = "title"
	globals.render_quest.emit()
	title_screen.show()
	# print(game_data["new_game"])
	# play / resume button depending on game state
	if (game_data["new_game"] == true):
		play_resume_button.text = "PLAY"
		globals.generate_cards.emit()
		if (globals.high_score_days+(globals.high_score_weeks*7)>0):
			title_screen_score.text = str("Highest score: ", return_weeks_days_text(globals.high_score_weeks,globals.high_score_days))
		else:
			title_screen_score.text = "" # No high score yet
	else:
		play_resume_button.text = "RESUME"
		globals.populate_card_slot.emit()
	
		title_screen_score.text = str("Current game: ", return_weeks_days_text(globals.current_week,globals.current_day))
		# also missing "new game logic", if cards are drawn on a new game this basic check won't cut it. ah but it's easy, I just need to check if "current cards" or smth is active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	weeks_days_time.text = str("Day ", globals.current_day, "/7 of week ", globals.current_week+1)
	
	infamy_progress_bar.value = globals.infamy
	infamy_bar_label.text = str(globals.infamy,"/100")
	
	hunger_progress_bar.value = globals.hunger
	hunger_bar_label.text = str(globals.hunger,"/100")
	
	health_progress_bar.value = globals.health
	health_bar_label.text = str(globals.health,"/100")
	
	gold_tracker_label.text = str(globals.coin," G")
	
	lives_label.text = str("LIVES: ", globals.lives)
	
func _on_confirm_button_pressed() -> void:
	if globals.just_completed == true : globals.generate_quest.emit()
	globals.apply_effect.emit()
	confirm_button_bg.hide()
	confirm_button.disabled = true
	text_next_to_button.text = str("Pick a card")
	advance_days()
	
func advance_days() -> void:

	if(globals.current_day < 7):
		globals.current_day += 1
	else:
		globals.current_day = 1
		globals.current_week += 1
		
	globals.generate_cards.emit()
	
	save_data({
		"high_score_weeks": globals.high_score_weeks,
		"high_score_days": globals.high_score_days,
		"current_week": globals.current_week,
		"current_day": globals.current_day,
		"hunger": globals.hunger,
		"health": globals.health,
		"infamy": globals.infamy,
		"coin": globals.coin,
		"current_cards": globals.cards_list.duplicate_deep(),
		"new_game": false,
		"lives": globals.lives,
		"tutorial_played": true,
		"current_quest": globals.current_quest.duplicate_deep(),
		"quests_completed": globals.quests_completed,
		"quest_level": globals.quest_level,
		"quest_just_completed": globals.just_completed
	})
	
	
func play_death(title, text):
	globals.current_screen = "death"
	var tween = get_tree().create_tween()
	tween.tween_property(death_screen, "position", Vector2(0,0), 0.2)
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(game_screen, "position", Vector2(0,-160), 0.2)
	
	death_screen_label.text = title
	death_screen_text.text = text
	
	var total_days: int = (globals.current_week*7)+globals.current_day
	var high_score_total_days: int = (globals.high_score_weeks*7)+globals.high_score_days
	if (total_days > high_score_total_days):
		globals.high_score_weeks = globals.current_week
		globals.high_score_days = globals.current_day
		death_screen_score.text = str("New high score: ", return_weeks_days_text(globals.high_score_weeks,globals.high_score_days))
	else:
		death_screen_score.text = str("Score: ", return_weeks_days_text(globals.current_week,globals.current_day))
	
	reset_save()

func return_weeks_days_text(weeks, days) -> String:
	var text_to_return: String = ""
	
	if (days == 1 and weeks == 1): # if both singular
		text_to_return = str(weeks, " week and ",days," day")
	elif ((days == 1 and weeks > 1) or (days == 1 and weeks == 0)): # if only day singular
		text_to_return = str(weeks, " weeks and ",days," day")
		return text_to_return
	elif (days > 1 and weeks == 1): # if only week singular
		text_to_return = str(weeks, " week and ",days," days")
		return text_to_return
	else: # if both plural
		text_to_return = str(weeks, " weeks and ",days," days")
		return text_to_return
	return text_to_return

# save system from https://www.youtube.com/watch?v=PB8fLZR4wFU

func save_data(data: Dictionary) -> void:
	var save_file: FileAccess = FileAccess.open(globals.save_file_name, FileAccess.WRITE)
	if save_file == null:
		push_error("Error opening file")
		return
	var string_data: String = JSON.stringify(data)
	save_file.store_line(string_data)
	save_file.close()
	
func load_data() -> Dictionary:
	if FileAccess.file_exists(globals.save_file_name):
		var save_file: FileAccess = FileAccess.open(globals.save_file_name, FileAccess.READ)
		if save_file == null:
			push_error("Error reading file")
			return globals.default_save_data
		var json = JSON.new()
		
		var string_data: String = save_file.get_line()
		if json.parse(string_data) == OK:
			var data: Dictionary = json.get_data()
			save_file.close()
			return data
		push_error("Corrupted data")
	return globals.default_save_data
		
func reset_save() -> void:
	globals.cards_list.clear()
	globals.default_save_data["high_score_weeks"] = globals.high_score_weeks
	globals.default_save_data["high_score_days"] = globals.high_score_days
	globals.default_save_data["tutorial_played"] = true
	save_data(globals.default_save_data)
	var game_data: Dictionary = load_data()
	globals.high_score_weeks = game_data["high_score_weeks"]
	globals.high_score_days = game_data["high_score_days"]
	globals.current_week = game_data["current_week"]
	globals.current_day = game_data["current_day"]
	globals.hunger = game_data["hunger"]
	globals.health = game_data["health"]
	globals.infamy = game_data["infamy"]
	globals.coin = game_data["coin"]
	globals.lives = game_data["lives"]
	globals.tutorial_played = true
	globals.quests_completed = 0
	globals.quest_level = 1
	globals.generate_quest.emit()

func _on_restart_button_pressed() -> void:
	globals.current_screen = "game"
	reset_save()
	globals.generate_cards.emit()
	text_next_to_button.text = str("Pick a card")
	var tween = get_tree().create_tween()
	tween.tween_property(death_screen, "position", Vector2(0,160), 0.2)
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(game_screen, "position", Vector2(0,0), 0.2)
	
func _on_play_resume_button_pressed() -> void:
	globals.current_screen = "game"
	title_screen.hide()
	if globals.tutorial_played == false: globals.play_tutorial.emit()
	else: 
		move_game_screen_in()

func move_game_screen_away() -> void:
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(game_screen, "position", Vector2(0,-160), 0.2)
	
func move_game_screen_in() -> void:
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(game_screen, "position", Vector2(0,0), 0.2)

func _on_confirm_button_mouse_entered() -> void:
	if (confirm_button.disabled == false):
		confirm_button_bg.show()

func _on_confirm_button_mouse_exited() -> void:
	confirm_button_bg.hide()

func not_enough_gold() -> void:
	text_next_to_button.text = str("[color=",globals.color_red,"]Not enough COIN![/color]")

func change_confirm_text(_string : String) -> void:
	text_next_to_button.text = _string

func _on_give_up_button_pressed() -> void:
	globals.toggle_quit_screen.emit()

func _on_give_up_button_mouse_entered() -> void:
	give_up_button_bg.show()

func _on_give_up_button_mouse_exited() -> void:
	give_up_button_bg.hide()
