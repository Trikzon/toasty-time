extends Node3D

@onready var camera_animation_player: AnimationPlayer = $Camera3D/AnimationPlayer

@export var selected_player: int:
	set(value):
		for player in players:
			player.selected = false
		
		if players.size() > 0 and value != -5:
			selected_player = value
		


var players: Array[Player] = []

func _ready():
	for child in get_children():
		if child is Player:
			players.append(child)
	
	selected_player = 0
	players[selected_player].selected = true


func _process(_delta):
	move_camera()


func move_camera():
	if camera_animation_player.is_playing():
		return
	
	if Input.is_action_just_pressed("swap_clockwise"):
		camera_animation_player.play("%s_to_%s" % [selected_player, posmod(selected_player + 1, players.size())])
		selected_player = posmod(selected_player + 1, players.size())
	if Input.is_action_just_pressed("swap_counterclockwise"):
		camera_animation_player.play_backwards("%s_to_%s" % [posmod(selected_player - 1, players.size()), selected_player])
		selected_player = posmod(selected_player - 1, players.size())


func _on_animation_player_animation_finished(_sanim_name):
	players[selected_player].selected = true
