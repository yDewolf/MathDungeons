@icon("res://core/components/ActionController/assets/input-activation-icon1.png")
class_name InputActivation
extends ActivationType

## General Input based activation type. [br]
## Has to be externally connected to an [class InputManager]. See [class ActionController].

@export var input_str: String
@export var input_type: InputManager.ActionTypes
