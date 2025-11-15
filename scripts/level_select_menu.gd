@tool
class_name LevelSelectMenu
extends Control

signal play_button_pressed(file_name: String)
signal disappeared_main_menu()

@export var level_square_container: Container
@export var animation_player: AnimationPlayer

@export_tool_button("Update Level Squares") var update_level_squares_action = update_level_squares


func _ready() -> void:
	update_level_squares()


func update_level_squares() -> void:
	for child in level_square_container.get_children():
		child.queue_free()

	var number = 1
	for file_name in Level.file_names:
		var level_square = LevelSquare.from_level_data(
			file_name,
			number,
			Save.data.level_statuses[file_name],
		)
		level_square.play_button_pressed.connect(_on_play_button_pressed)
		level_square_container.add_child(level_square)
		number += 1


func _on_play_button_pressed(file_name: String) -> void:
	play_button_pressed.emit(file_name)
	animation_player.play(&"fade_out")


func _on_main_menu_button_pressed() -> void:
	animation_player.animation_finished.connect(func(_anim_name: StringName): disappeared_main_menu.emit())
	animation_player.play(&"fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_out":
		queue_free()
