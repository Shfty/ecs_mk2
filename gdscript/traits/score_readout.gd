class_name ScoreReadout
extends ComponentTrait
tool

func _init() -> void:
	component = ScoreReadoutComponent

func _name() -> String:
	return "ScoreReadout"

func get_player() -> int:
	return get_component().player
