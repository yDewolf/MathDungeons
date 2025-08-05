extends Node

@export var expression_string: String = "1 + 1"

func _ready() -> void:
	var expression = MathExpression.create_from_string(expression_string)
	var result = expression.solve()
	print(result.get_value())
