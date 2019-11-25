extends MeshInstance

class_name Weapon

signal shoot

export var auto = false

onready var fireTween = $Fire
onready var idleTween = $Idle
onready var fireTimer = $"Fire Speed Timer"

export var base_rotation = Vector3(6.229,-177.344,-4.282)
export var reco_loc = Vector3(-21.551,-170.427,-4.427)
export var base_location = Vector3(0.254,-0.208,-0.406)
export var fire_anim_speed = .05
export var recovery_anim_speed = .1

export var idle_rotation_1 = Vector3(1.833,-172.188,-4.119)
export var idle_rotation_2 = Vector3(5.66,-172.465,-4.137)

var idle_locs = [
	self.base_rotation,
	self.idle_rotation_1,
	self.idle_rotation_2
]
export var idle_anim_offset = Vector3(0,-.03,0)
export var idle_spd = 1
export var idle_translation_speed = 1.5

export var fire_speed = .3

export var active = false

var fire_trans = Tween.TRANS_CUBIC

#Weapon Stats
export var damage = 0
export var spread = 0
export var projectiles = 1
export var melee = false

func _ready():
	#Setting timer for firespeed
	fireTimer.wait_time = fire_speed + fire_anim_speed + recovery_anim_speed
	
	#Updating position if active
	if active:
		self.translation = base_location
		self.rotation_degrees = base_rotation
	else:
		translation = Vector3(0,-.5,0)
		rotation_degrees =Vector3(0,0,0)
		
	#Updating fire anims if automatic
	if auto:
		fireTween.repeat = true
	
	
	#Rotation Sway Anims
	for i in range(len(idle_locs)):
		var prev = Vector3()
		if i == 0:
			prev = idle_locs[-1]
		else:
			prev = idle_locs[i-1]
		idleTween.interpolate_property(self,"rotation_degrees",prev,idle_locs[i],idle_spd,Tween.TRANS_SINE,Tween.EASE_IN_OUT,i*idle_spd)
	
	#positional sway Anims
	idleTween.interpolate_property(self,"translation",null,translation+idle_anim_offset,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
	idleTween.interpolate_property(self,"translation",translation+idle_anim_offset,translation,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT,idle_translation_speed)
	
	if active:
		idleTween.start()
		
	
	
func fireAnims():
	if fireTimer.is_stopped():
		fireTween.interpolate_property(self,"rotation_degrees",null,reco_loc,fire_anim_speed,fire_trans,Tween.EASE_OUT)
		fireTween.interpolate_property(self,"rotation_degrees",reco_loc,base_rotation,recovery_anim_speed,fire_trans,Tween.EASE_OUT,fire_anim_speed)
		fireTween.interpolate_property(self,"rotation_degrees",null,base_rotation,fire_speed,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,fire_anim_speed+recovery_anim_speed)
		fireTween.start()
		#fireTimer.start()
	
	
func fireAnimsStop():
	fireTween.remove_all()
	
func _physics_process(delta):
	pass
	
func update():
	if active:
		self.translation = base_location
		self.rotation_degrees = base_rotation
		
		idleTween.interpolate_property(self,"translation",null,translation+idle_anim_offset,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
		idleTween.interpolate_property(self,"translation",translation+idle_anim_offset,translation,idle_translation_speed,Tween.TRANS_QUART,Tween.EASE_IN_OUT,idle_translation_speed)
		
		for i in range(len(idle_locs)):
			var prev = Vector3()
			if i == 0:
				prev = idle_locs[-1]
			else:
				prev = idle_locs[i-1]
			idleTween.interpolate_property(self,"rotation_degrees",prev,idle_locs[i],idle_spd,Tween.TRANS_SINE,Tween.EASE_IN_OUT,i*idle_spd)
		
		idleTween.start()
	else:
		translation = Vector3(0,-.5,0)
		rotation_degrees =Vector3(0,0,0)
		idleTween.remove_all()
		fireAnimsStop()