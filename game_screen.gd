extends Node2D

@onready var weeks_days_count: Label = $GameScreen/WeeksDaysCount
@onready var time_tracker: Label = $GameScreen/TimeTracker
@onready var confirm_button: Button = $GameScreen/ConfirmButton

@onready var health_bar_label: Label = $GameScreen/HealthBarLabel
@onready var infamy_bar_label: Label = $GameScreen/InfamyBarLabel
@onready var hunger_bar_label: Label = $GameScreen/HungerBarLabel
@onready var gold_tracker_label: Label = $GameScreen/GoldTrackerLabel

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
	
	# play / resume button depending on game state
	if (current_day == 1 and current_week == 0 and time_of_day == "Day"):
		play_resume_button.text = "PLAY"
	else:
		play_resume_button.text = "RESUME"
	if (high_score_days+(high_score_weeks*7)>0):
		if (high_score_days > 1 and high_score_weeks > 1): # if both plural
			title_screen_score.text = str("Highest score: ",high_score_weeks, " weeks and ",high_score_days," days")
		elif (high_score_days == 1 and high_score_weeks > 1): # if only week plural
			title_screen_score.text = str("Highest score: ",high_score_weeks, " weeks and ",high_score_days," day")
		elif (high_score_days > 1 and high_score_weeks == 1): # if only day plural
			title_screen_score.text = str("Highest score: ",high_score_weeks, " week and ",high_score_days," days")
		elif (high_score_days == 1 and high_score_weeks == 1): # if both singular
			title_screen_score.text = str("Highest score: ",high_score_weeks, " week and ",high_score_days," day")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	weeks_days_count.text = str("W: ",current_week," D: ",current_day,"/7")
	time_tracker.text = str(time_of_day)
	if (hunger < 0): hunger = 0
	elif (hunger >= 100): play_death()
	hunger_bar_label.text = str("HUNGER: ", hunger, "/100")
	pass

func _on_confirm_button_pressed() -> void:
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
	
	death_screen.show()
	var total_days: int = (current_week*7)+current_day
	var high_score_total_days: int = (high_score_weeks*7)+high_score_days
	if (total_days > high_score_days):
		high_score_weeks = current_week
		high_score_days = current_day
		if (current_day > 1 and current_week > 1): # if both plural
			death_screen_score.text = str("New high score: ",current_week, " weeks and ",current_day," days")
		elif (current_day == 1 and current_week > 1): # if only week plural
			death_screen_score.text = str("New high score: ",current_week, " weeks and ",current_day," day")
		elif (current_day > 1 and current_week == 1): # if only day plural
			death_screen_score.text = str("New high score: ",current_week, " week and ",current_day," days")
		elif (current_day == 1 and current_week == 1): # if both singular
			death_screen_score.text = str("New high score: ",current_week, " week and ",current_day," day")
	else:
		if (current_day > 1 and current_week > 1): # if both plural
			death_screen_score.text = str("Score: ",current_week, " weeks and ",current_day," days")
		elif (current_day == 1 and current_week > 1): # if only week plural
			death_screen_score.text = str("Score: ",current_week, " weeks and ",current_day," day")
		elif (current_day > 1 and current_week == 1): # if only day plural
			death_screen_score.text = str("Score: ",current_week, " week and ",current_day," days")
		elif (current_day == 1 and current_week == 1): # if both singular
			death_screen_score.text = str("Score: ",current_week, " week and ",current_day," day")

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
	death_screen.hide()


func _on_play_resume_button_pressed() -> void:
	title_screen.hide()
