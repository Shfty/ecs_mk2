class_name PaddleCollision
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

		for overlapping in area.get_overlapping_areas():
			var overlapping_node = overlapping.get_parent()
			if Paddle.is_implementor(overlapping_node):
				var overlapping_position = Position2.get_position(overlapping_node)
				if sign(velocity.x) == sign(overlapping_position.x):
					var new_velocity = velocity * Vector2(-1, 1)
					new_velocity.x += sign(new_velocity.x)
					new_velocity.y += Velocity2.get_velocity(overlapping_node).y
					new_velocity.y = clamp(new_velocity.y, -8, 8)
					Velocity2.set_velocity(node, new_velocity)
					break
