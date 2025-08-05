extends MathOperation

func _init() -> void:
	self.type = OperationTypes.DIVIDE


func solve_values(variables: Array[AlgebraVariable]) -> AlgebraVariable:
	#var total: AlgebraVariable = AlgebraVariable.new()
	#for variable in variables:
		#total.set_value(total.get_value() + variable.get_value())
	
	#return total
	return AlgebraVariable.new(
		variables[0].get_value() / variables[1].get_value()
	)
