extends KinematicBody2D
class_name Player

const MOVEMENT_SPEED := 300
const FRICTION := 0.12

var velocity := Vector2.ZERO

func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var diff_vector = (mouse_pos - global_position).normalized()
	$AnimatedSprite.flip_h = diff_vector.x < 0


func _physics_process(delta: float) -> void:
	var movement_dir := get_movement_direction()
	
	if movement_dir != Vector2.ZERO:
		if movement_dir.x > 0:
			$AnimatedSprite.play("walk")
			print("forwards")
		else:
			$AnimatedSprite.play("walk", true) # play in reverse
			print("backwards")
	else:
		$AnimatedSprite.play("idle")
	
	velocity = velocity.linear_interpolate(movement_dir * MOVEMENT_SPEED, FRICTION)
	move_and_slide(velocity, Vector2.UP)
	

func get_movement_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
