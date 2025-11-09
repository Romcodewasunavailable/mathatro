@tool
class_name CardControl
extends Control

signal card_changed()

var card: Card


func _ready() -> void:
	child_order_changed.connect(update_card)
	update_card()


func update_card() -> void:
	card = null
	for child in get_children():
		if child is Card:
			card = child
			break
	card_changed.emit()
