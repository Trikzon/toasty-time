extends Node

const GAME_LENGTH = 10

var score: int = 0
var time_since_swap: int = 300
var most_recent_score: int = 0

var game_time: float = 0.0

func _process(delta):
	game_time += delta


func reset():
	score = 0
	time_since_swap = 300
	most_recent_score = 0
	game_time = 0.0
