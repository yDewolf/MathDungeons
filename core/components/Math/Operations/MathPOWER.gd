extends MathOperation

func _init() -> void:
	self.type = OperationTypes.POWER

func solve_values(variables: Array[AlgebraVariable]) -> AlgebraVariable:
	return AlgebraVariable.new(
		pow(variables[0].get_value(), variables[1].get_value())
	)
