@tool
class_name Card
extends Control

signal hovering_changed()
signal dragging_changed()

const SIZE = Vector2(200.0, 280.0)
const SCENE = preload("res://scenes/card.tscn")

static var hovering: Card
static var dragging: Card

@export var expression: LatexExpression:
	set(value):
		if expression != null:
			expression.changed.disconnect(update_latex)
		expression = value
		if expression != null:
			expression.changed.connect(update_latex)
		if is_node_ready():
			update_latex()
@export var face_up := true:
	set(value):
		face_up = value
		if not is_node_ready():
			return
		elif face_up:
			animation_player.play("face_up")
		else:
			animation_player.play_backwards("face_up")

@export var drag_rotation_strength := 0.0001
@export var rotation_lerp_speed := 10.0

@export var latexture_rect: TextureRect
@export var back_face: Control
@export var animation_player: AnimationPlayer

var previous_position: Vector2


static func from_expression(expression: LatexExpression) -> Card:
	var new_card: Card = SCENE.instantiate()
	new_card.expression = expression
	return new_card


func _ready() -> void:
	update_latex()
	back_face.visible = not face_up


func _process(delta: float) -> void:
	if previous_position == null:
		previous_position = position
	var velocity = (position - previous_position) / delta
	if velocity.length() * delta > 250.0:
		velocity = Vector2.ZERO
	previous_position = position

	if dragging == self or get_parent() is not Hand:
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


func update_latex() -> void:
	latexture_rect.LatexExpression = expression.latex if expression != null else ""
	latexture_rect.Render()


func compose(other: Card) -> void:
	if expression != null and other.expression != null:
		expression.compose(other.expression)


func evaluate(x: Variant = 0.0) -> Variant:
	return expression.evaluate(x) if expression != null else 0.0


func _on_mouse_entered():
	if dragging == null or get_parent() is not Hand:
		hovering = self
		hovering_changed.emit()


func _on_mouse_exited():
	if hovering == self:
		hovering = null
		hovering_changed.emit()
