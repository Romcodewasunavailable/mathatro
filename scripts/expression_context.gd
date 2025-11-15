@tool
extends Node


func matrix(size: Vector2i, data := PackedFloat32Array()):
	var new_matrix = Float32Matrix.new(size)
	if not data.is_empty():
		new_matrix.data = data
	return new_matrix
