extends AlgebraVariable
class_name MathExpression

var expression_map: Array
const OPERATION_FOLDER: String = "res://core/components/Math/Operations/"

var priority: int = 0

func _init() -> void:
	self.type = AlgebraVariable.VariableTypes.EXPRESSION

func solve() -> AlgebraVariable:
	var current_step: int = 0
	var current_map: Array = expression_map.duplicate()
	var last_result: AlgebraVariable = AlgebraVariable.new(0)
	
	#var start_time: int = Time.get_ticks_usec()
	
	var sub_expressions: Array[MathExpression] = MathExpression._get_sub_expressions(current_map, true)
	var operations: Array[MathOperation] = MathExpression._get_operations(current_map, true)
	
	while true:
		current_step += 1
		if sub_expressions.is_empty():
			if operations.is_empty():
				break
			
			last_result = solve_next_operation(operations, current_map)
		
		if sub_expressions.is_empty():
			break
		
		last_result = solve_next_sub_expression(sub_expressions, current_map)
		if last_result == null:
			continue
	
	#print_rich("[color=orange]DEBUG: [color=white]TOOK [color=cyan]", Time.get_ticks_usec() - start_time, "us[color=white] to solve a equation")
	
	return last_result

func solve_next_sub_expression(expressions: Array[MathExpression], current_map: Array) -> AlgebraVariable:
	if expressions.is_empty():
		return
	
	var target_expression: MathExpression = expressions[0]
	expressions.remove_at(0)
	
	## Solve the operation with highest priority
	var result = target_expression.solve()
	var idx: int = current_map.find(target_expression)
	#current_map.remove_at(idx)
	#current_map.insert(idx, result)
	
	return result

func solve_next_operation(operations: Array[MathOperation], current_map: Array) -> AlgebraVariable:
	if operations.is_empty():
		return
	
	var target_operation: MathOperation = operations[0]
	var result = target_operation.solve()
	print("Solving: ", target_operation.connected_variables[0].value ," ", target_operation.OPERATION_STRINGS.get(target_operation.type), " ", target_operation.connected_variables[1].value)
	
	## Replace the operation and its variables to its result
	var current_op_position: int = current_map.find(target_operation)
	var offset_amount: int = 0
	for variable in target_operation.connected_variables:
		var idx = current_map.find(variable)
		current_map.remove_at(idx)
		if idx < current_op_position:
			current_op_position -= 1
	
	operations.remove_at(0)
	#current_map.remove_at(current_op_position)
	#current_map.insert(current_op_position, AlgebraVariable.from_variable(result))
	
	return result


func get_value() -> float:
	return self.solve().get_value()


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
	
	var operations: Array[MathOperation] = MathExpression._get_operations(new_expression_map, true)
	for operation in operations:
		var idx: int = new_expression_map.find(operation)
		var variables: Array[AlgebraVariable] = [
			new_expression_map[idx - 1], new_expression_map[idx + 1]
		]
		#if operation.type == MathOperation.OperationTypes.SUBTRACT:
			#operation = MathExpression.parse_operation(MathOperation.OperationTypes.ADD)
			#variables[1].set_value(-variables[1].get_value())
		
		operation.connect_to_variables(variables)
		
		var sub_expression: SubMathExpression = SubMathExpression.from_operation(operation)
		new_expression_map[idx] = sub_expression
		
		new_expression_map.erase(variables[0])
		new_expression_map.erase(variables[1])
	
	var new_expression: MathExpression = MathExpression.new()
	new_expression.expression_map = new_expression_map
	
	return new_expression




func get_sub_expressions(sorted: bool) -> Array[MathExpression]:
	return MathExpression._get_sub_expressions(self.expression_map, sorted) 

func get_operations(sorted: bool = false) -> Array[MathOperation]:
	return MathExpression._get_operations(self.expression_map, sorted)

func get_variables() -> Array[AlgebraVariable]:
	return MathExpression._get_variables(self.expression_map)


static func _get_sub_expressions(map: Array, sorted: bool = false) -> Array[MathExpression]:
	var expressions: Array[MathExpression] = []
	for part in map:
		if part is MathExpression:
			expressions.append(part)
	
	if sorted:
		expressions.sort_custom(MathExpression.sort_expressions)
	
	return expressions

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

static func parse_operation(operation_idx: int) -> MathOperation:
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


static func sort_expressions(expression_a: MathExpression, expression_b: MathExpression) -> bool:
	if expression_a.priority < expression_b.priority:
		return true
	
	return false
