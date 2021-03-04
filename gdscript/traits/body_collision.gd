class_name BodyCollision
extends Trait
tool

static func name() -> String:
	return "BodyCollision"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is PhysicsBody2D:
			if child.get_shape_owners().size() > 0:
				return true
	return false

static func get_body(node: Node) -> PhysicsBody2D:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is PhysicsBody2D:
			return child
	return null
