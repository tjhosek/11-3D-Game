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
var idle_spd = 1

func _ready():
	for i in range(len(pistol_idle_locs)):
		var prev = Vector3()
		if i == 0:
			prev = pistol_idle_locs[len(pistol_idle_locs)-1]
		else:
			prev = pistol_idle_locs[i-1]
		idleTween.interpolate_property(self,"rotation_degrees",prev,pistol_idle_locs[i],idle_spd,Tween.TRANS_SINE,Tween.EASE_IN_OUT,i*idle_spd)
	idleTween.start()