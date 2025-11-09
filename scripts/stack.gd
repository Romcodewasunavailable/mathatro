@tool
class_name Stack
extends MultiCardControl

@export var lerp_speed := 10.0
@export var rotation_lerp_speed := 10.0


func _process(delta: float) -> void:
	for card in cards:
		card.position = card.position.lerp(Vector2.ZERO, lerp_speed * delta)
		card.rotation = lerp_angle(card.rotation, 0.0, rotation_lerp_speed * delta)
