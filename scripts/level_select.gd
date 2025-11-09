@tool
class_name LevelSelect
extends Control

@export var level_square_container: Container

@export_tool_button("Update Level Squares") var update_level_squares_action = update_level_squares


func _ready() -> void:
	update_level_squares()


func update_level_squares() -> void:
	for child in level_square_container.get_children():
		child.queue_free()

	var number = 1
	for file_name in DirAccess.get_files_at("res://levels"):
		level_square_container.add_child(LevelSquare.from_level_data(
			file_name,
			number,
			Save.data.level_statuses[file_name],
		))
		number += 1
