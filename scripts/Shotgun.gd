extends Weapon
class_name Shotgun

const AMMO_PATH = "res://prefabs/Pellet.tscn"

onready var gun_animation = $ArmParent/AnimationPlayer
onready var gun_sprite = $ArmParent/Gun


func _process(_delta: float) -> void:
	pass


func fire() -> void:
	if not can_shoot:
		return
	print("Firing Shotgun")

	create_shell_shot()

	# play animation
	if gun_animation.is_playing():
		gun_animation.stop()
	gun_animation.play("shoot")

	# boom
	$GunshotSound.play()

	# restrict shooting
	can_shoot = false
	$Timer.start()


func _on_Timer_timeout():
	can_shoot = true


func _on_AnimationPlayer_animation_finished(_anim_name):
	# shot anim is finished, play the reload anim
	$ReloadSound.play()
	gun_sprite.frame = 0
	gun_sprite.play()


func create_shell_shot():
	# create 8 pellets
	var target_pos := get_global_mouse_position()
	create_pellet(target_pos)
	create_pellet(target_pos.rotated(deg2rad(1)))
	create_pellet(target_pos.rotated(deg2rad(2)))
	create_pellet(target_pos.rotated(deg2rad(4)))
	create_pellet(target_pos.rotated(deg2rad(5)))
	create_pellet(target_pos.rotated(deg2rad(-1)))
	create_pellet(target_pos.rotated(deg2rad(-2)))
	create_pellet(target_pos.rotated(deg2rad(-4)))
	create_pellet(target_pos.rotated(deg2rad(-5)))


func create_pellet(direction: Vector2):
	var pellet: Pellet = load(AMMO_PATH).instance()
	add_child(pellet)
	pellet.z_index = 0
	pellet.position = gun_sprite.global_position
	pellet.set_as_toplevel(true)
	pellet.set_direction(direction)
