class_name Interpolant
extends Trait
tool

static func name() -> String:
	return "Interpolant"

static func is_implementor(node: Node) -> bool:
	if not Position2.is_implementor(node):
		return false

	for child in node.get_children():
		if child is InterpolantComponent:
			return true
	return false
