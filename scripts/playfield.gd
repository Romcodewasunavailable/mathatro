@tool
class_name Playfield
extends Control

const SCENE = preload("res://scenes/playfield.tscn")

@export var level_file_name: String:
	set(value):
		level_file_name = value
		level = load(Level.DIR_PATH.path_join(level_file_name))
@export_tool_button("Start Level") var start_level_action = start_level

@export var hand: Hand
@export var stack: Stack
@export var slot_container: Container
@export var goal_latexture_rect: TextureRect
@export var background: Background

var level: Level


static func from_level_file_name(level_file_name: String) -> Playfield:
	var new_playfield: Playfield = SCENE.instantiate()
	new_playfield.level_file_name = level_file_name
	return new_playfield


func _ready() -> void:
	start_level()


func clear() -> void:
	for card in hand.get_children():
		card.queue_free()
	for card in stack.get_children():
		card.queue_free()
	for slot in slot_container.get_children():
		slot.queue_free()


func start_level(file_name := "") -> void:
	if not file_name.is_empty():
		level_file_name = file_name

	if level == null:
		return

	clear()

	goal_latexture_rect.LatexExpression = level.win_condition.latex
	goal_latexture_rect.Render()
	stack.add_child(Card.from_expression(level.start_value))
	for expression in level.slot_expressions:
		slot_container.add_child(Slot.from_expression(expression))
	for expression in level.hand_expressions:
		hand.add_child(Card.from_expression(expression))
