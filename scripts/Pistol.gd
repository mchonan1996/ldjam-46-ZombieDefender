extends Weapon
class_name Pistol

const AMMO_PATH = "res://prefabs/Bullet.tscn"

onready var gun_animation = $ArmParent/AnimationPlayer
onready var gun_sprite = $ArmParent/Gun


func _process(_delta: float) -> void:
	pass


func fire() -> void:
	if not can_shoot:
		return

	# instance bullet
	var bullet: Bullet = load(AMMO_PATH).instance()
	add_child(bullet)
	bullet.position = gun_sprite.global_position
	bullet.set_as_toplevel(true)

	# play animation
	if gun_animation.is_playing():
		gun_animation.stop()
	gun_animation.play("shoot")

	# boom
	$GunshotSound.play()

	# restrict shooting
	can_shoot = false
	$Timer.start()


func spend_fire() -> void: # overridden in derivative classes
	# restrict shooting (this function is a hack for when player has no ammo)
	can_shoot = false
	$Timer.start()


func _on_Timer_timeout():
	can_shoot = true
