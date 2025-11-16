@tool
class_name LevelCompleteMenu
extends Control

signal next_level_button_pressed()
signal level_select_button_pressed()
signal main_menu_button_pressed()
signal disappeared_level_select()
signal disappeared_main_menu()

@export var next_level_button: Button
@export var animation_player: AnimationPlayer


func _on_next_level_button_pressed() -> void:
	next_level_button_pressed.emit()
	animation_player.play(&"fade_out")


func _on_level_select_button_pressed() -> void:
	level_select_button_pressed.emit()
	animation_player.animation_finished.connect(func(_anim_name: StringName): disappeared_level_select.emit())
	animation_player.play(&"fade_out")


func _on_main_menu_button_pressed() -> void:
	main_menu_button_pressed.emit()
	animation_player.animation_finished.connect(func(_anim_name: StringName): disappeared_main_menu.emit())
	animation_player.play(&"fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_out":
		queue_free()
