extends Node2D

@onready var game_screen: Node2D = $GameScreen

@onready var game_background_outer: ColorRect = $GameScreen/GameBackgroundOuter
@onready var weeks_days_time: Label = $GameScreen/GameTime/WeeksDaysTime

@onready var confirm_button: Button = $GameScreen/BottomSection/ConfirmButton
@onready var confirm_button_bg: ColorRect = $GameScreen/BottomSection/ConfirmButtonBG

@onready var infamy_progress_bar: ProgressBar = $GameScreen/TopStats/InfamyTracker/InfamyProgressBar
@onready var infamy_bar_label: Label = $GameScreen/TopStats/InfamyTracker/InfamyBarLabel

@onready var hunger_progress_bar: ProgressBar = $GameScreen/TopStats/HungerTracker/HungerProgressBar
@onready var hunger_bar_label: Label = $GameScreen/TopStats/HungerTracker/HungerBarLabel

@onready var health_progress_bar: ProgressBar = $GameScreen/TopStats/HealthTracker/HealthProgressBar
@onready var health_bar_label: Label = $GameScreen/TopStats/HealthTracker/HealthBarLabel

@onready var gold_tracker_label: Label = $GameScreen/TopStats/CoinTracker/GoldTrackerLabel
@onready var cards_tracker_label: Label = $GameScreen/TopStats/CardsTracker/CardsTrackerLabel

@onready var title_screen: Node2D = $TitleScreen
@onready var title_screen_score: Label = $TitleScreen/TitleScreenScore
@onready var play_resume_button: Button = $TitleScreen/PlayResumeButton

@onready var death_screen: Node2D = $DeathScreen
@onready var death_screen_score: Label = $DeathScreen/DeathScreenScore

const save_file_name: String = "user://dligtyh_save_3.json"
var default_save_data: Dictionary = {
	"high_score_weeks": 0,
	"high_score_days": 0,
	"current_week": 0,
	"current_day": 1,
	"time_of_day": "Day",
	"hunger": 0,
	"health": 100,
	"infamy": 0,
	"coin": 5
}

const hunger_gained_per_day: int = 10

var high_score_weeks: int = 0
var high_score_days: int = 0

var current_week: int = 0
var current_day: int = 1
var time_of_day: String = "Day"

var hunger: int = 0
var health: int = 100
var infamy: int = 0
var coin: int = 5
var total_cards: int = 40
var current_cards: int = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_data: Dictionary = load_data()
	high_score_weeks = game_data["high_score_weeks"]
	high_score_days = game_data["high_score_days"]
	current_week = game_data["current_week"]
	current_day = game_data["current_day"]
	time_of_day = game_data["time_of_day"]
	hunger = game_data["hunger"]
	health = game_data["health"]
	infamy = game_data["infamy"]
	coin = game_data["coin"]
		
	globals.current_screen = "title"
	title_screen.show()
	# play / resume button depending on game state
	if (current_day == 1 and current_week == 0 and time_of_day == "Day"):
		play_resume_button.text = "PLAY"
		if (high_score_days+(high_score_weeks*7)>0):
			title_screen_score.text = str("Highest score: ", return_weeks_days_text(high_score_weeks,high_score_days))
		else:
			title_screen_score.text = "" # No high score yet
	else:
		play_resume_button.text = "RESUME"
		var daytime_or_nighttime: String = ""
		if (time_of_day == "Day"):
			daytime_or_nighttime = "daytime"
		elif (time_of_day == "Night"):
			daytime_or_nighttime = "nighttime"
		log(current_week)
		log(current_day)
		title_screen_score.text = str("Current game: ", return_weeks_days_text(current_week,current_day), ", ", daytime_or_nighttime, ".")
		# also missing "new game logic", if cards are drawn on a new game this basic check won't cut it. ah but it's easy, I just need to check if "current cards" or smth is active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var daytime_or_nighttime: String = ""
	if (time_of_day == "Day"):
		daytime_or_nighttime = "daytime"
	elif (time_of_day == "Night"):
		daytime_or_nighttime = "nighttime"
	weeks_days_time.text = str("Day ", current_day, "/7 of week ", current_week, ", ", daytime_or_nighttime)
	
	infamy_progress_bar.value = infamy
	infamy_bar_label.text = str(infamy,"/100")
	
	hunger_progress_bar.value = hunger
	hunger_bar_label.text = str(hunger,"/100")
	
	health_progress_bar.value = health
	health_bar_label.text = str(health,"/100")
	
	gold_tracker_label.text = str(coin," G")
	cards_tracker_label.text = str(current_cards,"/",total_cards)
	
	# death conditions
	if (hunger < 0): hunger = 0
	elif (hunger >= 100): play_death()

func _on_confirm_button_pressed() -> void:
	globals.card_selected.emit()
	globals.can_proceed = false
	confirm_button_bg.hide()
	advance_days()
	
func advance_days() -> void:
	if(time_of_day == "Day"):
		time_of_day = "Night"	
	elif(current_day < 7 and time_of_day == "Night"):
		current_day += 1
		time_of_day = "Day"
		hunger += hunger_gained_per_day
	else:
		current_day = 1
		current_week += 1
		time_of_day = "Day"
		
	save_data({
		"high_score_weeks": high_score_weeks,
		"high_score_days": high_score_days,
		"current_week": current_week,
		"current_day": current_day,
		"time_of_day": time_of_day,
		"hunger": hunger,
		"health": health,
		"infamy": infamy,
		"coin": coin
	})
	
func play_death():
	globals.current_screen = "death"
	var tween = get_tree().create_tween()
	tween.tween_property(death_screen, "position", Vector2(0,0), 0.2)
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(game_screen, "position", Vector2(0,-160), 0.2)
	var total_days: int = (current_week*7)+current_day
	var high_score_total_days: int = (high_score_weeks*7)+high_score_days
	if (total_days > high_score_days):
		high_score_weeks = current_week
		high_score_days = current_day
		death_screen_score.text = str("New high score: ", return_weeks_days_text(high_score_weeks,high_score_days))
	else:
		death_screen_score.text = str("Score: ", return_weeks_days_text(current_week,current_day))

func return_weeks_days_text(weeks, days) -> String:
	var text_to_return: String = ""
	
	if (days == 1 and weeks == 1): # if both singular
		text_to_return = str(weeks, " week and ",days," day")
	elif (days == 1 and weeks > 1): # if only day singular
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
	var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.WRITE)
	if save_file == null:
		push_error("Error opening file")
		return
	var string_data: String = JSON.stringify(data)
	save_file.store_line(string_data)
	save_file.close()
	
func load_data() -> Dictionary:
	if FileAccess.file_exists(save_file_name):
		var save_file: FileAccess = FileAccess.open(save_file_name, FileAccess.READ)
		if save_file == null:
			push_error("Error reading file")
			return default_save_data
		var json = JSON.new()
		
		var string_data: String = save_file.get_line()
		if json.parse(string_data) == OK:
			var data: Dictionary = json.get_data()
			save_file.close()
			return data
		push_error("Corrupted data")
	return default_save_data
		
func reset_save() -> void:
	default_save_data["high_score_weeks"] = high_score_weeks
	default_save_data["high_score_days"] = high_score_days
	save_data(default_save_data)
	var game_data: Dictionary = load_data()
	high_score_weeks = game_data["high_score_weeks"]
	high_score_days = game_data["high_score_days"]
	current_week = game_data["current_week"]
	current_day = game_data["current_day"]
	time_of_day = game_data["time_of_day"]
	hunger = game_data["hunger"]
	health = game_data["health"]
	infamy = game_data["infamy"]
	coin = game_data["coin"]


func _on_restart_button_pressed() -> void:
	reset_save()
	globals.current_screen = "game"
	var tween = get_tree().create_tween()
	tween.tween_property(death_screen, "position", Vector2(0,160), 0.2)
	var tween_b = get_tree().create_tween()
	tween_b.tween_property(game_screen, "position", Vector2(0,0), 0.2)
	
func _on_play_resume_button_pressed() -> void:
	globals.current_screen = "game"
	title_screen.hide()
	var tween = get_tree().create_tween()
	tween.tween_property(game_screen, "position", Vector2(0,0), 0.2)


func _on_confirm_button_mouse_entered() -> void:
	if (globals.can_proceed == true):
		confirm_button_bg.show()

func _on_confirm_button_mouse_exited() -> void:
	confirm_button_bg.hide()
