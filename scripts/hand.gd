@tool
class_name Hand
extends Control

@export var selected_index := -1:
	set(value):
		selected_index = value
		update_anchor_positions()
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

var cards: Array[Card] = []
var anchor_positions := PackedVector2Array()

var arc_center: Vector2:
	get():
		return size / 2.0 + Vector2.DOWN * arc_radius


func _ready() -> void:
	update_cards()


func _process(delta: float) -> void:
	for i in range(cards.size()):
		cards[i].position = cards[i].position.lerp(anchor_positions[i] - Card.CARD_SIZE / 2.0, lerp_speed * delta)
		cards[i].rotation = (cards[i].position + Card.CARD_SIZE / 2.0 - arc_center).angle() + PI / 2.0 + rotation_offset


func _on_resized() -> void:
	update_anchor_positions()


func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		node.mouse_entered.connect(_on_card_mouse_entered.bind(node))
		node.mouse_exited.connect(_on_card_mouse_exited.bind(node))


func _on_child_exiting_tree(node: Node) -> void:
	if node is Card:
		node.mouse_entered.disconnect(_on_card_mouse_entered)
		node.mouse_exited.disconnect(_on_card_mouse_exited)


func _on_child_order_changed() -> void:
	update_cards()


func _on_card_mouse_entered(card: Card) -> void:
	if card in cards:
		selected_index = cards.find(card)


func _on_card_mouse_exited(card: Card) -> void:
	var card_index = cards.find(card)
	if card_index == selected_index:
		selected_index = -1


func update_cards() -> void:
	cards.clear()
	for child in get_children():
		if child is Card:
			cards.append(child)
	update_anchor_positions()


func update_anchor_positions() -> void:
	var num_cards = cards.size()
	var arc_angle = min(card_angle * num_cards, max_angle)
	anchor_positions.clear()
	anchor_positions.resize(num_cards)
	for i in range(num_cards):
		var radius = arc_radius + selection_offset * int(i == selected_index)
		anchor_positions[i] = arc_center + (Vector2.UP * radius).rotated(lerpf(
			-arc_angle / 2.0,
			arc_angle / 2.0,
			i / float(num_cards - 1)
		) / absf(radius))
