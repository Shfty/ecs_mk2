class_name ScoreReadoutComponent
extends Node

export(ScoreComponent.Player) var player := ScoreComponent.Player.One

func _to_string() -> String:
	var string := ""

	match player:
		ScoreComponent.Player.One:
			string = "P1"
		ScoreComponent.Player.Two:
			string = "P2"

	return "ScoreReadoutComponent(%s)" % [string]
