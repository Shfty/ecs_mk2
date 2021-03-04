class_name Queries
extends Trait
tool

static func name() -> String:
	return "Queries"

static func is_implementor(node: Node) -> bool:
	if not node.has_method("get_queries"):
		return false

	if not node.get_queries() is Array:
		return false

	return true

static func get_queries(node: Node) -> Array:
	assert(is_implementor(node))
	return node.get_queries()
