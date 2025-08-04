extends AlgebraVariable
class_name MathExpression

var variables: Array[AlgebraVariable]
var operations: Array[MathOperation]

func solve() -> float:
	operations.sort_custom(MathOperation.sort_operations)
	## [(A + B) - C]
	var current_value: float = 0.0
	for operation: MathOperation in operations:
		pass
	
	return self.value

func get_value() -> float:
	return self.solve()


## Expression format:
## a + b
## Example:
## 7 / 3 + 3
static func create_from_string(expression_string: String) -> MathExpression:
	var splitted: PackedStringArray = expression_string.split(" ")
	for charactere in splitted:
		var value = MathExpression.parse_syntax(charactere)
		print(value)
	
	var new_expression: MathExpression = MathExpression.new()
	
	return new_expression

static func parse_syntax(charactere: String):
	var operation_idx = MathOperation.OPERATION_STRINGS.values().find(charactere)
	if operation_idx != -1:
		return MathExpression.parse_operation(operation_idx)
	
	var value_modifier: int = 1
	if charactere.begins_with("-"):
		charactere.erase(0)
		value_modifier = -1
	
	return charactere.to_int()

static func parse_operation(operation_idx: int):
	var operation_key = MathOperation.OPERATION_STRINGS.keys()[operation_idx]
	
	return operation_key
