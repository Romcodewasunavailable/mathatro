@tool
class_name Spiral
extends MultiCardControl

@export var num_cards := 160:
	set(value):
		num_cards = value
		generate_cards()
@export var start_i := 1
@export var selection_offset := 50.0
@export var radius_coef := 100.0
@export var angle_coef := 160.0
@export_exp_easing("attenuation") var radius_exp := 0.5
@export_exp_easing("attenuation") var angle_exp := 1.0
@export_exp_easing() var brightness_exp := 0.75


func _ready() -> void:
	super._ready()
	generate_cards()


func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var angle = time * 0.05
	for i in range(num_cards):
		var card = cards[i]
		var radius = radius_coef * (i + start_i) ** (radius_exp + sin(time * 0.2) * 0.005)
		angle += angle_coef * radius ** (-angle_exp)
		card.position = (size - card.size) / 2.0 + (radius) * Vector2(
			cos(angle),
			sin(angle),
		)
		card.rotation = angle - PI / 2.0
		card.modulate.v = (float(i) / num_cards) ** brightness_exp


func generate_cards() -> void:
	for child in get_children():
		if child is Card:
			child.queue_free()

	for i in range(num_cards):
		add_child(Card.from_expression(LatexExpression.new("", LatexSamples.random())))
