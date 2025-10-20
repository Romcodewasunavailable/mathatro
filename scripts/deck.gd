@tool
class_name Deck
extends Control

@export var card_expressions: Array[CardExpression]:
	set(value):
		card_expressions = value
		update_cards()


func update_cards() -> void:
	for child in get_children():
		child.queue_free()


func draw_card() -> Card:
	return get_child(-1)
