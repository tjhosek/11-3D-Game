extends CSGCombiner

export var enemy = preload("res://Scenes/TestDummy.tscn")
onready var spawnCheck = $spawnCheck
onready var spawnLoc = $spawnLocation
var maxspawns = 1
var spawnsleft = -1
var delay = 300
var counter = 0
var isSpawning = true

func _ready():
	pass # Replace with function body.
	
func spawnEnemy():
	var newspawn = enemy.instance(PackedScene.GEN_EDIT_STATE_MAIN)
	newspawn.translation = spawnLoc.translation+Vector3(0,2,0)
	newspawn.scale = Vector3(2.5,2.5,2.5)
	newspawn.rotation_degrees = rotation_degrees
	add_child(newspawn)
	
func _physics_process(delta):
	counter+=1

	if not spawnCheck.is_colliding() and isSpawning:
		spawnEnemy()
		counter = 0