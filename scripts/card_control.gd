@tool
class_name CardControl
extends Control

signal cards_changed()

var cards: Array[Card] = []


func _ready() -> void:
	child_order_changed.connect(_on_child_order_changed)
	update_cards()


func _on_child_order_changed() -> void:
	update_cards()


func update_cards() -> void:
	cards.clear()
	for child in get_children():
		if child is Card:
			cards.append(child)
	cards_changed.emit()
