extends State
class_name WindowState

## General class for states that creates a 'window' to an action. [br]
## Example: When you crouch you have 0.5 seconds to jump and have a higher jump than normal.

@export var target_state: State

@export_category("Parameters")
@export var window_threshold: float = 0.5
var time: float = 0:
	set(value):
		time = value
		if time >= window_threshold:
			time = 0
			new_window = false
			change_active(false)

var new_window: bool = true

func _ready():
	target_state.active_changed.connect(update_state)
	super._ready()

func while_active(delta):
	time += delta


func can_activate():
	var super_condition = super.can_activate()
	
	return new_window and target_state.active and super_condition


func update_state():
	change_active(target_state.active)
	
	if not active:
		time = 0
		new_window = true
