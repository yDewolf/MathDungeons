@icon("res://core/components/ActionController/assets/action_related/walking-icon.png")
extends Node
class_name Action

## General Action class [br]
## Used for simple actions that don't rely on more than input activations. [br]
## See [class ActivationType]

var action_controller: ActionController:
	set(value):
		action_controller = value
		action_controller_changed.emit()

@export var activations: Array[ActivationType] ## Activation methods for this action.

@export var cooldown: float = 0.0
var cooldown_timer: SceneTreeTimer

@export var active: bool = false:
	set(value):
		if not active and value:
			if on_cooldown:
				return
			
			active = true
			started_action.emit()
			active_changed.emit()
		
		elif active and not value:
			active = false
			stopped_action.emit()
			active_changed.emit()
			
			on_cooldown = true

var on_cooldown: bool = false:
	set(value):
		on_cooldown = value
		if on_cooldown:
			cooldown_timer = get_tree().create_timer(cooldown)
			cooldown_timer.timeout.connect(
				func(): on_cooldown = false
			)
			started_cooldown.emit()

@export_category("Other")
@export var ignore_no_activations_warning: bool = false

signal started_cooldown()

signal started_action()
signal stopped_action()

signal active_changed()

signal action_controller_changed()

func while_active(_delta: float):
	pass

## Should be overrided
func can_activate():
	return true

func start_action():
	if not can_activate():
		return
	
	active = true

func stop_action():
	active = false


func toggle_action():
	if active:
		stop_action()
	else:
		start_action()
