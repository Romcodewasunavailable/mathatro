@tool
class_name Background
extends ShaderRect

@export_color_no_alpha var base_color := Color.WHITE
@export_color_no_alpha var pulse_color := Color.WHITE
@export_color_no_alpha var good_pulse_color := Color.WHITE
@export_color_no_alpha var bad_pulse_color := Color.WHITE
@export var pulse_duration := 1.0
@export_tool_button("Pulse") var pulse_action = pulse
@export_tool_button("Pulse Good") var pulse_good_action = pulse_good
@export_tool_button("Pulse Bad") var pulse_bad_action = pulse_bad

@export var click_warp_strength := -0.25
@export var click_warp_duration := 1.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"click"):
		tween_warp(click_warp_strength)
	elif event.is_action_released(&"click"):
		tween_warp(0.0)
	elif event.is_action_pressed(&"alt_click"):
		tween_warp(-click_warp_strength)
	elif event.is_action_released(&"alt_click"):
		tween_warp(0.0)
	elif event is InputEventMouseMotion:
		set_instance_shader_parameter(&"mouse_position", get_local_mouse_position())


func tween_color(color: Color) -> void:
	create_tween().tween_method(
		func(value): material.set_shader_parameter(&"accent_color", value),
		material.get_shader_parameter(&"accent_color"),
		color,
		pulse_duration
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func tween_warp(strength: float) -> void:
	create_tween().tween_method(
		func(value): material.set_shader_parameter(&"mouse_warp_strength", value),
		material.get_shader_parameter(&"mouse_warp_strength"),
		strength,
		click_warp_duration
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func pulse() -> void:
	material.set_shader_parameter(&"accent_color", pulse_color)
	tween_color(base_color)


func pulse_good() -> void:
	material.set_shader_parameter(&"accent_color", good_pulse_color)
	tween_color(base_color)


func pulse_bad() -> void:
	material.set_shader_parameter(&"accent_color", bad_pulse_color)
	tween_color(base_color)
