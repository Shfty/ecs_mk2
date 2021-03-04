class_name Position2
extends Trait
tool

static func name() -> String:
	return "Position2"

static func is_implementor(node: Node) -> bool:
	if not node.has_method("get_position"):
		return false

	if not node.has_method("set_position"):
		return false

	if not node.get_position() is Vector2:
		return false

	return true

static func debug_string(node: Node) -> String:
	return String(get_position(node))

static func get_position(node: Node) -> Vector2:
	assert(is_implementor(node))

	return node.get_position()

static func set_position(node: Node, new_position: Vector2) -> void:
	assert(is_implementor(node))
	node.set_position(new_position)
