extends Node

var position_velocity_query = Traitor.query(
	self,
	"Velocity + Position",
	[
		Query.Param.concrete(Position),
		Query.Param.concrete(Velocity)
	]
)

func _physics_process(delta: float) -> void:
	var results = position_velocity_query.run()
	for node in results:
		var result = results[node]
		result[Position].set_property(
			result[Position].get_property()
			+ result[Velocity].get_component().velocity
			* delta
		)
