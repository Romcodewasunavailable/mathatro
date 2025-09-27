@tool
class_name Card
extends Control

const CARD_SIZE = Vector2(200.0, 280.0)
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
@export var drag_rotation_strength := 0.0001
@export var rotation_lerp_speed := 10.0

@export var latexture_rect: TextureRect

var expression := Expression.new()
var dragging := false
var previous_position: Vector2


static func from_expression(evaluation_expression: String, latex_expression := "") -> Card:
	var new_card: Card = CARD_SCENE.instantiate()
	new_card.evaluation_expression = evaluation_expression
	new_card.latex_expression = latex_expression
	return new_card


func _ready() -> void:
	update_latex()


func _process(delta: float) -> void:
	if get_parent() is Hand:
		return

	if previous_position == null:
		previous_position = position
	var velocity = (position - previous_position) / delta
	rotation = lerpf(rotation, drag_rotation_strength * velocity.x, rotation_lerp_speed * delta)
	previous_position = position


func _input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseMotion:
		position += event.relative
	elif event.is_action_released("click"):
		dragging = false


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var parent = get_parent()
		if parent is Hand and self == parent.get_child(parent.selected_index):
			reparent(parent.get_parent())
		dragging = true


func update_latex() -> void:
	latexture_rect.LatexExpression = evaluation_expression if latex_expression.is_empty() else latex_expression
	latexture_rect.Render()


func evaluate(x: float) -> float:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return 0.0
	return result
