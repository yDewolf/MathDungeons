@icon("res://core/components/ActionController/assets/window-action-icon.png")
extends Action
class_name WindowAction

## Class for actions that rely on a [class WindowState] being active.

@export var window_state: WindowState

func can_activate():
	var super_condition = super.can_activate()
	
	return window_state.active and super_condition
