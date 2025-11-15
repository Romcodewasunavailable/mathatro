@tool
class_name Stack
extends MultiCardControl


func _process(delta: float) -> void:
	for card in cards:
		card.position = card.position.lerp(
			Vector2.ZERO,
			Card.POSITION_LERP_SPEED * delta
		)
		card.rotation = lerp_angle(
			card.rotation,
			Card.DRAG_ROTATION_STRENGTH * card.velocity.x,
			Card.DRAG_ROTATION_LERP_SPEED * delta,
		)


func _on_cards_changed() -> void:
	if cards.size() <= 1:
		return

	cards[-1].compose(cards[-2])
