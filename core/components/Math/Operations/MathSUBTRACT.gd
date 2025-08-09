extends MathOperation

func _init() -> void:
	self.type = OperationTypes.SUBTRACT

func solve_values(variables: Array[AlgebraVariable]) -> AlgebraVariable:
	return AlgebraVariable.new(
		variables[0].get_value() - variables[1].get_value()
	)
