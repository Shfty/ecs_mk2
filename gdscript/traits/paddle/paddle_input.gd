class_name PaddleInput
extends System
tool

var paddle_query = Traitor.query("Paddle Query", [Paddle, Velocity2])

export(Vector2) var factor := Vector2(1, 1)

var first := true
var mouse_position := Vector2.ZERO
var last_mouse_position := Vector2.ZERO

func get_queries() -> Array:
	return [paddle_query]

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if first:
		last_mouse_position = mouse_position
		first = false

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var delta = mouse_position - last_mouse_position
		for node in paddle_query.run(get_tree()):
			Velocity2.set_velocity(node, delta * factor)
	else:
		for node in paddle_query.run(get_tree()):
			Velocity2.set_velocity(node, Vector2.ZERO)

	last_mouse_position = mouse_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		mouse_position = event.position

