@tool
class_name MainMenu
extends Control

@export var play_button: Button


func _ready() -> void:
	if Save.data.level_statuses[Level.file_names[0]] == Level.Status.COMPLETED:
		play_button.text = "Continue"


func _on_play_button_pressed() -> void:
	var playfield: Playfield

	for i in range(Level.file_names.size() - 1, -1, -1):
		var file_name = Level.file_names[i]
		if Save.data.level_statuses[file_name] == Level.Status.AVAILABLE:
			playfield = Playfield.from_level_file_name(file_name)
			break

	if playfield == null:
		playfield = Playfield.from_level_file_name(Level.file_names[0])

	if playfield != null:
		get_tree().root.add_child(playfield)
		get_tree().current_scene = playfield
		queue_free()


func _on_level_select_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
