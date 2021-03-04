class_name Score
extends Trait
tool

static func name() -> String:
	return "Score"

static func is_implementor(node: Node) -> bool:
	return node is ScoreComponent

static func debug_string(node: Node) -> String:
	return "P1: %s, P2: %s" % [get_score_p1(node), get_score_p2(node)]

static func get_score_p1(node: Node) -> int:
	assert(is_implementor(node))
	return node.score_p1

static func increment_score_p1(node: Node) -> void:
	assert(is_implementor(node))
	node.score_p1 += 1


static func get_score_p2(node: Node) -> int:
	assert(is_implementor(node))
	return node.score_p2

static func increment_score_p2(node: Node) -> void:
	assert(is_implementor(node))
	node.score_p2 += 1
