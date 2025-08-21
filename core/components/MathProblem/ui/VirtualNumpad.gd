extends MarginContainer
class_name VirtualNumpad

var number: float:
	get():
		return number_string.to_float()

var number_string: String = "":
	set(value):
		number_string = value
		update_preview_text()

@export var number_grid: GridContainer
@export var action_column: VBoxContainer

@export var preview_label: RichTextLabel
const NUMBER_INPUTS: Array[String] = [
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
]

signal send_result(value)

func _ready() -> void:
	self.connectNumberButtons()
	self.connectActionButtons()

func _physics_process(_delta: float) -> void:
	for input in NUMBER_INPUTS:
		if Input.is_action_just_pressed(input):
			self.parse_action(input, input)
			return
	
	if Input.is_action_just_pressed("backspace"):
		self.parse_action("backspace", "")
		return
	
	if Input.is_action_just_pressed("clear"):
		self.parse_action("clear", "")
		return
	
	if Input.is_action_just_pressed("inf"):
		self.parse_action("inf", "")
		return
	
	if Input.is_action_just_pressed("minus"):
		self.parse_action("minus", "")
		return
	
	if Input.is_action_just_pressed("dot"):
		self.parse_action("dot", "")
		return
	
	if Input.is_action_just_pressed("equals"):
		self.parse_action("equals", "")
		return


func connectNumberButtons() -> void:
	var number_buttons: Array[Node] = number_grid.get_children()
	for button in number_buttons:
		if button is Button:
			button.pressed.connect(self.on_button_pressed.bind(button))

func connectActionButtons() -> void:
	var buttons: Array[Node] = action_column.get_children()
	for button in buttons:
		if button is Button:
			button.pressed.connect(self.on_button_pressed.bind(
				button)
			)


func clear_value() -> void:
	self.number_string = ""

func update_preview_text():
	preview_label.text = number_string


func on_button_pressed(button: Button) -> void:
	self.parse_action(button.name.to_lower(), button.text.to_lower())

func parse_action(action_name: String, action_value: String) -> void:
	if action_name == "backspace":
		if number_string.is_empty():
			return
		
		number_string = number_string.erase(len(number_string) - 1)
		return
	
	if action_name == "clear":
		number_string = ""
		return
	
	if action_name == "inf":
		number_string = str(INF)
		send_result.emit(INF)
		return
	
	if action_name == "minus":
		if number_string.begins_with("-"):
			number_string = number_string.lstrip("-")
			return
		
		number_string = "-" + number_string
		return
	
	if action_name == "dot":
		number_string += "."
		return
	
	if action_name == "equals":
		send_result.emit(self.number)
		return
	
	number_string += action_value.to_lower()
