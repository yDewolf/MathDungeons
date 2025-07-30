extends Node
class_name ActivationType

## When [member active] is [code]true[/code] [br]
## [class ActionController] will call [method Action.start_action] [br]
## if [member inverse] is [code]true[/code] and [member active] is [code]true[/code]
## it will call [method Action.stop_action]
@export var toggleable: bool

@export var inverse: bool

@export_category("State")
@export var active: bool:
	set(value):
		if active != value:
			if toggleable:
				inverse = !inverse
			changed_active.emit()
		
		active = value

signal changed_active()
