extends Bullet
class_name Pellet

func _ready() -> void:
	weapon_source = WeaponType.SHOTGUN

func set_direction(new_direction: Vector2) -> void:
	velocity = -(global_position - new_direction).normalized()
