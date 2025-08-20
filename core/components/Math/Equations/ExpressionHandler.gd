extends Node

@export var sample_string: String = "-10 - -5"
@export var random_gen: RandomEquationGen
@export var precision: float = 0.1

@export var expression_vbox: VBoxContainer

var expression_view: MathExpressionView
var target_result: AlgebraVariable

@export var warn_label: RichTextLabel
@export var input_text: LineEdit
@export var submit_button: Button
@export var input_result: float

@export_group("Packed Scenes")
@export var expression_holder_scene: PackedScene

func _ready() -> void:
	input_text.text_submitted.connect(check_result)
	submit_button.pressed.connect(submit_result)
	generateNewExpression()

func generateNewExpression() -> void:
	var expression_holder: MathExpressionHolder = expression_holder_scene.instantiate()
	expression_view = expression_holder.expression_view
	
	var expression_string = random_gen.generate_expression_string()
	var expression = MathExpression.create_from_string(expression_string)
	self.target_result = expression.solve()
	
	expression_vbox.add_child(expression_holder)
	update_view(expression_string)

func update_view(string: String):
	expression_view.show_expression(string)
	print(self.target_result.get_value())

func submit_result() -> void:
	self.check_result(input_text.text)

func check_result(text: String) -> void:
	if text == "":
		return
	
	var inputted = text
	
	var rounded_result: float = snapped(target_result.get_value(), precision)
	var value: float = snapped(inputted.to_float(), precision)
	warn_label.visible = true
	var timer = get_tree().create_timer(1.2)
	timer.timeout.connect(hide_warn_label)
	
	if inputted.to_lower() == "inf":
		rounded_result = INF
	
	if rounded_result == value:
		expression_view.text += " = [color=purple]" + str(value)
		generateNewExpression()
		warn_label.text = "[color=green]Acertou!!"
		
		input_text.text = ""
		return
	
	warn_label.text = "[color=red]Errou..."

func hide_warn_label() -> void:
	warn_label.visible = false
