@tool
class_name BackgroundShaderRect
extends ShaderRect


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		set_instance_shader_parameter(&"mouse_position", get_local_mouse_position())
