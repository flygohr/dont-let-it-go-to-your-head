extends Node2D

@onready var weeks_days_count: Label = $WeeksDaysCount
@onready var time_tracker: Label = $TimeTracker
@onready var confirm_button: Button = $ConfirmButton

const save_file_name: String = "user://dligtyh_save.json"
const default_save_data: Dictionary = {
	"current_week": 1,
	"current_day": 1,
	"time_of_day": "Day"
}

var current_week: int = 1
var current_day: int = 1
var time_of_day: String = "Day"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var game_data: Dictionary = load_data()
	current_week = game_data["current_week"]
	current_day = game_data["current_day"]
	time_of_day = game_data["time_of_day"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	weeks_days_count.text = str("W: ",current_week," D: ",current_day,"/7")
	time_tracker.text = str(time_of_day)
	pass

func _on_confirm_button_pressed() -> void:
	advance_days()
	
func advance_days() -> void:
	if(time_of_day == "Day"):
		time_of_day = "Night"
	elif(current_day < 7 and time_of_day == "Night"):
		current_day += 1
		time_of_day = "Day"
	else:
		current_day = 1
		current_week += 1
		time_of_day = "Day"
		
	save_data({
		"current_week": current_week,
		"current_day": current_day,
		"time_of_day": time_of_day
	})

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
	save_data(default_save_data)
