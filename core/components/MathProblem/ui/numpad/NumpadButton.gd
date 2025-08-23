extends Button
class_name NumpadButton

enum ButtonTypes {
	VALUE,
	INFINITE_VALUE,
	BACKSPACE,
	CLEAR,
	EQUALS,
	DECIMAL_SEPARATOR,
	NEGATIVE_NUMBER
}

@export var value: int = -1
@export var type: ButtonTypes = ButtonTypes.VALUE

signal pressed_button(button)

func _ready() -> void:
	if self.type == ButtonTypes.VALUE and self.value == -1:
		self.value = self.name.to_int()
	
	self.pressed.connect(on_button_pressed)

func on_button_pressed():
	self.pressed_button.emit(self.type, self.value)
