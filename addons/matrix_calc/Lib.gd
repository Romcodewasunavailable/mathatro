extends Node

const MATRIX_ADD = preload("res://addons/matrix_calc/Shader/matrix_add.glsl")
const MATRIX_SUB = preload("res://addons/matrix_calc/Shader/matrix_sub.glsl")
const MATRIX_MUL = preload("res://addons/matrix_calc/Shader/matrix_mul.glsl")

var use_render : bool = ProjectSettings.get_setting("rendering/renderer/rendering_method") != "gl_compatibility":
	set(b):
		return

func binding_uniform(rdevice : RenderingDevice, ingroup : Array, 
					spirv : RDShaderSPIRV, groupsize : Vector3i) -> Array:
	var shader : RID = rdevice.shader_create_from_spirv(spirv)
	var uniforms : Array[RDUniform] = []
	var buffers : Array[RID] = []
	for i in ingroup.size():
		var data = ingroup[i]
		var byte = data.to_byte_array()
		var buffer = rdevice.storage_buffer_create(byte.size(), byte)
		buffers.append(buffer)
		var tempuniform := RDUniform.new()
		tempuniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
		tempuniform.binding = i
		tempuniform.add_id(buffer)
		uniforms.append(tempuniform)
	
	var uniform_set : RID = rdevice.uniform_set_create(uniforms, shader, 0)
	var pipeline : RID = rdevice.compute_pipeline_create(shader)
	var compute_list := rdevice.compute_list_begin()
	rdevice.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rdevice.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rdevice.compute_list_dispatch(compute_list, groupsize.x, groupsize.y, groupsize.z)
	rdevice.compute_list_end()
	
	rdevice.free_rid(shader)
	return buffers

func freebuffer(rdevice : RenderingDevice, buffers : Array[RID]):
	for buffer in buffers:
		rdevice.free_rid(buffer)
	rdevice.free()
	#print("Buffer free completed.")
