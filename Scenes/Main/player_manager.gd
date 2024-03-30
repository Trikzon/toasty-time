extends Node3D

var players: Array[Player]

var selected_player: int:
	set(value):
		for player in players:
			player.selected = false
		
		selected_player = posmod(value, players.size())
		players[selected_player].selected = true

func _ready():
	for child in get_children():
		if child is Player:
			players.append(child)
	selected_player = 0

func _process(delta):
	if Input.is_action_just_pressed("swap_clockwise"):
		selected_player += 1
	if Input.is_action_just_pressed("swap_counterclockwise"):
		selected_player -= 1
