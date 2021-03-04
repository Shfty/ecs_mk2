class_name AreaCollision
extends Trait
tool

static func name() -> String:
	return "AreaCollision"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is Area2D:
			if child.get_shape_owners().size() > 0:
				return true
	return false

static func get_area(node: Node) -> Area2D:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is Area2D:
			return child
	return null
