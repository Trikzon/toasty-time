extends Label

@export var run_game: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text= "Score: %s" % Globals.score
	if Globals.time_since_swap<300:
		Globals.time_since_swap+=1
		text= "Score: %s " % Globals.score
		if Globals.most_recent_score>=11:
			text=str(text,"★★★")
		elif Globals.most_recent_score>=6:
			text=str(text,"★★☆")
		else:
			text=str(text,"★☆☆")
			
	
	if run_game:
		text=str(text,"\nTime Remaining: ",int(Globals.GAME_LENGTH-Globals.game_time))
	pass
