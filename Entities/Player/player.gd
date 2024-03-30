class_name Player
extends Node3D

@export var FORWARD_SPEED: float = 0.01
@export var MAX_STICK_DISTANCE: float = 0.5
@export var ROTATION_SPEED: float = 0.01

@onready var stick: Node3D = $Stick
@onready var original_pos: Vector3 = stick.global_position

var stick_distance = 0
var rotation_position = 0

var selected: bool = false:
	set(value):
		$Camera3D.current = value
		selected = value


func _ready():
	$Body.visible = false


func _process(delta):
	if selected:
		input()


func input():
	var forward_direction = Input.get_axis("move_marshmallow_back", "move_marshmallow_forward")
	var rotation_direction = Input.get_axis("rotate_marshmallow_clockwise", "rotate_marshmallow_counterclockwise")
	
	stick_distance += forward_direction * FORWARD_SPEED
	stick_distance = clamp(stick_distance, 0.0, 1.0)
	stick.global_position = stick_distance * MAX_STICK_DISTANCE * -stick.global_transform.basis.z.normalized() + original_pos
	
	rotation_position += rotation_direction * ROTATION_SPEED
	rotation_position = fposmod(rotation_position, TAU)
	stick.rotation.z = rotation_position
