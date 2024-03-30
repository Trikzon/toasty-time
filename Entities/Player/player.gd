class_name Player
extends Node3D

@export var FORWARD_SPEED: float = 0.01
@export var MAX_STICK_DISTANCE: float = 0.35
@export var ROTATION_SPEED: float = 0.01
@export var COOK_SPEED: float = 1.0
@export var COOK_TOL: float = 0.1

@onready var stick: Node3D = $Stick
@onready var original_pos: Vector3 = stick.global_position
@onready var marshmallow_cook_time

var marshmallow_cook_values: Array[float] = []
var most_recent_score=0
var stick_distance = 0
var rotation_position = 0
var selected: bool = false:
	set(value):
		$Camera3D.current = value
		selected = value

func _ready():
	$Body.visible = false
	
	for _i in range(360):
		marshmallow_cook_values.append(0.0)
	
	prep_marshmallow()

func _physics_process(delta):
	if selected:
		input()
	if(stick_distance>0.2):
		for i in range(360):
			marshmallow_cook_values[i]+=(abs(180-(abs(i-(rad_to_deg(rotation_position) as int))))/180.0)*delta*COOK_SPEED*stick_distance
	var cooked_count = 0
	if stick_distance <= 0.2:
		for i in range(360):
			cooked_count+=int(marshmallow_cook_values[i] >= marshmallow_cook_time)
	
	#debug
	for i in range(360):
		if i%30==0&&selected:
			print(marshmallow_cook_values[i])
	
	if (cooked_count/360.0)>=(1.0-COOK_TOL):
		prep_marshmallow()
	
func prep_marshmallow():
	var mean_cook=0
	for i in range(360):
		mean_cook+=marshmallow_cook_values[i]
	mean_cook/=360
	var temp_sum=0
	for i in range(360):
		temp_sum+=pow(marshmallow_cook_values[i]-mean_cook,2)
	temp_sum/=360
	#most_recent_score
	#sqrt(temp_sum)
	#abs(marshmallow_cook_time-mean_cook)
	marshmallow_cook_values.clear()
	for _i in range(360):
		marshmallow_cook_values.append(0)
	marshmallow_cook_time=randf_range(10,15)
	#add animation for marshmallow swap
func input():
	var forward_direction = Input.get_axis("move_marshmallow_back", "move_marshmallow_forward")
	var rotation_direction = Input.get_axis("rotate_marshmallow_clockwise", "rotate_marshmallow_counterclockwise")
	
	stick_distance += forward_direction * FORWARD_SPEED
	stick_distance = clamp(stick_distance, 0.0, 1.0)
	stick.global_position = stick_distance * MAX_STICK_DISTANCE * -stick.global_transform.basis.z.normalized() + original_pos
	
	rotation_position += rotation_direction * ROTATION_SPEED
	rotation_position = fposmod(rotation_position, TAU)
	stick.rotation.z = rotation_position
