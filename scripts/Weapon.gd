extends Node2D
class_name Weapon

onready var weapon_node: Node2D = $ArmParent

func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var diff_vector = (mouse_pos - global_position).normalized()
	
	look_at(mouse_pos)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		_fire()
	
func _fire() -> void: # overridden in derivative classes
	pass
