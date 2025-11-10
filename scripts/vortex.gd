@tool
class_name Vortex
extends MultiCardControl

@export var num_rings := 2:
	set(value):
		num_rings = value
		generate_cards()
@export var ring_start_radius := 768.0:
	set(value):
		ring_start_radius = value
		generate_cards()
@export var ring_radius_step := 256.0:
	set(value):
		ring_radius_step = value
		generate_cards()
@export var ring_segment_multiplier := 0.05:
	set(value):
		ring_segment_multiplier = value
		generate_cards()


func _ready() -> void:
	super._ready()
	generate_cards()


func _process(_delta: float) -> void:
	var card_index = 0
	for i in range(num_rings):
		var radius = ring_start_radius + i * ring_radius_step
		var num_ring_segments = roundi(radius * ring_segment_multiplier)
		for j in range(num_ring_segments):
			var card = cards[card_index]
			var angle = 2.0 * PI * j / num_ring_segments + Time.get_ticks_msec() / 10000.0 * (1.0 + i * 0.5)
			card.position = (size - card.size) / 2.0 + radius * Vector2(
				cos(angle),
				sin(angle),
			)
			card.rotation = angle - PI / 2.0
			card_index += 1


func generate_cards() -> void:
	for child in get_children():
		if child is Card:
			child.queue_free()

	for i in range(num_rings):
		var radius = ring_start_radius + i * ring_radius_step
		var num_ring_segments = roundi(radius * ring_segment_multiplier)
		for j in range(num_ring_segments):
			add_child(Card.from_expression(LatexExpression.new("", "Mathatro")))
