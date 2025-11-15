@tool
class_name Game
extends Node

const MAIN_MENU_SCENE = preload("res://scenes/main_menu.tscn")
const LEVEL_SELECT_MENU_SCENE = preload("res://scenes/level_select_menu.tscn")
const PAUSE_MENU_SCENE = preload("res://scenes/pause_menu.tscn")
const LEVEL_COMPLETE_MENU_SCENE = preload("res://scenes/level_complete_menu.tscn")

@export var playfield_canvas_layer: CanvasLayer
@export var menu_canvas_layer: CanvasLayer
@export var spiral: Spiral

var playfield: Playfield


func _ready() -> void:
	Engine.time_scale = 0.2
	create_tween().tween_property(Engine, ^"time_scale", 1.0, 2.0).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_callback(load_main_menu).set_delay(1.0)
	spiral.state = Spiral.State.CLOSED


func load_main_menu() -> void:
	var main_menu: MainMenu = MAIN_MENU_SCENE.instantiate()
	main_menu.play_button_pressed.connect(func():
		start_level()
		spiral.state = Spiral.State.OPEN
	)
	main_menu.disappeared_level_select.connect(load_level_select_menu)
	main_menu.quit_button_pressed.connect(func():
		create_tween().tween_callback(
			get_tree().root.propagate_notification.bind(NOTIFICATION_WM_CLOSE_REQUEST)
		).set_delay(0.5)
		spiral.state = Spiral.State.OPEN
	)
	menu_canvas_layer.add_child(main_menu)


func load_level_select_menu() -> void:
	var level_select_menu: LevelSelectMenu = LEVEL_SELECT_MENU_SCENE.instantiate()
	level_select_menu.play_button_pressed.connect(func(file_name: String):
		start_level(file_name)
		spiral.state = Spiral.State.OPEN
	)
	level_select_menu.disappeared_main_menu.connect(load_main_menu)
	menu_canvas_layer.add_child(level_select_menu)


func load_pause_menu() -> void:
	var pause_menu: PauseMenu = PAUSE_MENU_SCENE.instantiate()
	pause_menu.resume_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.OPEN))
	pause_menu.level_select_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.CLOSED))
	pause_menu.disappeared_level_select.connect(load_level_select_menu)
	pause_menu.main_menu_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.CLOSED))
	pause_menu.disappeared_main_menu.connect(load_main_menu)
	menu_canvas_layer.add_child(pause_menu)


func load_level_complete_menu() -> void:
	var level_complete_menu: LevelCompleteMenu = LEVEL_COMPLETE_MENU_SCENE.instantiate()
	var next_level_index = Level.file_names.find(playfield.level_file_name) + 1
	if next_level_index >= Level.file_names.size():
		level_complete_menu.next_level_button.disabled = true
	else:
		level_complete_menu.next_level_button_pressed.connect(func():
			spiral.state = Spiral.State.CLOSED
			create_tween().tween_callback(func():
				start_level(Level.file_names[next_level_index])
				spiral.state = Spiral.State.OPEN
			).set_delay(1.0)
		)
	level_complete_menu.level_select_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.CLOSED))
	level_complete_menu.disappeared_level_select.connect(load_level_select_menu)
	level_complete_menu.main_menu_button_pressed.connect(spiral.set.bind(&"state", Spiral.State.CLOSED))
	level_complete_menu.disappeared_main_menu.connect(load_main_menu)
	menu_canvas_layer.add_child(level_complete_menu)


func start_level(file_name := "") -> void:
	if playfield != null:
		playfield.queue_free()

	playfield = Playfield.from_level_file_name(Save.data.get_highest_available() if file_name.is_empty() else file_name)
	playfield.pause_button_pressed.connect(func():
		load_pause_menu()
		spiral.state = Spiral.State.HALF_OPEN
	)
	playfield.level_completed.connect(func():
		load_level_complete_menu()
		spiral.state = Spiral.State.HALF_OPEN
	)
	playfield_canvas_layer.add_child(playfield)


func _on_spiral_state_change_finished():
	if spiral.state == Spiral.State.CLOSED and playfield != null:
		playfield.queue_free()
