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
	raw = raw.replace("x", other.raw)
	latex = latex.replace("x", other.latex)


func evaluate(x: Variant = 0.0) -> Variant:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return 0.0
	return result
