@icon("res://assets/icons/gear-icon.png")
extends Node
class_name ActionController

#@export var player: CharacterController
@export var input_manager: InputManager

var actions: Array[Action]
@export var active_actions: Array[Action]

func _ready():
	for child in get_children():
		if child is Action:
			actions.append(child)
	
	for action in actions:
		connect_action(action)

func _physics_process(delta):
	for action in active_actions:
		action.while_active(delta)


func connect_action(action: Action):
	action.action_controller = self
	
	if action.activations.is_empty() and not action.ignore_no_activations_warning:
		push_warning("WARNING: Action (", action.name, ") doesn't have any activation methods. Is this an error?")
	
	for activation in action.activations:
		if activation is InputActivation:
			var target_callable: Callable = action.start_action
			if activation.inverse:
				target_callable = action.stop_action
			elif activation.toggleable:
				target_callable = action.toggle_action
			
			input_manager.connect_signal(activation.input_str, activation.input_type, target_callable)
	
	if action.active:
		active_actions.append(action)
	
	action.active_changed.connect(on_action_active_changed.bind(action))

func on_action_active_changed(action: Action):
	if action.active:
		active_actions.append(action)
		return
	
	active_actions.erase(action)
