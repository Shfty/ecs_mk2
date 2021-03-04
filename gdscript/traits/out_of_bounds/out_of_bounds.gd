class_name OutOfBounds
extends Trait
tool

static func name() -> String:
	return "OutOfBounds"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is TagOutOfBounds:
			return true
	return false
