class_name InterpolatorSystem
extends System
tool

var interpolator_query := Traitor.query("Interpolator Query", [Interpolator])

func get_queries() -> Array:
	return [interpolator_query]

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	for node in interpolator_query.run(get_tree()):
		var position = Position2.get_position(node)
		var last_position = Interpolator.get_last_position(node)
		var delta = position - last_position
		var interp = delta * Engine.get_physics_interpolation_fraction()
		var target = last_position + interp
		var local = target - position
		for child in node.get_children():
			if Interpolant.is_implementor(child):
				Position2.set_position(child, local)

func _physics_process(_delta: float) -> void:
	for node in interpolator_query.run(get_tree()):
		var position = Position2.get_position(node)
		Interpolator.set_last_position(node, position)
