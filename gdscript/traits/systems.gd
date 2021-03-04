class_name Systems
extends Trait
tool

static func name() -> String:
	return "Systems"

static func is_implementor(node: Node) -> bool:
	if not node.has_method("get_systems"):
		return false

	if not node.get_systems() is Array:
		return false

	return true

static func get_systems(node: Node) -> Array:
	assert(is_implementor(node))
	return node.get_systems()
