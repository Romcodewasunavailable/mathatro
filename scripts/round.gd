@tool
class_name Round
extends Resource

@export var target_set: SetExpression:
	set(value):
		if target_set != null:
			target_set.changed.disconnect(emit_changed)
		target_set = value
		if target_set != null:
			target_set.changed.connect(emit_changed)
@export var cards: Array[CardExpression]:
	set(value):
		cards = value
		emit_changed()
