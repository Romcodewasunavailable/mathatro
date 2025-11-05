@tool
class_name MainMenu
extends Control

const PLAYFIELD_SCENE = preload("res://scenes/playfield.tscn")


func _on_play_button_pressed() -> void:
	var playfield: Playfield = PLAYFIELD_SCENE.instantiate()
	playfield.level = load(SaveData.level_paths[0])
	get_tree().root.add_child(playfield)
	get_tree().current_scene = playfield
	queue_free()


func _on_level_select_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
