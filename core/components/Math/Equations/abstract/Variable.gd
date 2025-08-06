class_name AlgebraVariable

enum VariableTypes {
	NUMBER,
	UNSET,
	EXPRESSION,
	SUB_EXPRESSION
}

const NAME_PRESET = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

var type: VariableTypes = VariableTypes.NUMBER
var name: String = ""

var value: float:
	set(new_value):
		if value != new_value: self.value_changed.emit(new_value)
		value = new_value

signal value_changed(new_value)

func _init(value_: float = 0) -> void:
	self.value = value_

static func from_variable(variable: AlgebraVariable) -> AlgebraVariable:
	var new_variable = AlgebraVariable.new(variable.get_value())
	
	return new_variable


func get_value() -> float:
	return value

func set_value(new_value: float) -> void:
	self.value = new_value
