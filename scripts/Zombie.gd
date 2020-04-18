extends KinematicBody2D
class_name Zombie

export var starting_health: int = 100
export var min_movement_speed: int = 40
export var max_movement_speed: int = 80

const PAIN_SOUND_AMOUNT: int = 4 # amount of pain sounds for basic zombies
const DEATH_SOUND_AMOUNT: int = 3 # amount of death sounds for basic zombies

var movement_speed: float
var health: int
var is_dead: bool = false

func _ready() -> void:
	randomize()
	movement_speed = randi() % (max_movement_speed - min_movement_speed) + min_movement_speed
	health = starting_health
	
	
func _physics_process(delta: float) -> void:
	if not is_dead:
		var direction = Vector2.LEFT
		move_and_slide(direction * movement_speed, Vector2.UP)
	else:
		$AnimatedSprite.play("die")
	
	
func damage(amount: int) -> void:
	if is_dead:
		return
	health -= amount
	if health <= 0:
		die()
	else:		
		$Sound.stream = load(get_random_hurt_sound())
		$Sound.play()
	
		
func die() -> void:
	is_dead = true
	$Sound.stream = load(get_random_death_sound())
	$Sound.play()
	

func get_random_hurt_sound() -> String:
	randomize()
	var i = randi() % PAIN_SOUND_AMOUNT + 1
	return "res://sounds/zombie_basic_hurt%d.ogg" % i
	

func get_random_death_sound() -> String:
	randomize()
	var i = randi() % DEATH_SOUND_AMOUNT + 1
	return "res://sounds/zombie_basic_die%d.ogg" % i
