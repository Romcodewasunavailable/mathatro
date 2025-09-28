@tool
class_name Card
extends Control

signal hovering_changed()
signal dragging_changed()

const CARD_SIZE = Vector2(200.0, 280.0)
const CARD_SCENE = preload("res://scenes/card.tscn")

static var hovering: Card
static var dragging: Card

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
	if velocity.length() * delta > 250.0:
		print(velocity.length() * delta)
		velocity = Vector2.ZERO
	previous_position = position

	if dragging or get_parent() is not Hand:
		rotation = lerpf(rotation, drag_rotation_strength * velocity.x, rotation_lerp_speed * delta)


func _input(event: InputEvent) -> void:
	if hovering == self and event.is_action_pressed("click") and get_parent() is not Stack:
		dragging = self
		z_index = 1
		dragging_changed.emit()
	elif event.is_action_released("click"):
		if dragging == self:
			dragging = null
			z_index = 0
			dragging_changed.emit()
			if hovering == self:
				hovering = null
				hovering_changed.emit()
			elif hovering != null and hovering.get_parent() is Stack:
				reparent(hovering.get_parent())
				compose(hovering)
	elif dragging == self and event is InputEventMouseMotion:
		position += event.relative


func _on_mouse_entered():
	if dragging == null or get_parent() is not Hand:
		hovering = self
		hovering_changed.emit()


func _on_mouse_exited():
	if hovering == self:
		hovering = null
		hovering_changed.emit()


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
