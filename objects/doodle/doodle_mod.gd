extends Node3D
class_name Doodle

## DNA
@export var dna : DoodleDNA

## Traits
@export var noses : Array[MeshInstance3D]
@export var ears : Array[MeshInstance3D]
@export var tails : Array[MeshInstance3D]
@export var colored_meshes : Array[MeshInstance3D]

## Child References
@onready var skeleton := $TT_pets/Skeleton3D
@onready var animator := $AnimationPlayer
@onready var eye_mesh := $TT_pets/Skeleton3D/TheBeanEyes
@onready var left_pupil := $TT_pets/LPupil
@onready var right_pupil := $TT_pets/RPupil
@onready var body := $TT_pets/Skeleton3D/TheBeanBody
@onready var blink_timer := $BlinkTimer
@onready var hair : MeshInstance3D = $TT_pets/Skeleton3D/TheBirdHeadFeathers


## Locals
var eyes : Array[Texture2D]
var eyes_open := true
var anim_timescales := {
	'jump_hang' = 0.5,
}


func _ready():
	set_animation('neutral')
	if not dna:
		dna = DoodleDNA.new()
		dna.randomize_dna()
	apply_dna()

func set_animation(anim : String):
	if animator.has_animation(anim):
		if anim_timescales.has(anim):
			animator.speed_scale = anim_timescales[anim]
		else:
			animator.speed_scale = 1.0
		animator.play(anim)

func apply_dna():
	if not dna:
		return
	
	for i in noses.size():
		noses[i].visible = i == dna.nose as int
	
	for i in tails.size():
		tails[i].visible = i == dna.tail as int
	
	for i in ears.size():
		ears[i].visible = int(floor(float(i)/2.0)) == dna.ears as int
	
	if dna.eye_lashes:
		eyes = [load("res://models/doodle/BeanEyeGirlsNew.png"),load("res://models/doodle/BeanEyeGirlsBlinkNew.png")]
	else:
		eyes = [load("res://models/doodle/BeanEyeBoys2.png"),load("res://models/doodle/BeanEyeBoysBlink.png")]
	eye_mesh.set_surface_override_material(0,eye_mesh.mesh.surface_get_material(0).duplicate())
	eye_mesh.get_surface_override_material(0).albedo_texture = eyes[0]
	
	body.set_surface_override_material(0,body.mesh.surface_get_material(0).duplicate())
	body.get_surface_override_material(0).albedo_texture = dna.texture
	
	for mesh in colored_meshes:
		if not mesh.get_surface_override_material(0):
			mesh.set_surface_override_material(0,mesh.mesh.surface_get_material(0).duplicate())
		mesh.get_surface_override_material(0).albedo_color = dna.color
	
	hair.set_visible(dna.hair)

func blink():
	if eyes_open:
		close_eyes()
		blink_timer.wait_time = 0.25
	else:
		open_eyes()
		blink_timer.wait_time = RandomService.randf_range_channel('true_random', 5.0, 10.0)
	blink_timer.start()

func close_eyes() -> void:
	left_pupil.hide()
	right_pupil.hide()
	if eyes.size() > 1:
		eye_mesh.get_surface_override_material(0).albedo_texture = eyes[1]
	eyes_open = false

func open_eyes() -> void:
	if not eyes.is_empty():
		eye_mesh.get_surface_override_material(0).albedo_texture = eyes[0]
		left_pupil.show()
		right_pupil.show()
	eyes_open = true
