extends Node

@export var sample_string: String = "-10 - -5"
@export var random_gen: RandomEquationGen
@export var precision: float = 0.1

@export var expression_view: MathExpressionView
var target_result: AlgebraVariable

@export var input_text: TextEdit
@export var input_result: float

func _ready() -> void:
	input_text.text_changed.connect(check_result)
	generateNewExpression()

func generateNewExpression() -> void:
	var expression_string = random_gen.generate_expression_string()
	var expression = MathExpression.create_from_string(expression_string)
	
	self.target_result = expression.solve()
	
	update_view(expression_string)

func update_view(string: String):
	expression_view.show_expression(string)
	print(self.target_result.get_value())


func check_result() -> void:
	if input_text.text == "":
		return
	
	var inputted = input_text.text
	
	var rounded_result: float = snapped(target_result.get_value(), precision)
	var value: float = inputted.to_float()
	if rounded_result == value:
		generateNewExpression()
		print("Acertou!!")
		input_text.text = ""
		return
	
	print("Errou")
