extends ProgressBar

@export var inverse = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if (value == 100):
		get("theme_override_styles/fill").border_width_right = 1
	else:
		get("theme_override_styles/fill").border_width_right = 0
		
	if (inverse == false):
		if (value >= 50):
			get("theme_override_styles/fill").bg_color = globals.color_progress_green
		elif (value <50 and value >= 20):
			get("theme_override_styles/fill").bg_color = globals.color_progress_yellow
		else:
			get("theme_override_styles/fill").bg_color = globals.color_progress_red
	elif (inverse == true):
		if (value >= 50):
			get("theme_override_styles/fill").bg_color = globals.color_progress_red
		elif (value <50 and value >= 20):
			get("theme_override_styles/fill").bg_color = globals.color_progress_yellow
		else:
			get("theme_override_styles/fill").bg_color = globals.color_progress_green
