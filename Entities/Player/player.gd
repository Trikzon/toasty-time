class_name Player
extends Node3D

@export var FORWARD_SPEED: float = 0.03
@export var MAX_STICK_DISTANCE: float = 0.35
@export var ROTATION_SPEED: float = 0.05
@export var COOK_SPEED: float = 1.5
@export var COOK_TOL: float = 0.2

@onready var stick: Node3D = $StickPivot/Stick
@onready var marshmallow: MeshInstance3D = $StickPivot/Stick/Marshmallow
@onready var original_pos: Vector3 = stick.global_position
@onready var marshmallow_cook_time

var marshmallow_cook_values: Array[float] = []
var most_recent_score=0
var stick_distance = 0
var rotation_position = 0

var selected: bool = false

func _ready():
	$Body.visible = false
	
	marshmallow.mesh.surface_set_material(0, marshmallow.mesh.surface_get_material(0).duplicate())
	
	for _i in range(360):
		marshmallow_cook_values.append(0.0)
	
	marshmallow_cook_values.clear()
	for _i in range(360):
		marshmallow_cook_values.append(0)
	marshmallow_cook_time=randf_range(10.0,15.0)

func _physics_process(delta):
	if selected:
		input()
	if(stick_distance>0.2):
		for i in range(360):
			marshmallow_cook_values[i]+=(abs(180-(abs(i-(rad_to_deg(rotation_position) as int))))/180.0)*delta*COOK_SPEED*stick_distance
	
	set_marshmallow_cook_image()
	
	var cooked_count = 0
	if stick_distance <= 0.2:
		for i in range(360):
			cooked_count+=int(marshmallow_cook_values[i] >= marshmallow_cook_time)
	
	#debug
	#for i in range(360):
		#if i%30==0&&selected:
			#print(marshmallow_cook_values[i])
	
	if (cooked_count/360.0)>=(1.0-COOK_TOL):
		prep_marshmallow()
	
func prep_marshmallow():
	var mean_cook=0
	for i in range(360):
		mean_cook+=marshmallow_cook_values[i]
	mean_cook/=360
	var std_div=0
	for i in range(360):
		std_div+=pow(marshmallow_cook_values[i]-mean_cook,2)
	std_div=sqrt(std_div/360)
	var cook_closeness=abs(marshmallow_cook_time-mean_cook)
	most_recent_score=3
	if std_div<=10:
		most_recent_score+=1
	if std_div<=5:
		most_recent_score+=1
	if std_div<=3:
		most_recent_score+=1
	if std_div<=1:
		most_recent_score+=1
	if std_div<=0.5:
		most_recent_score+=1
	if std_div<=0.25:
		most_recent_score+=1
	if cook_closeness<=marshmallow_cook_time:
		most_recent_score+=1
	if cook_closeness<=(marshmallow_cook_time/2):
		most_recent_score+=1
	if cook_closeness<=(marshmallow_cook_time/3):
		most_recent_score+=1
	if cook_closeness<=(marshmallow_cook_time/4):
		most_recent_score+=1
	if cook_closeness<=(marshmallow_cook_time/5):
		most_recent_score+=1
	if cook_closeness<=(marshmallow_cook_time/6):
		most_recent_score+=1
	Globals.score+=most_recent_score
	Globals.most_recent_score=most_recent_score
	Globals.time_since_swap=0
	print(std_div)
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
	stick.global_position = stick_distance * MAX_STICK_DISTANCE * stick.global_transform.basis.y.normalized() + original_pos
	
	rotation_position += rotation_direction * ROTATION_SPEED
	rotation_position = fposmod(rotation_position, TAU)
	stick.rotation.y = rotation_position + deg_to_rad(90)


func set_marshmallow_cook_image():
	var image_texture = ImageTexture.new()
	var dyn_image = Image.create(1, 360, false, Image.FORMAT_RGBA8)
	dyn_image.fill(Color(1, 0, 0, 1))
	
	for i in range(360):
		var color = Color(
			clamp(marshmallow_cook_values[i] / (marshmallow_cook_time/2), 0.0, 1.0), 
			clamp((marshmallow_cook_values[i]-(marshmallow_cook_time/2))/ (marshmallow_cook_time/2), 0.0, 1.0), 
			clamp((marshmallow_cook_values[i] - marshmallow_cook_time)/(marshmallow_cook_time/2), 0.0, 1.0), 
			clamp((marshmallow_cook_values[i] - (marshmallow_cook_time*1.5)) / (marshmallow_cook_time/2), 0.0, 1.0)
		)
		dyn_image.set_pixel(0, i, color)
	
	(marshmallow.mesh.surface_get_material(0) as ShaderMaterial).set_shader_parameter("CookGradient", ImageTexture.create_from_image(dyn_image))
