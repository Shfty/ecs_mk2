class_name Interpolator
extends Trait
tool

static func name() -> String:
	return "Interpolator"

static func is_implementor(node: Node) -> bool:
	if not Position2.is_implementor(node):
		return false

	for child in node.get_children():
		if child is InterpolatorComponent:
			return true
	return false

static func debug_string(node: Node) -> String:
	return "last: %s" % [get_last_position(node)]

static func get_last_position(node: Node) -> Vector2:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is InterpolatorComponent:
			return child.last_position
	return Vector2.ZERO

static func set_last_position(node: Node, new_last_position: Vector2) -> void:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is InterpolatorComponent:
			child.last_position = new_last_position
			return
