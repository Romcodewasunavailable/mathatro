@tool
class_name LevelSquare
extends Control

signal play_button_pressed(file_name: String)

const SCENE = preload("res://scenes/level_square.tscn")

@export var file_name := ""
@export var number := 1:
	set(value):
		number = value
		if is_node_ready():
			update_visuals()
@export var status := Level.Status.AVAILABLE:
	set(value):
		status = value
		if is_node_ready():
			update_visuals()

@export var play_button: Button
@export var lock_texture_rect: TextureRect
@export var check_texture_rect: TextureRect


static func from_level_data(file_name: String, number: int, status: Level.Status) -> LevelSquare:
	var new_level_square: LevelSquare = SCENE.instantiate()
	new_level_square.file_name = file_name
	new_level_square.number = number
	new_level_square.status = status
	return new_level_square


func _ready() -> void:
	update_visuals()


func update_visuals() -> void:
	play_button.disabled = status == Level.Status.LOCKED
	play_button.text = "" if status == Level.Status.LOCKED else str(number)
	lock_texture_rect.visible = status == Level.Status.LOCKED
	check_texture_rect.visible  = status == Level.Status.COMPLETED


func _on_play_button_pressed() -> void:
	play_button_pressed.emit(file_name)
