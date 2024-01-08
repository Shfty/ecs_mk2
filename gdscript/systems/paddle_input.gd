extends Node

var paddle_query := Traitor.query(
	self,
	"Paddle",
	[
		Query.Param.concrete(Paddle),
		Query.Param.concrete(Position),
		Query.Param.concrete(Velocity)
	]
)

var mouse_position := Vector2.ZERO
var last_mouse_position := Vector2.ZERO

var first := true

func _physics_process(_delta: float) -> void:
	var results = paddle_query.run()

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var delta = mouse_position - last_mouse_position
		for node in results:
			var result = results[node]
			result[Velocity].get_component().velocity.y = delta.y * 60.0
	else:
		for node in results:
			var result = results[node]
			result[Velocity].get_component().velocity.y = 0

	last_mouse_position = mouse_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = event.position
		if first:
			last_mouse_position = mouse_position
			first = false
