class_name AlgebraVariable

enum VariableTypes {
	NUMBER,
	UNSET,
	EXPRESSION
}

var type: VariableTypes = VariableTypes.NUMBER
var name: String = ""

var value: float:
	set(new_value):
		if value != new_value: self.value_changed.emit(new_value)
		value = new_value

signal value_changed(new_value)

func _init(value: float = 0) -> void:
	self.value = value

func get_value() -> float:
	return value

func set_value(new_value: float) -> void:
	self.value = new_value
