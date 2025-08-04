extends Node

@export var expression_string: String = "1 + 1"

func _ready() -> void:
	var result = MathExpression.create_from_string(expression_string)
	print(result)
