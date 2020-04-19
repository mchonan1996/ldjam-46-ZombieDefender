extends KinematicBody2D
class_name Player

const MOVEMENT_SPEED := 300
const FRICTION := 0.12

var active_weapon
var velocity := Vector2.ZERO

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if Global.in_shop:
		return

	var mouse_pos = get_global_mouse_position()
	var diff_vector = (mouse_pos - global_position).normalized()
	$AnimatedSprite.flip_h = diff_vector.x < 0

	if Input.is_action_pressed("attack"):
		var weapon = ($MountPoint.get_child(active_weapon) as Weapon)
		if not weapon or not weapon.can_shoot:
			return
		fire_weapon(weapon)


func _physics_process(_delta: float) -> void:
	if Global.in_shop:
		return

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
		if weap1_pressed:
			active_weapon = WeaponType.PISTOL
		elif weap2_pressed and Global.has_shotgun:
			active_weapon = WeaponType.SHOTGUN
		elif weap3_pressed and Global.has_rocket:
			active_weapon = WeaponType.ROCKETS

		$MountPoint/Pistol.visible = active_weapon == WeaponType.PISTOL
		$MountPoint/Shotgun.visible = active_weapon == WeaponType.SHOTGUN
#		$MountPoint/RocketLauncher.visible = active_weapon == WeaponType.ROCKETS TODO



func get_movement_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()


func fire_weapon(weapon: Weapon) -> void:
	# check ammo - probably make a noise if no ammo
#	if weapon == WeaponType.PISTOL and Global.pistol_ammo <= 0:
#		return
	if active_weapon == WeaponType.SHOTGUN and Global.shotgun_ammo <= 0:
		$GunClickSound.play()
		weapon.spend_fire() # fake gunshot to waste a "can_shoot" interval
		return
	elif active_weapon == WeaponType.ROCKETS and Global.rocket_ammo <= 0:
		$GunClickSound.play()
		weapon.spend_fire() # fake gunshot to waste a "can_shoot" interval
		return

	weapon.fire()
	reduce_ammo()
	get_tree().call_group("CAMERA", "start_shake", active_weapon)



func reduce_ammo() -> void:
	if active_weapon == WeaponType.SHOTGUN:
		Global.shotgun_ammo -= 1
	elif active_weapon == WeaponType.ROCKETS:
		Global.rocket_ammo -= 1
	get_tree().call_group("HUD", "update_ammo")


func toggle_weapon_visibility(weapon) -> void:
	if weapon == WeaponType.PISTOL:
		$MountPoint/Pistol.visible = ! $MountPoint/Pistol.visible
	elif weapon == WeaponType.SHOTGUN:
		$MountPoint/Shotgun.visible = ! $MountPoint/Shotgun.visible
	elif weapon == WeaponType.ROCKETS:
		pass


func _on_GameController_wave_started():
	# Set best weapon for the job
	if Global.has_shotgun:
		active_weapon = WeaponType.SHOTGUN
	else:
		active_weapon = WeaponType.PISTOL
	toggle_weapon_visibility(active_weapon)
