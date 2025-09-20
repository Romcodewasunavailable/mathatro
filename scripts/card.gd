@tool
class_name Card
extends Node2D

const CARD_SCENE = preload("res://scenes/card.tscn")

@export_multiline var evaluation_expression: String:
	set(value):
		evaluation_expression = value
		var error = expression.parse(evaluation_expression, ["x"])
		if latex_expression.is_empty() and is_node_ready():
			update_latex()
		if error != OK:
			push_error(expression.get_error_text())
@export_multiline var latex_expression: String:
	set(value):
		latex_expression = value
		if is_node_ready():
			update_latex()

@export var latexture_rect: TextureRect

var expression := Expression.new()


static func from_expression(evaluation_expression: String, latex_expression := "") -> Card:
	var new_card: Card = CARD_SCENE.instantiate()
	new_card.evaluation_expression = evaluation_expression
	new_card.latex_expression = latex_expression
	return new_card


func _ready() -> void:
	update_latex()


func update_latex() -> void:
	latexture_rect.LatexExpression = evaluation_expression if latex_expression.is_empty() else latex_expression
	latexture_rect.Render()


func evaluate(x: float) -> float:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return 0.0
	return result
