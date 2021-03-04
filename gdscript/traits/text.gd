class_name Text
extends Trait
tool

static func name() -> String:
	return "Text"

static func is_implementor(node: Node) -> bool:
	if not node.has_method("get_text"):
		return false

	if not node.has_method("set_text"):
		return false

	if not node.get_text() is String:
		return false

	return true

static func debug_string(node: Node) -> String:
	return get_text(node)

static func get_text(node: Node) -> String:
	assert(is_implementor(node))
	return node.get_text()

static func set_text(node: Node, new_text: String) -> void:
	assert(is_implementor(node))
	node.set_text(new_text)
