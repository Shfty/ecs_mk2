class_name OutOfBoundsCollision
extends System
tool

var ball_query = preload("res://resources/queries/ball_query.tres")
var score_query = preload("res://resources/queries/score_query.tres")

func get_queries() -> Array:
	return [ball_query, score_query]

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var score_node = score_query.run_single(get_tree())

	for node in ball_query.run(get_tree()):
		var area = AreaCollision.get_area(node)

		for overlapping in area.get_overlapping_areas():
			var overlapping_node = overlapping.get_parent()
			if OutOfBounds.is_implementor(overlapping_node):
				if Position2.get_position(node).x > 0:
					Score.increment_score_p1(score_node)
				else:
					Score.increment_score_p2(score_node)
				Position2.set_position(node, Vector2.ZERO)
				Velocity2.set_velocity(node, Vector2(-sign(Velocity2.get_velocity(node).x) * 4, 0))
				break
