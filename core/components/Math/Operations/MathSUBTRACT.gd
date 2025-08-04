extends MathOperation

func _init() -> void:
	self.type = OperationTypes.SUBTRACT

func solve_values(values: Array[float]) -> float:
	return values[0] - values[1]
