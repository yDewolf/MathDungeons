@icon("res://assets/icons/gear-icon.png")
extends Node
class_name InputManager

## Manages inputs using signals. [br]
## Inputs are converted to signals that are emitted whenever the input is called. 
## See [enum ActionTypes]

enum ActionTypes {
	PROCESS_JUST_PRESSED,
	PROCESS_RELEASED,
	PHYSICS_PROCESS_PRESSED,
	PHYSICS_PROCESS_JUST_PRESSED,
	PHYSICS_PROCESS_RELEASED,
}

@export var _process_just_pressed: Array[String] = ["show_cursor"]
@export var _process_released: Array[String]

@export var _physics_process_pressed: Array[String]
@export var _physics_process_just_pressed: Array[String]
@export var _physics_process_released: Array[String]

var cursor_visible: bool:
	set(value):
		cursor_visible = value
		changed_cursor_visible.emit()

signal changed_cursor_visible()


func _register_signals(inputs, type):
	for input in inputs:
		if input != "":
			_register_signal(input, type)

func _register_signal(input, type: ActionTypes):
	if !has_user_signal(input):
		add_user_signal(input+str(type))


func connect_signal(action: String, type: ActionTypes, callable: Callable):
	connect(action+str(type), callable)

func disconnect_signal(action: String, type: ActionTypes, callable: Callable):
	disconnect(action+str(type), callable)


func _ready():
	_register_signals(_physics_process_pressed, ActionTypes.PHYSICS_PROCESS_PRESSED)
	_register_signals(_physics_process_just_pressed, ActionTypes.PHYSICS_PROCESS_JUST_PRESSED)
	_register_signals(_physics_process_released, ActionTypes.PHYSICS_PROCESS_RELEASED)
	
	_register_signals(_process_just_pressed, ActionTypes.PROCESS_JUST_PRESSED)
	_register_signals(_process_released, ActionTypes.PROCESS_RELEASED)
	
	connect_signal("show_cursor", InputManager.ActionTypes.PROCESS_JUST_PRESSED, update_cursor)

func _process(_delta):
	for i in _process_just_pressed:
		if Input.is_action_just_pressed(i):
			emit_signal(i+str(ActionTypes.PROCESS_JUST_PRESSED))
	
	for i in _process_released:
		if Input.is_action_just_released(i):
			emit_signal(i+str(ActionTypes.PROCESS_RELEASED))


func _physics_process(_delta):
	for i in _physics_process_pressed:
		if Input.is_action_pressed(i):
			emit_signal(i+str(ActionTypes.PHYSICS_PROCESS_PRESSED))
	
	for i in _physics_process_just_pressed:
		if Input.is_action_just_pressed(i):
			emit_signal(i+str(ActionTypes.PHYSICS_PROCESS_JUST_PRESSED))
	
	for i in _physics_process_released:
		if Input.is_action_just_released(i):
			emit_signal(i+str(ActionTypes.PHYSICS_PROCESS_RELEASED))


func update_cursor():
	cursor_visible = !cursor_visible
	if cursor_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
