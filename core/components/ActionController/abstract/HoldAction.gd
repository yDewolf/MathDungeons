extends Action
class_name HoldAction

## Class for actions that depends on being holded for an amount of time.

@export var max_hold_time: float = 1 ## Set to [code]0[/code] to remove maximum time
var hold_time: float = 0: 
	set(value):
		hold_time = value
		if hold_time > max_hold_time and max_hold_time > 0:
			stop_action()

func _ready():
	started_action.connect(on_start_action)


func while_active(delta):
	hold_time += delta

func on_start_action():
	hold_time = 0
