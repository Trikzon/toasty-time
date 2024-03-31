extends Button


func _on_pressed():
	Globals.reset()
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
