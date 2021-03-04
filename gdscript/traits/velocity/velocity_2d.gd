class_name Velocity2
extends Trait
tool

static func name() -> String:
	return "Velocity2"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is Velocity:
			return true
	return false

static func debug_string(node: Node) -> String:
	return String(get_velocity(node))

static func get_velocity(node: Node) -> Vector2:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is Velocity:
			return child.velocity
	return Vector2.ZERO

static func set_velocity(node: Node, new_velocity: Vector2) -> void:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is Velocity:
			child.velocity = new_velocity
			return
