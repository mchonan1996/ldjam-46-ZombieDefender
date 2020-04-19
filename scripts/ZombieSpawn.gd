extends ColorRect
class_name ZombieSpawn

export var spawn_timer: float = 1
export var spawn_chance: float = 50 # 100 = 100%

const ZOMBIE_PATH = "res://prefabs/ZombieBase.tscn"

var zombie_container: Node
var game_controller: Node

var zombies_spawned: int = 0

signal wave_finished

func _ready() -> void:
	zombie_container = $"/root".find_node("Zombies", true, false)
	game_controller = $"/root".find_node("GameController", true, false)


func start_spawning() -> void:
	randomize()
	print("Starting spawning")
	zombies_spawned = 0
	$SpawnTimer.wait_time = spawn_timer
	$SpawnTimer.start()
	bulk_spawn_start()


func stop_spawning() -> void:
	print("Stopping spawning")
	$SpawnTimer.stop()


func _on_SpawnTimer_timeout() -> void:
	if zombies_spawned >= Global.current_wave_zombie_cnt:
		stop_spawning()
		return

	var chance = 100 - (randf() * 100)
	if chance <= spawn_chance:
		bulk_spawn_start()


func _on_Zombie_Die() -> void:
	Global.current_wave_zombie_killed += 1
	get_tree().call_group("HUD", "update_zombie_count")
	if Global.current_wave_zombie_killed == Global.current_wave_zombie_cnt:
		print("ZombieSpawner: Wave Finished!")
		$WaveFinishedTimer.start()


func spawn_zombie() -> void:
	zombies_spawned += 1
	var spawner_pos = get_position()
	var zombie: Zombie = load(ZOMBIE_PATH).instance()
	zombie_container.add_child(zombie)

	var spawner_height = get_size().y
	var spawner_margin = spawner_height * 0.166 # 1/6th (ish) of the height

	zombie.global_position = Vector2(
		spawner_pos.x,
		rand_range(spawner_pos.y + spawner_margin, spawner_pos.y + spawner_height - spawner_margin)
	)
	zombie.connect("died", self, "_on_Zombie_Die")


func bulk_spawn_start() -> void:
	var initial_zombie_count = floor(1.5 * Global.current_wave)
	for _i in range(initial_zombie_count):
		if zombies_spawned < Global.current_wave_zombie_cnt:
			spawn_zombie()


func _on_WaveFinishedTimer_timeout():
	emit_signal("wave_finished")


func _on_GameController_wave_started():
	start_spawning()
