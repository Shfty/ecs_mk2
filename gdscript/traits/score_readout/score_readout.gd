class_name ScoreReadout
extends Trait
tool

static func name() -> String:
	return "ScoreReadout"

static func is_implementor(node: Node) -> bool:
	for child in node.get_children():
		if child is ScoreReadoutComponent:
			return true
	return false

static func debug_string(node: Node) -> String:
	match get_player(node):
		ScoreReadoutComponent.Player.P1:
			return "P1"
		ScoreReadoutComponent.Player.P2:
			return "P2"
	return ""

static func get_player(node: Node) -> int:
	assert(is_implementor(node))

	for child in node.get_children():
		if child is ScoreReadoutComponent:
			return child.player

	return -1

