@tool
class_name ShaderRect
extends ColorRect


func _ready() -> void:
	resized.connect(update_shader_size)
	update_shader_size()


func update_shader_size() -> void:
	set_instance_shader_parameter(&"size", size)
