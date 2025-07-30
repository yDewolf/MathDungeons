extends StateCondition

@export var target_action: Action

func _ready():
	match_callable = check_action_active

func check_action_active():
	return target_action.active
