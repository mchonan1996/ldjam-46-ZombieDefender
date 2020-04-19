extends KinematicBody2D
class_name Player

enum WeaponType {
	pistol,
	shotgun,
	rockets
}

const MOVEMENT_SPEED := 300
const FRICTION := 0.12

var active_weapon
var velocity := Vector2.ZERO

func _ready() -> void:
	# Set best weapon for the job
	if Global.has_shotgun:
		active_weapon = WeaponType.shotgun
	else:
		active_weapon = WeaponType.pistol
	toggle_weapon_visibility(active_weapon)


func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var diff_vector = (mouse_pos - global_position).normalized()
	$AnimatedSprite.flip_h = diff_vector.x < 0

	if Input.is_action_pressed("attack"):
		fire_weapon()


func _physics_process(_delta: float) -> void:
	var movement_dir := get_movement_direction()
	if movement_dir != Vector2.ZERO:
		if movement_dir.x > 0:
			$AnimatedSprite.play("walk")
		else:
			$AnimatedSprite.play("walk", true) # play in reverse
	else:
		$AnimatedSprite.play("idle")

	velocity = velocity.linear_interpolate(movement_dir * MOVEMENT_SPEED, FRICTION)
	move_and_slide(velocity, Vector2.UP)


func _input(_event) -> void:
	var weap1_pressed = Input.is_action_just_pressed("switch_weap1")
	var weap2_pressed = Input.is_action_just_pressed("switch_weap2")
	var weap3_pressed = Input.is_action_just_pressed("switch_weap3")

	if weap1_pressed or weap2_pressed or weap3_pressed:
		var old_weapon = active_weapon
		if weap1_pressed:
			active_weapon = WeaponType.pistol
		elif weap2_pressed:
			active_weapon = WeaponType.shotgun
		elif weap3_pressed:
			active_weapon = WeaponType.rockets

		toggle_weapon_visibility(old_weapon) # toggle OUT the current one
		toggle_weapon_visibility(active_weapon) # toggle IN the new one one


func get_movement_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func fire_weapon() -> void:
#	print("Active wep: %d" % )
	var weapon = ($MountPoint.get_child(active_weapon) as Weapon)
	if not weapon or not weapon.can_shoot:
		return

	weapon.fire()
	reduce_ammo(weapon)
	get_tree().call_group("CAMERA", "start_shake")


func reduce_ammo(weapon: Weapon) -> void:

	# reduce for appropriate gun

	#get_tree().call_group("HUD", "update_ammo", weapon.ammo_count)
	pass


func toggle_weapon_visibility(weapon) -> void:
	if weapon == WeaponType.pistol:
		$MountPoint/Pistol.visible = ! $MountPoint/Pistol.visible
	elif weapon == WeaponType.shotgun:
		$MountPoint/Shotgun.visible = ! $MountPoint/Shotgun.visible
	elif weapon == WeaponType.rockets:
		pass
