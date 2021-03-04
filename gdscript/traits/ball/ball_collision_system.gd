class_name BallCollisionSystem
extends System
tool

var ball_query = preload("res://resources/queries/ball_query.tres")

func get_queries() -> Array:
	return [ball_query]

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	for node in ball_query.run(get_tree()):
		var velocity = Velocity2.get_velocity(node)
		var area = AreaCollision.get_area(node)

		for overlapping in area.get_overlapping_bodies():
			var overlapping_node = overlapping.get_parent()
			if Position2.is_implementor(overlapping_node):
				if sign(velocity.y) == sign(Position2.get_position(overlapping_node).y):
					Velocity2.set_velocity(node, velocity * Vector2(1, -1))
					break
