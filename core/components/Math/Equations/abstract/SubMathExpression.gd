extends MathExpression
class_name SubMathExpression

func _init() -> void:
	self.type = MathExpression.VariableTypes.SUB_EXPRESSION

static func from_operation(operation: MathOperation) -> SubMathExpression:
	var new_expression: SubMathExpression = SubMathExpression.new()
	operation.last_result_changed.connect(new_expression.update_value_as_last_result)
	new_expression.priority = operation.type
	## TODO: REMAKE THIS LATER (THIS CAN BE A REALLY BAD PROBLEM FOR MULTIPLE VARIABLE SYSTEMS)
	new_expression.expression_map = [
		operation.connected_variables[0],
		operation,
		operation.connected_variables[1]
	]
	
	return new_expression

func update_value_as_last_result(new_value: AlgebraVariable) -> void:
	self.set_value(new_value.get_value())
