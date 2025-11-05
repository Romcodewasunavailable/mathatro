@tool
class_name Playfield
extends Control

@export var level: Level
@export_tool_button("Start Level") var start_level_action = start_level

@export var hand: Hand
@export var stack: Stack
@export var slot_container: SlotContainer


func clear() -> void:
	for card in hand.get_children():
		card.queue_free()
	for card in stack.get_children():
		card.queue_free()
	for slot in slot_container.get_children():
		slot.queue_free()


func start_level(level_path := "") -> void:
	if not level_path.is_empty():
		level = load(level_path)

	clear()

	for expression in level.hand_expressions:
		hand.add_child(Card.from_expression(expression))
	stack.add_child(Card.from_expression(level.start_value))
	#for expression in level.slot_expressions:
		#var new_slot = Slot.new()
		#slot_container.add_child(new_slot)
		#if expression != null:
			#new_slot.add_child(Card.from_expression(expression))
