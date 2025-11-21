@tool
extends Node

const FILE_PATH = "user://save_data.tres"

var data: SaveData


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	load_data()


func _notification(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if not Engine.is_editor_hint():
			save_data()
		get_tree().quit()


func save_data() -> void:
	ResourceSaver.save(data, FILE_PATH)


func load_data() -> void:
	data = load(FILE_PATH) if ResourceLoader.exists(FILE_PATH) else SaveData.new()
	data.update_level_statuses()
