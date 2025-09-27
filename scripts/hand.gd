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
@export var rotation_lerp_speed := 10.0

var cards: Array[Card] = []
var anchor_positions := PackedVector2Array()
var dragging := false:
	set(value):
		dragging = value
		update_anchor_positions()
var arc_center: Vector2:
	get():
		return size / 2.0 + Vector2.DOWN * arc_radius


func _ready() -> void:
	update_cards()


func _process(delta: float) -> void:
	var i = 0
	for card in cards:
		if card.dragging:
			continue
		card.position = card.position.lerp(anchor_positions[i] - Card.CARD_SIZE / 2.0, lerp_speed * delta)
		card.rotation = lerp_angle(
			card.rotation,
			(card.position + Card.CARD_SIZE / 2.0 - arc_center).angle() + PI / 2.0 + rotation_offset,
			rotation_lerp_speed * delta
		)
		i += 1


func _on_resized() -> void:
	update_anchor_positions()


func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		node.mouse_entered.connect(_on_card_mouse_entered.bind(node))
		node.mouse_exited.connect(_on_card_mouse_exited.bind(node))
		node.drag_started.connect(_on_card_drag_started.bind(node))
		node.drag_ended.connect(_on_card_drag_ended.bind(node))


func _on_child_exiting_tree(node: Node) -> void:
	if node is Card:
		node.mouse_entered.disconnect(_on_card_mouse_entered)
		node.mouse_exited.disconnect(_on_card_mouse_exited)
		node.drag_started.disconnect(_on_card_drag_started)
		node.drag_ended.disconnect(_on_card_drag_ended)


func _on_child_order_changed() -> void:
	update_cards()


func _on_card_mouse_entered(card: Card) -> void:
	if card in cards and not dragging:
		selected_index = cards.find(card)


func _on_card_mouse_exited(card: Card) -> void:
	if cards.find(card) == selected_index and not dragging:
		selected_index = -1


func _on_card_drag_started(_card: Card) -> void:
	dragging = true


func _on_card_drag_ended(_card: Card) -> void:
	dragging = false


func update_cards() -> void:
	cards.clear()
	for child in get_children():
		if child is Card:
			cards.append(child)
	update_anchor_positions()


func update_anchor_positions() -> void:
	var num_cards = cards.size() - 1 if dragging else cards.size()
	var arc_angle = min(card_angle * num_cards, max_angle)
	anchor_positions.clear()
	anchor_positions.resize(num_cards)
	for i in range(num_cards):
		var radius = arc_radius + selection_offset if i == selected_index and not dragging else arc_radius
		anchor_positions[i] = arc_center + (Vector2.UP * radius).rotated(lerpf(
			-arc_angle / 2.0,
			arc_angle / 2.0,
			i / float(num_cards - 1)
		) / absf(radius))
