extends Weapon
class_name RocketLauncher

const AMMO_PATH = "res://prefabs/Bullet.tscn"

onready var gun_animation = $ArmParent/AnimationPlayer
onready var gun_sprite = $ArmParent/Gun


func _process(_delta: float) -> void:
	pass


func fire() -> void:
	if not can_shoot:
		return

	create_rocket()

	# play animation
	if gun_animation.is_playing():
		gun_animation.stop()
	gun_animation.play("shoot")

	# boom
	$GunshotSound.play()

	# restrict shooting
	can_shoot = false
	$Timer.start()


func spend_fire() -> void:
	# restrict shooting (this function is a hack for when player has no ammo)
	can_shoot = false
	$Timer.start()


func _on_Timer_timeout():
	can_shoot = true


func create_rocket():
	var pellet: Pellet = load(AMMO_PATH).instance()
	add_child(pellet)
	pellet.position = gun_sprite.global_position
	pellet.set_as_toplevel(true)
	pellet.set_direction(direction)

