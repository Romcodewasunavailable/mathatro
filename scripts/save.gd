@tool
extends Node

const FILE_PATH = "user://save_data.tres"

var data: SaveData


func save_data() -> void:
	ResourceSaver.save(data, FILE_PATH)


func load_data() -> void:
	data = ResourceLoader.load(FILE_PATH) if ResourceLoader.exists(FILE_PATH) else SaveData.new()


func _ready() -> void:
	load_data()
