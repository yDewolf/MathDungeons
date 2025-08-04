extends MathOperation

func _init() -> void:
	self.type = OperationTypes.MULTIPLY

func solve_values(values: Array[float]) -> float:
	var total: float = 1
	for value in values:
		total *= value
	
	return total
