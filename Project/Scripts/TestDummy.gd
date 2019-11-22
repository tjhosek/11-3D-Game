extends KinematicBody

var gravity = 30
var velocity = Vector3()
var health = 10

onready var flinchTween = $Flinch

export var flinch = false

func _ready():
	pass

func _physics_process(delta):
	#Applying Gravity
	velocity.y -= gravity*delta
	velocity.x = 0
	velocity.z = 0
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if health <= 0:
		queue_free()
		
func flinch(node,dam):
	get_node(node)