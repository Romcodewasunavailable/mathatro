@tool
class_name Game
extends Node

const MAIN_MENU_SCENE = preload("res://scenes/main_menu.tscn")
const LEVEL_SELECT_SCENE = preload("res://scenes/level_select.tscn")
const PAUSE_MENU_SCENE = preload("res://scenes/pause_menu.tscn")

@export var playfield_canvas_layer: CanvasLayer
@export var menu_canvas_layer: CanvasLayer
@export var spiral: Spiral

var playfield: Playfield


func _ready() -> void:
	Engine.time_scale = 0.1
	var tween = create_tween()
	tween.tween_property(Engine, ^"time_scale", 1.0, 2.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(load_main_menu)
	spiral.state = Spiral.State.CLOSED


func load_main_menu() -> void:
	var main_menu: MainMenu = MAIN_MENU_SCENE.instantiate()
	main_menu.play_button_pressed.connect(start_level)
	main_menu.play_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.OPEN))
	main_menu.disappeared_level_select.connect(load_level_select)
	menu_canvas_layer.add_child(main_menu)


func load_level_select() -> void:
	var level_select: LevelSelect = LEVEL_SELECT_SCENE.instantiate()
	level_select.play_button_pressed.connect(start_level)
	level_select.play_button_pressed.connect(func(_file_name: String): spiral.state = Spiral.State.OPEN)
	menu_canvas_layer.add_child(level_select)


func load_pause_menu() -> void:
	var pause_menu: PauseMenu = PAUSE_MENU_SCENE.instantiate()
	pause_menu.resume_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.OPEN))
	pause_menu.level_select_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.CLOSED))
	pause_menu.disappeared_level_select.connect(load_level_select)
	pause_menu.main_menu_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.CLOSED))
	pause_menu.disappeared_main_menu.connect(load_main_menu)
	menu_canvas_layer.add_child(pause_menu)


func start_level(file_name := "") -> void:
	if playfield != null:
		playfield.queue_free()

	if file_name.is_empty():
		for i in range(Level.file_names.size() - 1, -1, -1):
			if Save.data.level_statuses[Level.file_names[i]] == Level.Status.AVAILABLE:
				file_name = Level.file_names[i]
				break
		if file_name.is_empty():
			file_name = Level.file_names[0]

	playfield = Playfield.from_level_file_name(file_name)
	playfield.pause_button_pressed.connect(load_pause_menu)
	playfield.pause_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.HALF_OPEN))
	playfield_canvas_layer.add_child(playfield)


func _on_spiral_state_change_finished():
	if spiral.state == Spiral.State.CLOSED and playfield != null:
		playfield.queue_free()
