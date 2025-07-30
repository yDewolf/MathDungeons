@icon("res://core/components/StateMachine/assets/state-icon.png")
extends Node
class_name State

## Has conditions to be active or not. [br]
## Conditions can be defined externally ([member conditions]) 
## or internally (by overriding [method can_activate])
##
## If a class inherits this class directly, it will be automatically
## updated by [class StateMachine]

@export var state_name: String = ""
@export var active: bool = false:
	set(value):
		if value != active:
			active = value
			active_changed.emit()

@export_category("Parameters")
@export var conditions: Array[StateCondition]

signal active_changed()

func _ready():
	if state_name == "":
		state_name = self.name


func toggle():
	if not active and can_activate():
		active = true
		return
	
	active = false

func change_active(value: bool):
	if can_activate() and value:
		active = value
		return
	
	active = false
	return

## Should be overrided [br]
## Called by [class StateMachine] after updating the state
func while_active(_delta: float):
	pass

## Main function to check if this state can be active or not. [br]
## Checks if all [StateCondition] matches.
func can_activate():
	if conditions.is_empty():
		return true
	
	for condition in conditions:
		if condition.matches() == false:
			return false
	
	return true
