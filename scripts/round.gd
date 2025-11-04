@tool
class_name Round
extends Resource

@export var goal: GoalExpression:
	set(value):
		if goal != null:
			goal.changed.disconnect(emit_changed)
		goal = value
		if goal != null:
			goal.changed.connect(emit_changed)
@export var cards: Array[CardExpression]:
	set(value):
		cards = value
		emit_changed()
