@tool
class_name MainMenu
extends Control

signal play_button_pressed()
signal disappeared_level_select()

@export var play_button: Button
@export var animation_player: AnimationPlayer


func _ready() -> void:
	if Save.data.get_highest_available() != Level.file_names[0]:
		play_button.text = "Continue"


func _on_play_button_pressed() -> void:
	play_button_pressed.emit()
	animation_player.play(&"fade_out")


func _on_level_select_button_pressed() -> void:
	animation_player.animation_finished.connect(func(_anim_name: StringName): disappeared_level_select.emit())
	animation_player.play(&"fade_out")


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_out":
		queue_free()
