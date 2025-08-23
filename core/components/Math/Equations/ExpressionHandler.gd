extends Node
class_name ExpressionHandler

@export var sample_string: String = "-10 - -5"
@export var random_gen: RandomEquationGen
@export var precision: float = 0.1

@export_group("Nodes")
#@export var expression_vbox: VBoxContainer
#@export var scroll_container: ScrollContainer

@export var view_holder: MathExpressionHolder
var expression_view: MathExpressionView
var target_result: AlgebraVariable

@export var warn_label: RichTextLabel
@export var virtual_numpad: VirtualNumpad

@export_group("Packed Scenes")
@export var expression_holder_scene: PackedScene

signal generated_expression(expression)
signal solved_expression()
signal sent_wrong_answer()

func _ready() -> void:
	expression_view = view_holder.expression_view
	virtual_numpad.send_result.connect(check_result)
	generateNewExpression()

func generateNewExpression() -> void:
	#var expression_holder: MathExpressionHolder = expression_holder_scene.instantiate()
	#expression_view = expression_holder.expression_view
	
	var expression_string = random_gen.generate_expression_string()
	var expression = MathExpression.create_from_string(expression_string)
	self.generated_expression.emit(expression)
	self.target_result = expression.solve()
	
	#expression_vbox.add_child(expression_holder)
	update_view(expression_string)
	await get_tree().process_frame
	#scroll_container.ensure_control_visible(expression_holder)

func update_view(string: String):
	expression_view.show_expression(string)
	print(self.target_result.get_value())

func check_result(inputted_value: float) -> void:
	var rounded_result: float = snapped(floorf(target_result.get_value() / precision) * precision, precision)
	var value: float = snapped(floorf(inputted_value / precision) * precision, precision)
	warn_label.visible = true
	var timer = get_tree().create_timer(1.2)
	timer.timeout.connect(hide_warn_label)
	
	if value == rounded_result:
		expression_view.text += " = [color=purple]" + str(value)
		self.solved_expression.emit()
		generateNewExpression()
		warn_label.text = "[color=green]Acertou!!"
		virtual_numpad.clear_value()
		return
	
	self.sent_wrong_answer.emit()
	warn_label.text = "[color=red]Errou..."

func hide_warn_label() -> void:
	warn_label.visible = false
