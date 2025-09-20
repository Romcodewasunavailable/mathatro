@tool
class_name Hand
extends Control

@export var horizontal_margin := 150.0:
	set(value):
		horizontal_margin = value
		update_anchor_positions()
@export var lerp_speed := 10.0

var cards: Array[Card] = []
var anchor_positions := PackedVector2Array()


func _process(delta: float) -> void:
	for i in range(cards.size()):
		cards[i].position = cards[i].position.lerp(anchor_positions[i], lerp_speed * delta)


func _on_resized() -> void:
	update_anchor_positions()


func _on_child_order_changed() -> void:
	cards.clear()
	for child in get_children():
		if child is Card:
			cards.append(child)
	update_anchor_positions()


func update_anchor_positions() -> void:
	anchor_positions.clear()
	anchor_positions.resize(cards.size())
	for i in range(cards.size()):
		anchor_positions[i] = Vector2(
			lerpf(
				horizontal_margin,
				size.x - horizontal_margin,
				i / float(cards.size() - 1)
			),
			size.y / 2.0,
		)
