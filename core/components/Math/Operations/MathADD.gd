extends MathOperation

func _init() -> void:
	self.type = OperationTypes.ADD

func solve_values(values: Array[float]) -> float:
	var total: float = 0
	for value in values:
		total += value
	
	return total
