extends Node

var paddle_query := Traitor.query(
	self,
	"Paddle",
	[
		Query.Param.concrete(Paddle),
		Query.Param.concrete(Position)
	]
)

func _physics_process(_delta: float) -> void:
	var results = paddle_query.run()

	for node in results:
		var result = results[node]
		var position = result[Position].get_property()
		if abs(position.y) > 268:
			result[Position].set_property(Vector2(position.x, 268 * sign(position.y)))
