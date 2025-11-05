@tool
class_name Level
extends Resource

enum Status {
	LOCKED,
	AVAILABLE,
	COMPLETED,
}

@export var start_value: LatexExpression:
	set(value):
		if start_value != null:
			start_value.changed.disconnect(emit_changed)
		start_value = value
		if start_value != null:
			start_value.changed.connect(emit_changed)
@export var win_condition: LatexExpression:
	set(value):
		if win_condition != null:
			win_condition.changed.disconnect(emit_changed)
		win_condition = value
		if win_condition != null:
			win_condition.changed.connect(emit_changed)
@export var slot_expressions: Array[LatexExpression]:
	set(value):
		for expression in slot_expressions:
			if expression != null:
				expression.changed.disconnect(emit_changed)
		slot_expressions = value
		for expression in slot_expressions:
			if expression != null:
				expression.changed.connect(emit_changed)
		emit_changed()
@export var hand_expressions: Array[LatexExpression]:
	set(value):
		for expression in hand_expressions:
			if expression != null:
				expression.changed.disconnect(emit_changed)
		hand_expressions = value
		for expression in hand_expressions:
			if expression != null:
				expression.changed.connect(emit_changed)
		emit_changed()
@export var unlocks: PackedStringArray:
	set(value):
		unlocks = value
		emit_changed()
