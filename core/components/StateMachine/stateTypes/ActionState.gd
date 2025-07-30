extends State
class_name ActionState

## General class for states that are active when [member target_action] are active

@export var target_action: Action
@export var update_on_physics: bool = false

func _ready():
	super._ready()
	
	target_action.started_action.connect(update_state)
	target_action.stopped_action.connect(update_state)


func can_activate():
	var super_condition = super.can_activate()
	return target_action.active and super_condition

func update_state():
	change_active(target_action.active)
