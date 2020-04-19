extends Area2D
class_name Bullet

const BULLET_SPEED = 2000

var velocity := Vector2.ZERO

export var damage_amount = 0

func _ready() -> void:
	var target_pos := get_global_mouse_position()
	velocity = -(global_position - target_pos).normalized()


func _physics_process(delta: float) -> void:
	position += velocity * BULLET_SPEED * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Bullet_body_entered(body: Node) -> void:
	var zombie := (body as Zombie)
	if not zombie:
		return

	zombie.damage(damage_amount)
	queue_free()
