extends KinematicBody

onready var camera = $Pivot/Camera
onready var raycast = $Pivot/RayCast
onready var weapon_container = $Pivot/Weapons
onready var current_weapon = $Pivot/Weapons/Pistol

var shoot = false
signal shootanims
signal stopShootAnims

var gravity = 30
var jump_speed = 12
var max_speed = 8
var mouse_sensitivity = .002 #Radians per Pixel

var velocity = Vector3()
var jump = false

var damage = 5

func _ready():
	update_weapon()
	connect("shootanims",current_weapon,"fireAnims")
	connect("stopShootAnims",current_weapon,"fireAnimsStop")

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
	if Input.is_action_just_released("primary fire"):
		shoot = false
		emit_signal("stopShootAnims")
	input_dir = input_dir.normalized()
	return input_dir
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y*mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		
func shoot_ray():
	if raycast.is_colliding() and shoot and current_weapon.fireTimer.is_stopped():
		var hit = raycast.get_collider()
		if hit.is_in_group("Enemies"):
			hit.health -= damage
			get_parent().get_node("HUD/Label").text = "hit: "+str(raycast.get_collision_point())
			print(str(raycast.get_collision_point()))
		current_weapon.fireTimer.start()
		
func update_weapon():
	for i in weapon_container.get_children():
		if i.active:
			current_weapon = i
			damage = i.damage
			print(str(current_weapon.name))
			connect("shootanims",current_weapon,"fireAnims")

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
	if not current_weapon.auto:
		shoot = false
	