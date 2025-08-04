extends AlgebraVariable
class_name MathExpression

var expression_map: Array
const OPERATION_FOLDER: String = "res://core/components/Math/Operations/"

func _init() -> void:
	self.type = AlgebraVariable.VariableTypes.EXPRESSION

func solve() -> float:
	var current_step: int = 0
	var current_map: Array = expression_map.duplicate()
	var last_result: float = 0
	
	var start_time: int = Time.get_ticks_usec()
	while true:
		current_step += 1
		var operations: Array[MathOperation] = MathExpression._get_operations(current_map, true)
		## Solve the operation with highest priority
		var result = operations[0].solve()
		last_result = result
		## Replace the operation and its variables to its result
		var current_op_position: int = current_map.find(operations[0])
		var offset_amount: int = 0
		for variable in operations[0].connected_variables:
			var idx = current_map.find(variable)
			current_map.remove_at(idx)
			if idx < current_op_position:
				current_op_position -= 1
		
		current_map.remove_at(current_op_position)
		current_map.insert(current_op_position, AlgebraVariable.new(result))
		operations.remove_at(0)
		
		## Update other operations:
		if operations.is_empty():
			break
		
		for idx in range(len(current_map)):
			var part = current_map[idx]
			if part is MathOperation:
				var values: Array[AlgebraVariable] = [
					current_map[idx - 1], current_map[idx + 1]
				]
				part.connect_to_variables(values)
	
	print_rich("[color=orange]DEBUG: [color=white]TOOK [color=cyan]", Time.get_ticks_usec() - start_time, "us[color=white] to solve a equation")
	
	return last_result

func get_value() -> float:
	return self.solve()


## Expression format:
## a + b
## Example:
## 7 / 3 + 3
static func create_from_string(expression_string: String) -> MathExpression:
	var splitted: PackedStringArray = expression_string.split(" ")
	
	var new_expression_map: Array = []
	## Parse string to classes
	for charactere in splitted:
		var part = MathExpression.parse_syntax(charactere)
		new_expression_map.append(part)
	
	## Connect operations
	for idx in range(len(new_expression_map)):
		var part = new_expression_map[idx]
		if part is MathOperation:
			var values: Array[AlgebraVariable] = [
				new_expression_map[idx - 1], new_expression_map[idx + 1]
			]
			part.connect_to_variables(values)
	
	var new_expression: MathExpression = MathExpression.new()
	new_expression.expression_map = new_expression_map
	
	return new_expression

func get_operations(sorted: bool = false) -> Array[MathOperation]:
	return MathExpression._get_operations(self.expression_map, sorted)

func get_variables() -> Array[AlgebraVariable]:
	return MathExpression._get_variables(self.expression_map)


static func _get_operations(map: Array, sorted: bool = false) -> Array[MathOperation]:
	var operations: Array[MathOperation] = []
	for part in map:
		if part is MathOperation:
			operations.append(part)
	
	if sorted:
		operations.sort_custom(MathOperation.sort_operations)
	
	return operations

static func _get_variables(map: Array) -> Array[AlgebraVariable]:
	var variables: Array[AlgebraVariable] = []
	for part in map:
		if part is AlgebraVariable:
			variables.append(part)
	
	return variables


static func parse_syntax(charactere: String):
	var operation_idx = MathOperation.OPERATION_STRINGS.values().find(charactere)
	if operation_idx != -1:
		return MathExpression.parse_operation(operation_idx)
	
	return MathExpression.parse_variable(charactere)

static func parse_operation(operation_idx: int):
	var operation_key = MathOperation.OPERATION_STRINGS.keys()[operation_idx]
	
	var keys = MathOperation.OperationTypes.keys()
	var path = MathExpression.OPERATION_FOLDER + "Math" + MathOperation.OperationTypes.keys()[operation_idx] + ".gd"
	var class_script = load(path)
	var operation: MathOperation = class_script.new()
	
	return operation

static func parse_variable(charactere: String) -> AlgebraVariable:
	var value_modifier: int = 1
	if charactere.begins_with("-"):
		charactere.erase(0)
		value_modifier = -1
	
	elif charactere.begins_with("+"):
		charactere.erase(0)
	
	var value: float = charactere.to_float()
	var variable: AlgebraVariable = AlgebraVariable.new(value)
	if not charactere.is_valid_float():
		variable.type = AlgebraVariable.VariableTypes.UNSET
		variable.name = charactere
	
	return variable
