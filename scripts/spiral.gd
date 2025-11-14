@tool
class_name Spiral
extends MultiCardControl

signal state_change_finished()

enum State {
	CLOSED,
	HALF_OPEN,
	OPEN,
}

@export var state := State.OPEN:
	set(value):
		var previous_state = state
		state = value
		if state != previous_state:
			tween_radius_offset(int(state) * 8.0)
			tween_opacity(1.0 - int(state) * 0.5)
			create_tween().tween_callback(state_change_finished.emit).set_delay(tween_duration)

@export var num_cards := 160:
	set(value):
		num_cards = value
		generate_cards()
@export var radius_offset := 0.0
@export var radius_coef := 100.0
@export var angle_coef := 180.0
@export_exp_easing("attenuation") var radius_exp := 0.5
@export_exp_easing("attenuation") var angle_exp := 1.0
@export_exp_easing() var brightness_exp := 0.75
@export var tween_duration := 2.0


func _ready() -> void:
	super._ready()
	radius_offset = 16.0
	modulate.a = 0.0
	generate_cards()


func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var angle = time * 0.05
	for i in range(num_cards):
		var card = cards[i]
		var radius = radius_coef * (i + 1 + radius_offset ** (1.0 / radius_exp)) ** (radius_exp + sin(time * 0.2) * 0.005)
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


func tween_radius_offset(to: float):
	create_tween().tween_property(
		self,
		^"radius_offset",
		to,
		tween_duration,
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func tween_opacity(to: float):
	var to_color = modulate
	to_color.a = to
	create_tween().tween_property(
		self,
		^"modulate",
		to_color,
		tween_duration,
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
