class_name Name
extends Trait
tool

static func name() -> String:
	return "Name"

static func is_implementor(node: Node) -> bool:
	return true

static func debug_string(node: Node) -> String:
	return node.get_name()

static func get_node_name(node: Node) -> String:
	assert(is_implementor(node))
	return node.get_name()

static func set_node_name(node: Node, new_name: String) -> void:
	assert(is_implementor(node))
	node.set_name(new_name)
