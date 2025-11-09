@tool
class_name Playfield
extends Control

@export var level_file_name: String:
	set(value):
		level_file_name = value
		level = load(Level.DIR_PATH.path_join(level_file_name))
@export_tool_button("Start Level") var start_level_action = start_level

@export var hand: Hand
@export var stack: Stack
@export var slot_container: SlotContainer
@export var goal_latexture_rect: TextureRect

var level: Level


func _ready() -> void:
	start_level()


func clear() -> void:
	for card in hand.get_children():
		card.queue_free()
	for card in stack.get_children():
		card.queue_free()
	for slot in slot_container.get_children():
		slot.queue_free()


func start_level() -> void:
	if level == null:
		return

	clear()

	goal_latexture_rect.LatexExpression = level.win_condition.latex
	goal_latexture_rect.Render()

	for expression in level.hand_expressions:
		hand.add_child(Card.from_expression(expression))
	stack.add_child(Card.from_expression(level.start_value))
	#for expression in level.slot_expressions:
		#var new_slot = Slot.new()
		#slot_container.add_child(new_slot)
		#if expression != null:
			#new_slot.add_child(Card.from_expression(expression))
