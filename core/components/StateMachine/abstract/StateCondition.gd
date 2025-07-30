extends Node
class_name StateCondition

@export_category("Metadata")
@export var condition_name: String
var match_callable: Callable
var matching: bool = false

signal condition_matches()

func matches():
	var condition = match_callable.call()
	if condition:
		condition_matches.emit()
	
	matching = condition
	return condition
