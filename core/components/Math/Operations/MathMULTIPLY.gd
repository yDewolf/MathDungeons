extends MathOperation

func _init() -> void:
	self.type = OperationTypes.MULTIPLY

func solve_values(variables: Array[AlgebraVariable]) -> AlgebraVariable:
	var total: AlgebraVariable = AlgebraVariable.new(1)
	for variable in variables:
		total.set_value(total.get_value() * variable.get_value())
	
	return total
