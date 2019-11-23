extends MeshInstance

class_name Weapon

signal shoot

export var auto = false

onready var fireTween = $Fire
onready var idleTween = $Idle

export var base_rotation = Vector3(-2.029,-176.264,-2.347)
export var reco_loc = Vector3(-40.312,-175.101,-5.388)
export var base_location = Vector3(.254,-.265,-.395)
export var fire_anim_speed = .05
export var recovery_anim_speed = .1
var idle_locs = [
	base_rotation,
	Vector3(-3.758,-172.448,-2.526),
	Vector3(3.624,-174.797,0.981)
]
export var idle_anim_offset = Vector3(0,-.03,0)
export var idle_spd = 1
export var idle_translation_speed = 1.5

export var active = false

var fire_trans = Tween.TRANS_CUBIC

func _ready():
	#Updating position if active
	if active:
		translation = base_location
		rotation_degrees = base_rotation
	else:
		translation = Vector3(0,-.5,0)
		rotation_degrees =Vector3(0,0,0)
	
	#Rotation Sway Anims
	for i in range(len(idle_locs)):
		var prev = Vector3()
		if i == 0:
			prev = idle_locs[len(idle_locs)-1]
		else:
			prev = idle_locs[i-1]
		idleTween.interpolate_property(self,"rotation_degrees",prev,idle_locs[i],idle_spd,Tween.TRANS_SINE,Tween.EASE_IN_OUT,i*idle_spd)
	
	#positional sway Anims
	idleTween.interpolate_property(self,"translation",null,translation+idle_anim_offset,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
	idleTween.interpolate_property(self,"translation",translation+idle_anim_offset,translation,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT,idle_translation_speed)
	
	if active:
		idleTween.start()
	
func fireAnims():
	fireTween.interpolate_property(self,"rotation_degrees",null,reco_loc,fire_anim_speed,fire_trans,Tween.EASE_OUT)
	fireTween.interpolate_property(self,"rotation_degrees",reco_loc,base_rotation,recovery_anim_speed,fire_trans,Tween.EASE_OUT,fire_anim_speed)
	fireTween.start()
	
func _physics_process(delta):
	pass