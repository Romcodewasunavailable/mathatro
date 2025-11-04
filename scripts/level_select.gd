@tool
class_name LevelSelect
extends Control

@export var level_button_container: Container


func _ready() -> void:
	var level_number = 1
	for level_path in DirAccess.get_files_at("res://levels"):
		level_button_container.add_child(LevelButton.new(level_number, level_path))
		level_number += 1
