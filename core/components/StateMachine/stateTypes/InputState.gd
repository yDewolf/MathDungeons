extends State
class_name InputState

@export_category("Parameters")
@export var toggleable: bool = false

@export_category("Activate Parameters")
@export var input_str: String = ""
@export var input_types: Array[InputManager.ActionTypes]

@export_category("Deactivate Parameters")
@export var deactivate_input_str: String = ""
@export var deactivate_input_type: InputManager.ActionTypes

var is_input_active: bool = false

func _physics_process(_delta):
	is_input_active = false


func change_active(value: bool):
	update_input_active(value)
	super.change_active(value)


func can_activate():
	return is_input_active

func update_input_active(value: bool):
	if toggleable:
		is_input_active = !is_input_active
	
	is_input_active = value
