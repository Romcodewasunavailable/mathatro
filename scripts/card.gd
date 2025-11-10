@tool
class_name Card
extends Control

signal hovering_changed()
signal dragging_changed()

const POSITION_LERP_SPEED = 10.0
const ROTATION_LERP_SPEED = 20.0
const DRAG_POSITION_LERP_SPEED = 30.0
const DRAG_ROTATION_LERP_SPEED = 10.0
const DRAG_ROTATION_STRENGTH = 0.0001
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
			animation_player.play(&"face_up")
		else:
			animation_player.play_backwards(&"face_up")

@export var latexture_rect: TextureRect
@export var back_face: Control
@export var animation_player: AnimationPlayer

var previous_position: Vector2
var drag_position: Vector2


static func from_expression(expression: LatexExpression) -> Card:
	var new_card: Card = SCENE.instantiate()
	new_card.expression = expression
	return new_card


func _ready() -> void:
	update_latex()
	back_face.visible = not face_up


func _process(delta: float) -> void:
	if (dragging == self
	and get_parent() is not Stack
	and get_parent() is not Slot):
		position = position.lerp(
			drag_position,
			DRAG_POSITION_LERP_SPEED * delta,
		)

	if previous_position == null:
		previous_position = position
	var velocity = (position - previous_position) / delta
	if velocity.length() * delta > 250.0:
		velocity = Vector2.ZERO
	previous_position = position

	if dragging == self:
		rotation = lerp_angle(
			rotation,
			DRAG_ROTATION_STRENGTH * velocity.x,
			DRAG_ROTATION_LERP_SPEED * delta,
		)


func _input(event: InputEvent) -> void:
	if (hovering == self
	and event.is_action_pressed(&"click")
	and get_parent() is not Stack
	and (get_parent() is not Slot or not get_parent().locked)):
		if get_parent() is Slot:
			reparent(get_node(^"/root/Playfield").hand)
		z_index = 2
		drag_position = position
		dragging = self
		dragging_changed.emit()

	elif event.is_action_released(&"click"):
		if dragging == self:
			z_index = 0
			dragging = null
			dragging_changed.emit()

	elif dragging == self and event is InputEventMouseMotion:
		drag_position += event.relative
		if get_parent() is Slot and Slot.hovering == null:
			reparent(get_node(^"/root/Playfield").hand)
		elif get_parent() is not Slot and Slot.hovering != null:
			reparent(Slot.hovering)


func update_latex() -> void:
	latexture_rect.LatexExpression = expression.latex if expression != null else ""
	latexture_rect.Render()


func compose(other: Card) -> void:
	if expression != null and other.expression != null:
		expression.compose(other.expression)


func evaluate(x: Variant = 0.0) -> Variant:
	return expression.evaluate(x) if expression != null else 0.0


func _on_mouse_entered() -> void:
	if dragging == null or get_parent() is not Hand:
		hovering = self
		hovering_changed.emit()


func _on_mouse_exited() -> void:
	if hovering == self:
		hovering = null
		hovering_changed.emit()
