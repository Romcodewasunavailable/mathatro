@tool
class_name Game
extends Control

@export var round: Round

@export var stack: Stack


func _on_stack_cards_changed() -> void:
	if stack.cards.is_empty():
		return

	print(stack.cards[-1].card_expression.raw)
	print(stack.cards[-1].evaluate())
	print(round.goal.evaluate(stack.cards[-1].evaluate()))
