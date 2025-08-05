class_name AlgebraVariable

enum VariableTypes {
	NUMBER,
	UNSET,
	EXPRESSION,
	SUB_EXPRESSION
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

static func from_variable(variable: AlgebraVariable) -> AlgebraVariable:
	var new_variable = AlgebraVariable.new(variable.get_value())
	
	return new_variable


func get_value() -> float:
	return value

func set_value(new_value: float) -> void:
	self.value = new_value
