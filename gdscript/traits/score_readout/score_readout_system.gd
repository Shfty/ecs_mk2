class_name ScoreReadoutSystem
extends System
tool

var score_query := preload("res://resources/queries/score_query.tres")
var readout_query = Traitor.query("Score Readout Query", [ScoreReadout, Text])

func get_queries() -> Array:
	return [score_query, readout_query]

func _process(delta: float) -> void:
	var score_node = score_query.run_single(get_tree())

	for node in readout_query.run(get_tree()):
		var player = ScoreReadout.get_player(node)
		var score := -1
		match player:
			ScoreReadoutComponent.Player.P1:
				score = Score.get_score_p1(score_node)
			ScoreReadoutComponent.Player.P2:
				score = Score.get_score_p2(score_node)
		Text.set_text(node, String(score))
