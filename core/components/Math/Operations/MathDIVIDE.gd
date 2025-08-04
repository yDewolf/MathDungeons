extends MathOperation

func _init() -> void:
	self.type = OperationTypes.DIVIDE

func solve_values(values: Array[float]) -> float:
	#var total: float = values[0]
	#for value in values:
		#total /= value
	
	#return total
	return values[0] / values[1]
