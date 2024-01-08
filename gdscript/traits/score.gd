class_name Score
extends Trait
tool

func _name() -> String:
	return "Score"

func _is_implementor(node: Node) -> bool:
	return node is ScoreComponent

func get_score(player: int) -> int:
	return get_node().score[player]

func increment_score(player: int) -> void:
	get_node().score[player] += 1
