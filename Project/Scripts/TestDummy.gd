extends KinematicBody

var gravity = 30
var velocity = Vector3()

func _ready():
	pass

func _physics_process(delta):
	#Applying Gravity
	velocity.y -= gravity*delta
	velocity.x = 0
	velocity.z = 0
	
	velocity = move_and_slide(velocity, Vector3.UP, true)