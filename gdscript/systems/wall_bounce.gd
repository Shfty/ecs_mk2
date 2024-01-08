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

func _physics_process(delta: float) -> void:
	var results = ball_query.run()
	for node in results:
		var result = results[node]
		var position = result[Position].get_property()
		var velocity = result[Velocity].get_component().velocity

		if abs(position.y) > 290 and sign(position.y) == sign(velocity.y):
			result[Velocity].get_component().velocity *= Vector2(1, -1)
