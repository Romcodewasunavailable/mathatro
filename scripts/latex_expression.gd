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


static func format(value: Variant) -> String:
	match typeof(value):
		TYPE_FLOAT:
			if is_nan(value):
				return "\\text{undefined}"
			elif is_inf(value):
				return "\\infty" if value > 0.0 else "-\\infty"
			if is_equal_approx(value, roundi(value)):
				return str(roundi(value))
			else:
				return str(snappedf(value, 0.00001))

		TYPE_VECTOR3:
			return "\\begin{pmatrix}\n%s \\\\\n%s \\\\\n%s\n\\end{pmatrix}" % [
				format(value.x),
				format(value.y),
				format(value.z),
			]

		TYPE_OBJECT:
			if value is Float32Matrix:
				var rows = PackedStringArray()
				for y in range(value.y):
					var cells = PackedStringArray()
					for x in range(value.x):
						cells.append(format(value.get_value(Vector2i(x, y))))
					rows.append(" & ".join(cells))
				return "\\begin{pmatrix}\n%s\n\\end{pmatrix}" % " \\\\\n".join(rows)

		TYPE_STRING:
			return value

	return str(value)


func _init(raw := "", latex := "") -> void:
	if raw != "":
		self.raw = raw
	if latex != "":
		self.latex = latex


func compose(other: LatexExpression) -> void:
	raw = raw.replace("(x)", "(%s)" % other.raw)
	latex = latex.replace("{x}", "{%s}" % other.latex)

	if not latex.contains("{x}"):
		latex = format(evaluate())


func evaluate(x: Variant = 0.0) -> Variant:
	var result = expression.execute([x], ExpressionContext)
	if expression.has_execute_failed() or result is float and is_inf(result) and x == 0.0:
		return NAN
	return result
