@tool
class_name Stack
extends MultiCardControl


func _process(delta: float) -> void:
	for card in cards:
		card.position = card.position.lerp(Vector2.ZERO, Card.POSITION_LERP_SPEED * delta)
		card.rotation = lerp_angle(card.rotation, 0.0, Card.ROTATION_LERP_SPEED * delta)
