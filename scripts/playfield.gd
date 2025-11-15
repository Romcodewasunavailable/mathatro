@tool
class_name Playfield
extends Control

signal pause_button_pressed()

const CARD_APPLY_INTERVAL = 1.0
const SCENE = preload("res://scenes/playfield.tscn")

@export var level_file_name: String:
	set(value):
		level_file_name = value
		level = ResourceLoader.load(
			Level.DIR_PATH.path_join(level_file_name),
			"Level",
			ResourceLoader.CACHE_MODE_IGNORE,
		)
@export_tool_button("Start Level") var start_level_action = start_level

@export var hand: Hand
@export var stack: Stack
@export var slot_container: HBoxContainer
@export var goal_latexture_rect: TextureRect
@export var title_label: Label
@export var start_button: Button
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

	title_label.text = "Level %d - Goal:" % (Level.file_names.find(level_file_name) + 1)
	goal_latexture_rect.LatexExpression = level.win_condition.latex
	goal_latexture_rect.Render()
	stack.add_child(Card.from_expression(level.start_value))
	for expression in level.slot_expressions:
		slot_container.add_child(Slot.from_expression(expression))
	for expression in level.hand_expressions:
		hand.add_child(Card.from_expression(expression))

	get_tree().paused = false


func check_slots() -> bool:
	var slots_full = true
	for slot: Slot in slot_container.get_children():
		if slot.card == null:
			slot.pulse_bad()
			slots_full = false

	return slots_full


func check_win_condition() -> void:
	if level.win_condition.evaluate(stack.cards[-1].evaluate()):
		background.pulse_good()
	else:
		background.pulse_bad()


func _on_start_button_pressed() -> void:
	if not check_slots():
		return

	start_button.disabled = true
	for i in range(slot_container.get_child_count()):
		create_tween().tween_callback(slot_container.get_child(i).card.reparent.bind(stack)).set_delay(i * CARD_APPLY_INTERVAL)
		create_tween().tween_callback(background.pulse).set_delay(i * CARD_APPLY_INTERVAL)

	create_tween().tween_callback(check_win_condition).set_delay(slot_container.get_child_count() * CARD_APPLY_INTERVAL)


func _on_pause_button_pressed():
	pause_button_pressed.emit()
	get_tree().paused = true
