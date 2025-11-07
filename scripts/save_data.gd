@tool
class_name SaveData
extends Resource

@export var level_statuses: Dictionary[String, Level.Status]


func update_level_statuses() -> void:
	for file_name in level_statuses.keys():
		if file_name not in Level.file_names:
			level_statuses.erase(file_name)

	var highest_completed = -1
	for i in range(Level.file_names.size() - 1, -1, -1):
		var file_name = Level.file_names[i]
		if level_statuses.get(file_name) == Level.Status.COMPLETED:
			highest_completed = i
			break

	for i in range(Level.file_names.size()):
		var file_name = Level.file_names[i]
		if i <= highest_completed:
			if level_statuses.get(file_name, Level.Status.LOCKED) == Level.Status.LOCKED:
				level_statuses[file_name] = Level.Status.AVAILABLE
		elif i == highest_completed + 1:
			level_statuses[file_name] = Level.Status.AVAILABLE
		else:
			level_statuses[file_name] = Level.Status.LOCKED
