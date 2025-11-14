@tool
class_name PauseMenu
extends Control

signal resume_button_pressed()
signal level_select_button_pressed()
signal main_menu_button_pressed()

@export var animation_player: AnimationPlayer


func _on_resume_button_pressed():
	resume_button_pressed.emit()
	animation_player.play(&"fade_out")


func _on_level_select_button_pressed():
	animation_player.animation_finished.connect(func(_anim_name: StringName): level_select_button_pressed.emit())
	animation_player.play(&"fade_out")


func _on_main_menu_button_pressed():
	animation_player.animation_finished.connect(func(_anim_name: StringName): main_menu_button_pressed.emit())
	animation_player.play(&"fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_out":
		queue_free()
