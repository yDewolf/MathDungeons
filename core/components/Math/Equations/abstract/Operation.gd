class_name MathOperation

enum OperationTypes {
	MULTIPLY,
	DIVIDE,
	ADD,
	SUBTRACT,
}

const OPERATION_STRINGS = {
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


func process() -> float:
	var variable_values: Array[float] = []
	for variable in connected_variables:
		variable_values.append(variable.get_value())
	
	var result: float = self.process_values(variable_values)
	last_result = result
	return result

static func process_values(values: Array[float]) -> float:
	return 0.0


static func sort_operations(operation_a: MathOperation, operation_b: MathOperation) -> bool:
	if OperationTypes.get(operation_a.type) < OperationTypes.get(operation_b.type):
		return true
	
	return false
