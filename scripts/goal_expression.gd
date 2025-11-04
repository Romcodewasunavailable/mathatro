@tool
class_name GoalExpression
extends Resource

@export_multiline var raw: String:
	set(value):
		raw = value
		var error = expression.parse(raw, ["x"])
		if error != OK:
			push_error(expression.get_error_text())
		emit_changed()
@export_multiline var latex: String:
	set(value):
		latex = value
		emit_changed()

var expression := Expression.new()


func evaluate(x: float = 0.0) -> bool:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return false
	return result
