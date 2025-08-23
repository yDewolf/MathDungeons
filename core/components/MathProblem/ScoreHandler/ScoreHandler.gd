extends Node
class_name ScoreHandler

@export var expression_handler: ExpressionHandler

@export var score_view: RichTextLabel
@export var combo_view: RichTextLabel

@export var miss_count_label: RichTextLabel
var miss_count: int = 0:
	set(value):
		miss_count = value
		miss_count_label.text = "Misses: " + str(miss_count)
@export var correct_answers_label: RichTextLabel
var total_correct_answers: int = 0:
	set(value):
		total_correct_answers = value
		correct_answers_label.text = "Answered: " + str(total_correct_answers)


var rng: RandomEquationGen

var current_score: int:
	set(value):
		current_score = value
		print("Current Score: ", self.current_score)
		self.updated_score.emit(self.current_score)
var combo: int = 0

@export_category("General Score")
@export var general_score_multiplier: float = 0.1
var score_multiplier: float = 1.0 * general_score_multiplier
var expression_value: int = 0

## All these values will be added together and the result is the multiplier
@export_category("Score Multiplier Parameters")
@export var multiplier_per_operation: float = 0.1
@export var multiplier_per_op_type: Dictionary = {
	MathOperation.OperationTypes.ADD: 0.1,
	MathOperation.OperationTypes.SUBTRACT: 0.3,
	MathOperation.OperationTypes.DIVIDE: 0.5,
	MathOperation.OperationTypes.MULTIPLY: 0.3,
	MathOperation.OperationTypes.POWER: 0.7,
}
## 1 digit = 0.2 | 2 digits = 0.4
@export var multiplier_per_number_digit: float = 0.2
@export var multiplier_per_decimal_digit: float = 0.4

## final_multiplier = multiplier / (precision * 10)
@export var precision_multiplier: float = 0.1

@export_category("Expression Score Value Parameters")
@export var operation_value: Dictionary = {
	MathOperation.OperationTypes.ADD: 1,
	MathOperation.OperationTypes.SUBTRACT: 2,
	MathOperation.OperationTypes.DIVIDE: 5,
	MathOperation.OperationTypes.MULTIPLY: 4,
	MathOperation.OperationTypes.POWER: 10,
}

signal updated_score()

func _ready() -> void:
	miss_count = 0
	total_correct_answers = 0
	current_score = 0
	
	rng = expression_handler.random_gen
	expression_handler.generated_expression.connect(update_score_multiplier)
	expression_handler.sent_wrong_answer.connect(update_score)
	expression_handler.solved_expression.connect(update_score.bind(true))
	
	self.updated_score.connect(update_view)

func update_score_multiplier(expression: MathExpression) -> void:
	self.expression_value = calculate_expression_score_value(expression)
	self.score_multiplier = self.calculate_score_multiplier(expression)

func update_score(correct_answer: bool = false):
	if correct_answer:
		combo += 1
		total_correct_answers += 1
		self.current_score += round(expression_value * self.score_multiplier)
		return
	
	combo = 0
	miss_count += 1
	self.current_score += round(expression_value * self.score_multiplier * -1)


func update_view(score: int):
	self.score_view.text = "Score: " + str(score) + ""
	
	var combo_effects = ""
	var effects_close = ""
	if self.combo >= 5:
		combo_effects += "[wave amp=50.0 freq=5.0 connected=1]"
		effects_close += "[/wave]"
	
	if self.combo >= 7:
		combo_effects += "[rainbow freq=0.7 sat=0.8 val=1 speed=1.0]"
		effects_close = "[/rainbow]" + effects_close
	
	self.combo_view.text = combo_effects + str(self.combo) + effects_close + " Combo"


func calculate_score_multiplier(expression: MathExpression) -> float:
	var base_multiplier: float = 1.0
	var multipliers: Array[float] = []
	
	## multiplier / (precision * 10)
	multipliers.append(precision_multiplier / (self.expression_handler.precision * 10))
	
	var operations: Array[MathOperation] = expression.get_all_operations()
	for operation in operations:
		var mul: float = self.multiplier_per_op_type[operation.type]
		multipliers.append(mul)
		multipliers.append(self.multiplier_per_operation)
	
	var variables: Array[AlgebraVariable] = expression.get_all_variables()
	for variable in variables:
		var value = variable.get_value()
		var splitted: PackedStringArray = str(abs(value)).split(".")
		
		var integer_digits = len(splitted[0])
		var decimal_digits = 0
		if len(splitted) == 2:
			decimal_digits = len(splitted[1])
			multipliers.append(decimal_digits * multiplier_per_decimal_digit)
		
		multipliers.append(integer_digits * multiplier_per_number_digit)
	
	var final_multiplier: float = base_multiplier * self.general_score_multiplier
	for mul in multipliers:
		final_multiplier += mul
	
	return final_multiplier

func calculate_expression_score_value(expression: MathExpression) -> int:
	var value: int = 1
	
	var operations: Array[MathOperation] = expression.get_all_operations()
	for operation in operations:
		value += self.operation_value[operation.type]
	
	for variable in expression.get_all_variables():
		var v = abs(variable.get_value())
		if v == INF:
			continue
		
		value += v
	
	return value
