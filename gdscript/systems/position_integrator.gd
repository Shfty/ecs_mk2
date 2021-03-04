class_name PositionIntegrator
extends System
tool

var position_velocity_query := Traitor.query("Velocity / Position Query", [Velocity2, Position2])

func get_queries() -> Array:
	return [position_velocity_query]

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	for node in position_velocity_query.run(get_tree()):
		Position2.set_position(
			node,
			Position2.get_position(node) +
			Velocity2.get_velocity(node)
		)
