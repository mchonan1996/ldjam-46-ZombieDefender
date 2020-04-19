extends Camera2D

const SHAKE_PISTOL = 2.5
const SHAKE_SHOTGUN = 4
const SHAKE_ROCKETS = 5

export var shake_time = 0.05

var shake_power = SHAKE_PISTOL

var shaking = false
var start_position: Vector2
var elapsedtime = 0


func _ready() -> void:
	randomize()
	start_position = offset


func _process(delta) -> void:
	if shaking:
		do_shake(delta)


func start_shake(active_weapon) -> void:
	if active_weapon == WeaponType.PISTOL:
		shake_power = SHAKE_PISTOL
	elif active_weapon == WeaponType.SHOTGUN:
		shake_power = SHAKE_SHOTGUN
	elif active_weapon == WeaponType.ROCKETS:
		shake_power = SHAKE_ROCKETS

	elapsedtime = 0
	shaking = true


func do_shake(delta):
	if elapsedtime < shake_time:
		offset =  start_position + (Vector2(randf(), randf()) * shake_power)
		elapsedtime += delta
	else:
		shaking = false
		elapsedtime = 0
		offset = start_position
