extends Node

var score_query := Traitor.query(
	self,
	"Score",
	[
		Query.Param.concrete(Score),
	]
)

var score_readout_query := Traitor.query(
	self,
	"Score Readout",
	[
		Query.Param.concrete(ScoreReadout),
		Query.Param.concrete(Text)
	]
)

func _process(delta: float) -> void:
	var score_results = score_query.run()

	var score_trait
	for node in score_results:
		score_trait = score_results[node][Score]
		break

	var readout_results = score_readout_query.run()

	for node in readout_results:
		var result = readout_results[node]
		var score = score_trait.get_score(result[ScoreReadout].get_player())
		result[Text].set_property("%s" % score)

