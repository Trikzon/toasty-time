extends Node3D


func _process(delta):
	if Globals.game_time >= Globals.GAME_LENGTH:
		get_tree().change_scene_to_file("res://Scenes/EndScreen/end_screen.tscn")
