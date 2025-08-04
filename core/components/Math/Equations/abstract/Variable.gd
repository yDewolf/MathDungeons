class_name AlgebraVariable

var value: float:
	set(new_value):
		if value != new_value: self.value_changed.emit(new_value)
		value = new_value

signal value_changed(new_value)

func get_value() -> float:
	return value

func set_value(new_value: float) -> void:
	self.value = new_value
