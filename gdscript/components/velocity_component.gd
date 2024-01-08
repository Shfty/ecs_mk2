class_name VelocityComponent
extends Node

export(Vector2) var velocity := Vector2.ZERO

func _to_string() -> String:
	return "Velocity%s" % [velocity]
