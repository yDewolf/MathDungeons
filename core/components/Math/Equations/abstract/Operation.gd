class_name MathOperation

enum OperationTypes {
	POWER,
	MULTIPLY,
	DIVIDE,
	ADD,
	SUBTRACT,
}

const OPERATION_STRINGS = {
	OperationTypes.POWER: "^",
	OperationTypes.MULTIPLY: "*",
	OperationTypes.DIVIDE: "/",
	OperationTypes.ADD: "+",
	OperationTypes.SUBTRACT: "-",
}

var type: OperationTypes
var last_result: float

var connected_variables: Array[AlgebraVariable]

func connect_to_variables(variables: Array[AlgebraVariable]) -> void:
	self.connected_variables = variables


func solve() -> float:
	var variable_values: Array[float] = []
	for variable in connected_variables:
		variable_values.append(variable.get_value())
	
	var result: float = self.solve_values(variable_values)
	last_result = result
	return result

func is_solveable() -> bool:
	for variable in self.connected_variables:
		if variable.type == AlgebraVariable.VariableTypes.UNSET:
			return false
	
	return true

## Should be overrided
func solve_values(values: Array[float]) -> float:
	return 0.0


static func sort_operations(operation_a: MathOperation, operation_b: MathOperation) -> bool:
	if operation_a.type < operation_b.type:
		return true
	
	return false
