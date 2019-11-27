extends KinematicBody

onready var camera = $Pivot/Camera
onready var raycast = $Pivot/RayCast
onready var weapon_container = $Pivot/Weapons.get_children()
onready var current_weapon = $Pivot/Weapons/Pistol

var weaponIndex = 0
var kills = 0

var shoot = false
signal shootanims
signal stopShootAnims
signal smoke

var gravity = 30
var jump_speed = 12
var max_speed = 8
var mouse_sensitivity = .002 #Radians per Pixel

var velocity = Vector3()
var jump = false

var spread_generator = RandomNumberGenerator.new()

func _ready():
	connect("smoke",get_parent(),"spawn_gunsmoke")
	spread_generator.randomize()
	update_weapon()

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
	if Input.is_action_just_released("primary fire") and current_weapon.auto:
		shoot = false
		emit_signal("stopShootAnims")
	if Input.is_action_just_pressed("switch_weapons_up"):
		update_weapon(1,true)
	if Input.is_action_just_pressed("switch_weapons_down"):
		update_weapon(-1,true)
	if Input.is_action_just_pressed("weapon_1"):
		update_weapon(0)
	if Input.is_action_just_pressed("weapon_2"):
		update_weapon(1)
	if Input.is_action_just_pressed("weapon_3"):
		update_weapon(2)
	if Input.is_action_just_pressed("weapon_4"):
		update_weapon(3)
	input_dir = input_dir.normalized()
	return input_dir
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x*mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y*mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		
func increase_kills():
	kills += 1
	get_parent().get_node("HUD/Label").text = "Kills: "+str(kills)
		
func shoot_ray(n):
	if shoot and current_weapon.fireTimer.is_stopped():
		for i in range(n):
			spread_generator.randomize()
			var deviation = Vector3(spread_generator.randf_range(-current_weapon.spread,current_weapon.spread),spread_generator.randf_range(-current_weapon.spread,current_weapon.spread),0)
			#print("deviation: "+str(deviation))
			raycast.rotation_degrees = deviation
			raycast.force_raycast_update()
			if raycast.is_colliding():
				var hit = raycast.get_collider()
				if hit.is_in_group("Enemies"):
					hit.health -= current_weapon.damage
					#get_parent().get_node("HUD/Label").text = "hit: "+str(raycast.get_collision_point())
					#print("hit: "+str(raycast.get_collision_point()))
				emit_signal("smoke",to_global(current_weapon.base_location)+current_weapon.get_node("BarrelPoint").translation,raycast.get_collision_point())
		current_weapon.fireTimer.start()
		
func update_weapon(number = 0,addToIndex = false):
	if addToIndex:
		weaponIndex += number
		if weaponIndex >= len(weapon_container):
			weaponIndex = 0
		elif weaponIndex < 0:
			weaponIndex = len(weapon_container)-1
	else:
		if number < len(weapon_container) and number >= 0:
			weaponIndex = number
	
	
	for i in range(len(weapon_container)):
		if i == weaponIndex:
			current_weapon = weapon_container[i]
			current_weapon.active = true
			print(str(current_weapon.name))
			connect("shootanims",current_weapon,"fireAnims")
			connect("stopShootAnims",current_weapon,"fireAnimsStop")
			current_weapon.update()
		else:
			weapon_container[i].active = false
			weapon_container[i].update()

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
	
	shoot_ray(current_weapon.projectiles)
	if not current_weapon.auto:
		shoot = false
	