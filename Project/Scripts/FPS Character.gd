extends KinematicBody

onready var camera = $Pivot/Camera
onready var pistol = $Pivot/Pistol/Fire
onready var pistolidle = $Pivot/Pistol/Idle

var shoot = false

var gravity = 30
var jump_speed = 12
var max_speed = 8
var mouse_sensitivity = .002 #Radians per Pixel

#Pistol Animation Variables
var base_loc = Vector3(-2.029,-176.264,-2.347)
var reco_loc = Vector3(-40.312,-175.101,-5.388)
var fire_spd = .05
var reco_speed = .1
var fire_trans = Tween.TRANS_CUBIC
var pistol_idle_locs = [
	base_loc,
	Vector3(-4.758,-172.448,-2.526),
	Vector3(6.624,-174.797,0.981)
]
var idle_spd = 1

var velocity = Vector3()
var jump = false

func _ready():
	for i in range(len(pistol_idle_locs)):
		var prev = Vector3()
		if i == 0:
			prev = pistol_idle_locs[len(pistol_idle_locs)-1]
		else:
			prev = pistol_idle_locs[i-1]
		pistolidle.interpolate_property(pistolidle.get_parent(),"rotation_degrees",prev,pistol_idle_locs[i],idle_spd,Tween.TRANS_QUART,Tween.EASE_IN_OUT,i*idle_spd)
	pistolidle.start()

func get_input():
	jump = false
	if Input.is_action_just_pressed("jump"):
		jump = true
	var input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += camera.global_transform.basis.x
	if Input.is_action_just_pressed("primary fire"):
		shoot = true
	input_dir = input_dir.normalized()
	return input_dir
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y*mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		
func pistolAnims():
	if shoot:
		pistol.interpolate_property(pistol.get_parent(),"rotation_degrees",null,reco_loc,fire_spd,fire_trans,Tween.EASE_OUT)
		pistol.interpolate_property(pistol.get_parent(),"rotation_degrees",reco_loc,base_loc,reco_speed,fire_trans,Tween.EASE_OUT,fire_spd)
	
	


func _physics_process(delta):
	#Applying Gravity
	velocity.y -= gravity*delta
	var desired_velocity = get_input() * max_speed
	
	#Moving
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	#Checking for Jump
	if jump and is_on_floor():
		velocity.y = jump_speed
		
	#Pistol Anims
	pistolAnims()
	pistol.start()
	shoot = false
	