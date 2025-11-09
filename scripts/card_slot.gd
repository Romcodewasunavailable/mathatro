@tool
class_name CardSlot
extends Control

const SCENE = preload("res://scenes/card_slot.tscn")

@export var card: Card
@export var locked := false:
	set(value):
		locked = value
		if is_node_ready():
			update_lock_icon()

@export var lock_icon: Control


static func from_expression(expression: LatexExpression = null) -> CardSlot:
	var new_card_slot: CardSlot = SCENE.instantiate()
	if expression != null:
		var new_card = Card.from_expression(expression)
		new_card_slot.add_child(new_card)
		new_card_slot.card = new_card
		new_card_slot.locked = true
	return new_card_slot


func _ready() -> void:
	update_lock_icon()


func update_lock_icon() -> void:
	lock_icon.visible = locked
