extends Spatial

var smoke_trail = preload("res://Scenes/Smoke Trail.tscn")
onready var drawer = get_node("ImmediateGeometry")
onready var smokeTimer = $SmokeTimer

# Declare member variables here. Examples:
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func spawn_gunsmoke(posa,posb):
#	var smoke = smoke_trail.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	print(str(posa),str(posb))
#	smoke.rotation = posa.direction_to(posb)
#	smoke.translation = posa
#	add_child(smoke)
	drawer.begin(Mesh.PRIMITIVE_LINES)
	drawer.set_color(Color.gray)
	drawer.set_normal(Vector3(0,0,1))
	drawer.set_uv(Vector2(0,0))
	drawer.add_vertex(posa)
	drawer.set_normal(Vector3(0,0,1))
	drawer.set_uv(Vector2(0,1))
	drawer.add_vertex(posb)
	drawer.end()
	smokeTimer.start()
	
func _physics_process(delta):
	if smokeTimer.is_stopped():
		drawer.clear()