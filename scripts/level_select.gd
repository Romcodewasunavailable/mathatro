@tool
class_name LevelSelect
extends Control

const LEVEL_SQUARE_SCENE = preload("res://scenes/level_square.tscn")

@export var level_square_container: Container

@export_tool_button("Update Level Squares") var update_level_squares_action = update_level_squares


func _ready() -> void:
	update_level_squares()


func update_level_squares() -> void:
	for child in level_square_container.get_children():
		child.queue_free()

	var level_number = 1
	for level_path in DirAccess.get_files_at("res://levels"):
		var new_level_square: LevelSquare = LEVEL_SQUARE_SCENE.instantiate()
		new_level_square.level_path = level_path
		new_level_square.number = level_number
		new_level_square.status = Save.data.level_statuses[level_path]
		level_square_container.add_child(new_level_square)
		level_number += 1
