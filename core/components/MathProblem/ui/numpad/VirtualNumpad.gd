extends MarginContainer
class_name VirtualNumpad

var number: float:
	get():
		return number_string.to_float()

var number_string: String = "":
	set(value):
		number_string = value
		update_preview_text()

@export var external_buttons: Array[Button]
@export var input_manager: InputManager

@export var number_grid: GridContainer
@export var action_column: VBoxContainer

@export var preview_label: RichTextLabel
const NUMBER_INPUTS: Array[String] = [
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
]

signal send_result(value)

func _ready() -> void:
	for input_number in NUMBER_INPUTS:
		self.input_manager._register_signal(input_number, InputManager.ActionTypes.PROCESS_JUST_PRESSED)
		self.input_manager.connect_signal(
			input_number, 
			InputManager.ActionTypes.PROCESS_JUST_PRESSED, 
			parse_input_number.bind(input_number.to_float())
		)
	
	for input_name in NumpadButton.ButtonTypes.keys():
		if input_name == NumpadButton.ButtonTypes.keys()[NumpadButton.ButtonTypes.VALUE]:
			continue
		
		self.input_manager.connect_signal(
			str(input_name).to_lower(),
			InputManager.ActionTypes.PROCESS_JUST_PRESSED,
			self.parse_button_pressed.bind(input_name)
		)
	
	var all_buttons: Array[NumpadButton] = self._get_child_buttons(self)
	all_buttons.append_array(self.external_buttons)
	
	for button in all_buttons:
		button.pressed_button.connect(parse_button_pressed)


func parse_input_number(input: int) -> void:
	self.parse_button_pressed(NumpadButton.ButtonTypes.VALUE, input)

func _get_child_buttons(parent: Node = self) -> Array[NumpadButton]:
	var children: Array[NumpadButton] = []
	for child in parent.get_children():
		children.append_array(self._get_child_buttons(child))
		
		if child is NumpadButton:
			children.append(child)
	
	return children


func update_preview_text():
	preview_label.text = number_string


func parse_button_pressed(type: NumpadButton.ButtonTypes, value: int) -> void:
	if type == NumpadButton.ButtonTypes.VALUE:
		number_string += str(value)
		return
	
	if type == NumpadButton.ButtonTypes.INFINITE_VALUE:
		var inf_value = INF
		if number_string.contains("-"):
			inf_value = -INF
		
		self.number_string = str(inf_value)
		self.emit_result(inf_value)
		return
	
	if type == NumpadButton.ButtonTypes.NEGATIVE_NUMBER:
		if self.number_string.begins_with("-"):
			self.number_string = self.number_string.erase(0)
			return
		
		self.number_string = "-" + self.number_string
		return
	
	if type == NumpadButton.ButtonTypes.DECIMAL_SEPARATOR:
		self.number_string += "."
		return
	
	if type == NumpadButton.ButtonTypes.BACKSPACE:
		self.number_string = self.number_string.erase(len(self.number_string) - 1)
		return
	
	if type == NumpadButton.ButtonTypes.CLEAR:
		self.number_string = ""
		return
	
	if type == NumpadButton.ButtonTypes.EQUALS:
		self.emit_result(self.number_string.to_float())
		return

func emit_result(result_value: float) -> void:
	send_result.emit(result_value)
