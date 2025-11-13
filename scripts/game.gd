@tool
class_name Game
extends Node

const LEVEL_SELECT_SCENE = preload("res://scenes/level_select.tscn")

@export var playfield_canvas_layer: CanvasLayer
@export var menu_canvas_layer: CanvasLayer
@export var spiral: Spiral


func _on_main_menu_play_button_pressed() -> void:
	var playfield: Playfield

	for i in range(Level.file_names.size() - 1, -1, -1):
		var file_name = Level.file_names[i]
		if Save.data.level_statuses[file_name] == Level.Status.AVAILABLE:
			playfield = Playfield.from_level_file_name(file_name)
			break

	if playfield == null:
		playfield = Playfield.from_level_file_name(Level.file_names[0])

	playfield_canvas_layer.add_child(playfield)
	spiral.open()


func _on_main_menu_level_select_button_pressed() -> void:
	var level_select: LevelSelect = LEVEL_SELECT_SCENE.instantiate()
	level_select.play_button_pressed.connect(_on_level_select_play_button_pressed)
	menu_canvas_layer.add_child(level_select)


func _on_level_select_play_button_pressed(file_name: String) -> void:
	playfield_canvas_layer.add_child(Playfield.from_level_file_name(file_name))
	spiral.open()
