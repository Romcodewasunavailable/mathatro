@tool
class_name Background
extends ShaderRect

@export_color_no_alpha var base_color: Color
@export_color_no_alpha var pulse_color: Color
@export_color_no_alpha var good_pulse_color: Color
@export_color_no_alpha var bad_pulse_color: Color
@export var pulse_duration := 0.5

@export_tool_button("Pulse") var pulse_action = pulse

var tween: Tween
var accent_color := Color(0.25, 0.25, 0.25):
	set(value):
		accent_color = value
		material.set_shader_parameter(&"accent_color", accent_color)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		set_instance_shader_parameter(&"mouse_position", get_local_mouse_position())


func tween_back_color() -> void:
	if tween != null:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "accent_color", base_color, pulse_duration)


func pulse() -> void:
	accent_color = pulse_color
	tween_back_color()


func pulse_good() -> void:
	accent_color = good_pulse_color
	tween_back_color()


func pulse_bad() -> void:
	accent_color = bad_pulse_color
	tween_back_color()
