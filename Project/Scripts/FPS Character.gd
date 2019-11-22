extends KinematicBody

onready var camera = $Pivot/Camera
onready var raycast = $Pivot/Camera/RayCast

var shoot = false
signal shootanims

var gravity = 30
var jump_speed = 12
var max_speed = 8
var mouse_sensitivity = .002 #Radians per Pixel

var velocity = Vector3()
var jump = false

var damage = 0

func _ready():
	connect("shootanims",$Pivot/Pistol,"pistolAnims")

func get_input():
	jump = false
	if Input.is_action_pressed("jump"):
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
		emit_signal("shootanims")
	input_dir = input_dir.normalized()
	return input_dir
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y*mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		
func shoot_ray():
	if raycast.is_colliding() and shoot:
		var hit = raycast.get_collider()
		if hit.is_in_group("Enemies"):
			hit.health -= damage
			get_parent().get_node("HUD/Label").text = "hit: "+str(raycast.get_collision_point())
		

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
	
	shoot_ray()
	shoot = false
	