@tool
class_name Card
extends Control

signal drag_started()
signal drag_ended()

const CARD_SIZE = Vector2(200.0, 280.0)
const CARD_SCENE = preload("res://scenes/card.tscn")

@export_multiline var evaluation_expression: String:
	set(value):
		evaluation_expression = value
		var error = expression.parse(evaluation_expression, ["x"])
		if error != OK:
			push_error(expression.get_error_text())
@export_multiline var latex_expression: String:
	set(value):
		latex_expression = value
		if is_node_ready():
			update_latex()
@export var drag_rotation_strength := 0.0001
@export var rotation_lerp_speed := 10.0

@export var latexture_rect: TextureRect

var expression := Expression.new()
var previous_position: Vector2
var dragging := false:
	set(value):
		dragging = value
		z_index = 1 if dragging else 0
		(drag_started if dragging else drag_ended).emit()


static func from_expression(evaluation_expression: String, latex_expression := "") -> Card:
	var new_card: Card = CARD_SCENE.instantiate()
	new_card.evaluation_expression = evaluation_expression
	new_card.latex_expression = latex_expression
	return new_card


func _ready() -> void:
	update_latex()


func _process(delta: float) -> void:
	if previous_position == null:
		previous_position = position
	var velocity = (position - previous_position) / delta
	previous_position = position

	if dragging:
		rotation = lerpf(rotation, drag_rotation_strength * velocity.x, rotation_lerp_speed * delta)


func _input(event: InputEvent) -> void:
	if not dragging:
		return
	if event is InputEventMouseMotion:
		position += event.relative
	elif event.is_action_released("click"):
		dragging = false


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		dragging = true


func update_latex() -> void:
	latexture_rect.LatexExpression = latex_expression
	latexture_rect.Render()


func compose(other: Card) -> void:
	evaluation_expression = evaluation_expression.replace("x", "(%s)" % other.evaluation_expression)
	latex_expression = latex_expression.replace("x", "(%s)" % other.latex_expression)


func evaluate(x: float = 0.0) -> float:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return 0.0
	return result
