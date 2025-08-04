extends MathOperation

func _init() -> void:
	self.type = OperationTypes.POWER

func solve_values(values: Array[float]) -> float:
	return pow(values[0], values[1])
