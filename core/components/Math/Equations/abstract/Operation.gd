class_name MathOperation

enum OperationTypes {
	POWER,
	MULTIPLY,
	DIVIDE,
	ADD,
	SUBTRACT,
}

const OPERATION_PRIORITIES = {
	OperationTypes.POWER: 0,
	OperationTypes.DIVIDE: 1,
	OperationTypes.MULTIPLY: 1,
	OperationTypes.SUBTRACT: 2,
	OperationTypes.ADD: 2,
}

const OPERATION_STRINGS = {
	OperationTypes.POWER: "^",
	OperationTypes.MULTIPLY: "*",
	OperationTypes.DIVIDE: "/",
	OperationTypes.ADD: "+",
	OperationTypes.SUBTRACT: "-",
}

var type: OperationTypes
var last_result: AlgebraVariable:
	set(value):
		if last_result != value: self.last_result_changed.emit(value)
		last_result = value

var connected_variables: Array[AlgebraVariable]

signal last_result_changed(new_value)

func connect_to_variables(variables: Array[AlgebraVariable]) -> void:
	self.connected_variables = variables


func solve() -> AlgebraVariable:
	var variable_values: Array[AlgebraVariable] = []
	for variable in connected_variables:
		variable_values.append(variable)
	
	var result: AlgebraVariable = self.solve_values(variable_values)
	last_result = result
	return result

func is_solveable() -> bool:
	for variable in self.connected_variables:
		if variable.type == AlgebraVariable.VariableTypes.UNSET:
			return false
	
	return true

## Should be overrided
func solve_values(values: Array[AlgebraVariable]) -> AlgebraVariable:
	return AlgebraVariable.new()


static func sort_operations(operation_a: MathOperation, operation_b: MathOperation) -> bool:
	if OPERATION_PRIORITIES.get(operation_a.type) < OPERATION_PRIORITIES.get(operation_b.type):
		return true
	
	return false
