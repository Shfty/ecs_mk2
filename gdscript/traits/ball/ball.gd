class_name Ball
extends Trait
tool

static func name() -> String:
	return "Ball"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is TagBall:
			return true
	return false
