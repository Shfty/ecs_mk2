class_name ScoreComponent
extends Node

enum Player {
	One,
	Two
}

export(Dictionary) var score := {
	Player.One: 0,
	Player.Two: 0
}
