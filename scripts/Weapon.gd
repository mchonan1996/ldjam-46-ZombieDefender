extends Node2D
class_name Weapon

onready var weapon_node: Node2D = $ArmParent

var can_shoot := true

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())


func fire() -> void: # overridden in derivative classes
	pass

func spend_fire() -> void: # overridden in derivative classes
	pass
