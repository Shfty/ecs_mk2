extends Node

var ball_query = Traitor.query(
	self,
	"Ball",
	[
		Query.Param.concrete(Ball),
		Query.Param.concrete(Position),
		Query.Param.concrete(Velocity)
	]
)

var score_query = Traitor.query(
	self,
	"Score",
	[
		Query.Param.concrete(Score)
	]
)

func _physics_process(delta: float) -> void:
	var score_results = score_query.run()
	var score = null
	for node in score_results:
		score = score_results[node][Score]
		break

	var results = ball_query.run()
	for node in results:
		var result = results[node]
		var position = result[Position].get_property()
		var velocity = result[Velocity].get_component().velocity

		if abs(position.x) > 522 and sign(position.x) == sign(velocity.x):
			result[Position].set_property(Vector2.ZERO)
			result[Velocity].get_component().velocity = Vector2(200 * -sign(velocity.x), 0)
			if position.x < 0:
				score.increment_score(ScoreComponent.Player.Two)
			else:
				score.increment_score(ScoreComponent.Player.One)
