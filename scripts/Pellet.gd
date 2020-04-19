extends Bullet
class_name Pellet


func set_direction(new_direction: Vector2) -> void:
	velocity = -(global_position - new_direction).normalized()
