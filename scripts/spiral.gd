@tool
class_name Spiral
extends Control

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
			tween_opacity(1.0 - (int(state) * 0.5) ** 2.0)
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

@export var canvas_group: CanvasGroup
@export var multi_card_control: MultiCardControl


func _ready() -> void:
	radius_offset = 16.0
	canvas_group.self_modulate.a = 0.0
	generate_cards()


func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec() / 1000.0
	var angle = time * 0.05
	for i in range(num_cards):
		var card = multi_card_control.cards[i]
		var radius = radius_coef * (i + 1 + radius_offset ** (1.0 / radius_exp)) ** (radius_exp + sin(time * 0.2) * 0.005)
		angle += angle_coef * radius ** (-angle_exp)
		card.position = (multi_card_control.size - card.size) / 2.0 + radius * Vector2(
			cos(angle),
			sin(angle),
		)
		card.rotation = angle - PI / 2.0
		card.modulate.v = (float(i) / num_cards) ** brightness_exp


func generate_cards() -> void:
	for child in multi_card_control.get_children():
		if child is Card:
			child.queue_free()

	for i in range(num_cards):
		multi_card_control.add_child(Card.from_expression(LatexExpression.new("", LatexSamples.random())))


func tween_radius_offset(to: float):
	create_tween().tween_property(
		self,
		^"radius_offset",
		to,
		tween_duration,
	).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func tween_opacity(to: float):
	var to_color = canvas_group.self_modulate
	to_color.a = to
	create_tween().tween_property(
		canvas_group,
		^"self_modulate",
		to_color,
		tween_duration / 4.0,
	).set_trans(Tween.TRANS_SINE)


func _on_resized() -> void:
	multi_card_control.size = size
