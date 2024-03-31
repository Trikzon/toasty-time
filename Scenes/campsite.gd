extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Globals.game_time > Globals.GAME_LENGTH - 2.5:
		for child in $Campfire.get_children():
			if child is OmniLight3D:
				child.light_energy -= delta / 2
		
		#$Campfire/Fire.scale -= Vector3(delta, delta, delta)
	
	if Globals.game_time > Globals.GAME_LENGTH - 0.5:
		for child in $Campfire.get_children():
			child.queue_free()
