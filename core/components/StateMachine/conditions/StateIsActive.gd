extends StateCondition

@export var other_state: State = null
@export var inverse: bool = false


func _init():
	match_callable = state_is_active

func state_is_active():
	if other_state == null:
		return true
	
	if inverse:
		return not other_state.active
	
	return other_state.active
