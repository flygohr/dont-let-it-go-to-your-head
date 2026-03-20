extends Button

func _ready() -> void:
	globals.enable_confirm_button.connect(enable)
	globals.disable_confirm_button.connect(disable)

func enable() -> void:
	disabled = false
	
func disable() -> void:
	disabled = true
