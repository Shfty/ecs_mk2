class_name Paddle
extends Trait
tool

static func name() -> String:
	return "Paddle"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is TagPaddle:
			return true
	return false
