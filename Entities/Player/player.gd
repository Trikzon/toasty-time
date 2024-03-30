class_name Player
extends Node3D

@export var FORWARD_SPEED: float = 0.01
@export var MAX_STICK_DISTANCE: float = 0.35
@export var ROTATION_SPEED: float = 0.01
@export var COOK_SPEED: float = 1.0

@onready var stick: Node3D = $Stick
@onready var original_pos: Vector3 = stick.global_position
@onready var marshmallow_cook
@onready var marshmallow_cook_time

var stick_distance = 0
var rotation_position = 0

var selected: bool = false:
	set(value):
		$Camera3D.current = value
		selected = value

func _ready():
	$Body.visible = false
	prep_marshmallow()

func _physics_process(delta):
	if selected:
		input()
	if(stick_distance>0.2):
		marshmallow_cook+=delta*COOK_SPEED*stick_distance
	if marshmallow_cook>=marshmallow_cook_time&&stick_distance<=0.2:
		prep_marshmallow()
	print(marshmallow_cook)
	
func prep_marshmallow():
	marshmallow_cook=0.0
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
