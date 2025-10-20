@tool
class_name Hand
extends CardControl

@export_range(0.0, 100.0) var selection_offset := 50.0:
	set(value):
		selection_offset = value
		update_anchor_positions()
@export_range(500.0, 10000.0) var arc_radius := 1500.0:
	set(value):
		arc_radius = value
		update_anchor_positions()
@export_range(0.0, 1000.0) var card_angle := 100.0:
	set(value):
		card_angle = value
		update_anchor_positions()
@export_range(0.0, 1000.0) var max_angle := 600.0:
	set(value):
		max_angle = value
		update_anchor_positions()
@export var rotation_offset := 0.0
@export var lerp_speed := 10.0
@export var rotation_lerp_speed := 10.0

var anchor_positions := PackedVector2Array()
var arc_center: Vector2:
	get():
		return size / 2.0 + Vector2.DOWN * arc_radius


func _process(delta: float) -> void:
	var i = 0
	for card in cards:
		if Card.dragging == card:
			continue
		card.position = card.position.lerp(anchor_positions[i] - Card.CARD_SIZE / 2.0, lerp_speed * delta)
		card.rotation = lerp_angle(
			card.rotation,
			(card.position + Card.CARD_SIZE / 2.0 - arc_center).angle() + PI / 2.0 + rotation_offset,
			rotation_lerp_speed * delta
		)
		i += 1


func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		node.hovering_changed.connect(_on_card_hovering_changed)
		node.dragging_changed.connect(_on_card_dragging_changed)


func _on_child_exiting_tree(node: Node) -> void:
	if node is Card:
		node.hovering_changed.disconnect(_on_card_hovering_changed)
		node.dragging_changed.disconnect(_on_card_dragging_changed)


func _on_resized() -> void:
	update_anchor_positions()


func _on_cards_changed() -> void:
	update_anchor_positions()


func _on_card_hovering_changed() -> void:
	update_anchor_positions()


func _on_card_dragging_changed() -> void:
	update_anchor_positions()


func update_anchor_positions() -> void:
	var num_cards = cards.size()
	var hand_size = num_cards - 1 if Card.dragging in cards else cards.size()
	var arc_angle = min(card_angle * hand_size, max_angle)
	anchor_positions.clear()
	anchor_positions.resize(hand_size)
	var j = 0
	for i in range(num_cards):
		if Card.dragging == cards[i]:
			continue
		var radius = arc_radius
		if Card.hovering == cards[i]:
			radius += selection_offset
		anchor_positions[j] = arc_center + (Vector2.UP * radius).rotated(lerpf(
			-arc_angle / 2.0,
			arc_angle / 2.0,
			j / float(hand_size - 1) if hand_size > 1 else 0.5
		) / absf(radius))
		j += 1
