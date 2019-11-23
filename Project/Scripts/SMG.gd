extends MeshInstance

signal shoot

onready var fireTween = $Fire
onready var idleTween = $Idle

var base_loc = Vector3(-2.029,-176.264,-2.347)
var reco_loc = Vector3(-40.312,-175.101,-5.388)
var fire_spd = .05
var reco_speed = .1
var fire_trans = Tween.TRANS_CUBIC
var pistol_idle_locs = [
	base_loc,
	Vector3(-3.758,-172.448,-2.526),
	Vector3(3.624,-174.797,0.981)
]
var idle_translation = Vector3(0,-.03,0)
var idle_spd = 1
var idle_translation_speed = 1.5

func _ready():
	#Rotation Sway Anims
	for i in range(len(pistol_idle_locs)):
		var prev = Vector3()
		if i == 0:
			prev = pistol_idle_locs[len(pistol_idle_locs)-1]
		else:
			prev = pistol_idle_locs[i-1]
		idleTween.interpolate_property(self,"rotation_degrees",prev,pistol_idle_locs[i],idle_spd,Tween.TRANS_SINE,Tween.EASE_IN_OUT,i*idle_spd)
	
	#positional sway Anims
	idleTween.interpolate_property(self,"translation",null,translation+idle_translation,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
	idleTween.interpolate_property(self,"translation",translation+idle_translation,translation,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT,idle_translation_speed)
	idleTween.start()
	
func pistolAnims():
	fireTween.interpolate_property(self,"rotation_degrees",null,reco_loc,fire_spd,fire_trans,Tween.EASE_OUT)
	fireTween.interpolate_property(self,"rotation_degrees",reco_loc,base_loc,reco_speed,fire_trans,Tween.EASE_OUT,fire_spd)
	fireTween.start()