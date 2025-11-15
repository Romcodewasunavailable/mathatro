@tool
class_name LatexExpression
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


func _init(raw := "", latex := "") -> void:
	if raw != "":
		self.raw = raw
	if latex != "":
		self.latex = latex


func compose(other: LatexExpression) -> void:
	raw = raw.replace("x", "(%s)" % other.raw)
	latex = latex.replace("x", "(%s)" % other.latex)

	if not latex.contains("x"):
		var result = evaluate()
		if result is float:
			if is_equal_approx(result, roundi(result)):
				result = roundi(result)
			else:
				result = snappedf(result, 0.00001)
		latex = str(result)


func evaluate(x: Variant = 0.0) -> Variant:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return 0.0
	return result
