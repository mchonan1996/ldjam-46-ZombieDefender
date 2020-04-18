extends Camera2D

export var shake_power = 3
export var shake_time = 0.05

var shaking = false
var start_position: Vector2
var elapsedtime = 0


func _ready() -> void:
	randomize()
	start_position = offset


func _process(delta) -> void:
	if shaking:
		do_shake(delta)


func start_shake() -> void:
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
