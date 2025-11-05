@tool
class_name SaveData
extends Resource

static var level_paths: PackedStringArray

@export var level_statuses: Dictionary[String, Level.Status]


static func _static_init() -> void:
	level_paths = DirAccess.get_files_at("res://levels")


func _init() -> void:
	for level_path in level_paths:
		level_statuses[level_path] = Level.Status.AVAILABLE if level_statuses.is_empty() else Level.Status.LOCKED
