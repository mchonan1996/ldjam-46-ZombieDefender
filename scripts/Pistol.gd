extends Weapon
class_name Pistol

const BULLET_PATH = "res://prefabs/Bullet.tscn"

onready var gun_animation = $ArmParent/AnimationPlayer

func _process(delta: float) -> void:
	pass
	
func _fire() -> void:
	var bullet: Bullet = load(BULLET_PATH).instance()
	add_child(bullet)
	bullet.z_index = 0
	bullet.position = $ArmParent/Pistol.global_position
	bullet.set_as_toplevel(true)
	if gun_animation.is_playing():
		gun_animation.stop()
	gun_animation.play("shoot")
	$Gunshot.play()
