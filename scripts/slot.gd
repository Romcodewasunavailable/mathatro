@tool
class_name Slot
extends CardControl

signal hovering_changed()

const SCENE = preload("res://scenes/slot.tscn")

static var hovering: Slot

@export var locked := false:
	set(value):
		locked = value
		if is_node_ready():
			update_lock_icon()

@export var lock_icon: Control


static func from_expression(expression: LatexExpression = null) -> Slot:
	var new_slot: Slot = SCENE.instantiate()
	if expression != null:
		var new_card = Card.from_expression(expression)
		new_slot.add_child(new_card)
		new_slot.locked = true
	return new_slot


func _ready() -> void:
	super._ready()
	update_lock_icon()


func _process(delta: float) -> void:
	if card != null:
		card.position = card.position.lerp(Vector2.ZERO, Card.DRAG_POSITION_LERP_SPEED * delta)
		card.rotation = lerp_angle(card.rotation, 0.0, Card.ROTATION_LERP_SPEED * delta)


func update_lock_icon() -> void:
	lock_icon.visible = locked


func _on_mouse_entered() -> void:
	if card == null:
		hovering = self
		hovering_changed.emit()


func _on_mouse_exited() -> void:
	if hovering == self:
		hovering = null
		hovering_changed.emit()
