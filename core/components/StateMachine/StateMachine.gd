@icon("res://assets/icons/gear-icon.png")
extends Node
class_name StateMachine

## Controls and handles state toggling and updating [br]
## Children should only be [State]

## Holds all states indexed in this [StateMachine]
var states: Array[State] = []

## Used for connecting states that rely on input actions
@export var input_manager: InputManager
@export var debug_mode: bool = true

@export_category("Utils")
## Holds states by its names. [br]
## [codeblock]
## state_index = {
## 		"state_name": State
## }
## [/codeblock]
@export var state_index: Dictionary

## Holds states that should be updated on [method _physics_process]
var update_on_physics_states: Array[State]

# Probably unnecessary
## Emitted when a state is strictly changed. [br]
## If the state is updated but the value isn't changed, this won't be emitted. 
## See [method update_state]
signal changed_state(state_name)


func _ready():
	index_states()

func _physics_process(delta):
	for state in update_on_physics_states:
		update_state(state, true, delta)
	
	if debug_mode:
		for state in states:
			debug_state(state)

## Main function for indexing states on ready
func index_states():
	var children = NodeUtils.get_deep_children(self)
	if children == null:
		return
	
	for child in children:
		if not child is State:
			if child is StateCondition:
				continue
			
			push_warning("WARNING: StateMachine children should only be type State | Incorrect Child: ", child)
			continue
		
		states.append(child)
	
	for state in states:
		_add_state(state)

## Changes the value of a [State] [br]
## The [State] should be indexed previously in this [StateMachine]. 
## See [method _add_state]
func change_state(state: State, value: bool):
	if not states.has(state):
		push_warning("WARNING: ", self, " can't change State (", state.state_name, ") value since it is not indexed in this StateMachine")
		return
	
	var previous_value = state.active
	state.change_active(value)
	if previous_value != value:
		changed_state.emit(state.state_name)

## Simply tries to update the value of a [State] by changing its value [code]true[/code]. 
## See [method change_state]
func update_state(state: State, value: bool = true, delta = 1):
	change_state(state, value)
	
	if state.active:
		state.while_active(delta)

## Adds a [State] to this [StateMachine] [br]
## Connects all needed signals.
func _add_state(state: State):
	state_index[state.state_name] = state
	
	if state is InputState:
		_connect_input_state(state)
	
	elif state is ActionState and not state is WindowState:
		if state.update_on_physics:
			update_on_physics_states.append(state)
		
		return
	
	else:
		update_on_physics_states.append(state)


## Removes a [State] from this [StateMachine]. [br]
## Probably shouldn't be called.
func _remove_state(state: State):
	state_index.erase(state)
	
	if update_on_physics_states.has(state.state_name):
		update_on_physics_states.erase(state.state_name)
	
	if state is InputState:
		for input_type in state.input_types:
			input_manager.disconnect_signal(
					state.input_str, 
					input_type,
					update_state.bind(state)
			)

## Returns the state by looking for it in [member state_index]. [br]
## Takes [param state_name] as search parameter.
func get_state(state_name: String):
	if state_index.has(state_name):
		return state_index[state_name]
	
	push_error("ERROR: Couldn't find state: ", state_name, " on ", self, " | States: ", state_index)
	return null


func debug_state(state: State):
	print_rich("[color=orange]DEBUG: [/color]", state.state_name, ": [color=cyan]", state.active, "[/color]")

func _connect_input_state(state: State):
	if input_manager == null:
		push_error("ERROR: Trying to connect a state that should connect to an input from InputManager but it's null | Input str: ", state.input_str, " | At: ", self)
		return
	
	for input_type in state.input_types:
		input_manager.connect_signal(
				state.input_str, 
				input_type,
				update_state.bind(state, true)
		)
	
	if state.toggleable:
		if state.deactivate_input_str != "":
			push_warning("WARNING: Ignoring deactivate_input_str since state is toggleable | state_name: ", state.state_name)
		return
	
	if state.deactivate_input_str != "":
		input_manager.connect_signal(
				state.deactivate_input_str, 
				state.deactivate_input_type,
				update_state.bind(state, false)
		)
