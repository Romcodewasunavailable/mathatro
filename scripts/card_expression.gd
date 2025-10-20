@tool
class_name CardExpression
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


func compose(other: CardExpression) -> void:
	raw = raw.replace("x", "(%s)" % other.raw)
	latex = latex.replace("x", "(%s)" % other.latex)


func evaluate(x: float = 0.0) -> float:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return 0.0
	return result
