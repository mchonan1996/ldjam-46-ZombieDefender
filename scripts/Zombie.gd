extends KinematicBody2D
class_name Zombie

export var starting_health: int = 100
export var min_movement_speed: int = 40
export var max_movement_speed: int = 80
export var money_value: int = 25

const PAIN_SOUND_AMOUNT: int = 4 # amount of pain sounds for basic zombies
const DEATH_SOUND_AMOUNT: int = 3 # amount of death sounds for basic zombies
const IMPACT_SOUND_AMOUNT: int = 2 # amount of impact hit sounds for basic zombies

const KNOCKBACK_SMALL = 10
const KNOCKBACK_MEDIUM = 30
const KNOCKBACK_LARGE = 60

var movement_speed: float
var health: int
var is_dead: bool = false

var can_knockback: bool = true
var next_knockback: int  = 0

var direction
var player

func _ready() -> void:
	randomize()
	player = $"/root".find_node("Player", true, false)
	movement_speed = randi() % (max_movement_speed - min_movement_speed) + min_movement_speed
	health = starting_health


func _physics_process(_delta: float) -> void:
	if Global.in_shop:
		return # just in case

	if not is_dead:
		direction = Vector2.LEFT

		if next_knockback > 0 and can_knockback:
			var player_pos = player.global_position
			var diff = global_position - player_pos
			direction += diff.normalized() * next_knockback
			next_knockback = 0
			can_knockback = false
			$KnockbackTimer.start()

		move_and_slide(direction * movement_speed, Vector2.UP)
	else:
		$AnimatedSprite.play("die")


func damage(amount: int, active_weapon: int) -> void:
	if is_dead:
		return
	health -= amount

	if can_knockback:
		if active_weapon == WeaponType.PISTOL:
			next_knockback = KNOCKBACK_SMALL
		elif active_weapon == WeaponType.SHOTGUN:
			next_knockback = KNOCKBACK_MEDIUM
		elif active_weapon == WeaponType.ROCKETS:
			next_knockback = KNOCKBACK_LARGE

	# play impact sound
	if not $ImpactSound.playing:
		$ImpactSound.stream = load(get_random_impact_sound())
		$ImpactSound.play()

	if health <= 0:
		die()
	else:
		$Sound.stream = load(get_random_hurt_sound())
		$Sound.play()


func die() -> void:
	is_dead = true
	$Sound.stream = load(get_random_death_sound())
	$Sound.play()

	# increase coins
	get_tree().call_group("GAME", "increase_money", money_value)

	yield(get_tree(), "idle_frame")
	$CollisionShape2D.disabled = true

	$DeadDisappearTimer.start()


func get_random_hurt_sound() -> String:
	var i = randi() % PAIN_SOUND_AMOUNT + 1
	return "res://sounds/zombie_basic_hurt%d.ogg" % i


func get_random_death_sound() -> String:
	var i = randi() % DEATH_SOUND_AMOUNT + 1
	return "res://sounds/zombie_basic_die%d.ogg" % i


func get_random_impact_sound() -> String:
	var i = randi() % IMPACT_SOUND_AMOUNT + 1
	return "res://sounds/zombie_hit%d.ogg" % i


func _on_KnockbackTimer_timeout() -> void:
	can_knockback = true


func _on_DeadDisappear_animation_finished(_anim_name: String) -> void:
	queue_free()


func _on_DeadDisappearTimer_timeout() -> void:
	$AnimatedSprite/DeadDisappear.play("dead_disappear")
