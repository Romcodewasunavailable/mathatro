@tool
class_name SaveData
extends Resource

@export var level_statuses: Dictionary[String, Level.Status]


func _init() -> void:
	for level_path in DirAccess.get_files_at("res://levels"):
		level_statuses[level_path] = Level.Status.AVAILABLE if level_statuses.is_empty() else Level.Status.LOCKED
