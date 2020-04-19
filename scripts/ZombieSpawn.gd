extends ColorRect
class_name ZombieSpawn

export var level: int
export var spawn_timer: float = 1
export var spawn_chance: float = 50 # 1 = 100%

const ZOMBIE_PATH = "res://prefabs/ZombieBase.tscn"

var zombie_container: Node

func _ready() -> void:
	zombie_container = $"/root".find_node("Zombies", true, false)
	
	if not level:
		level = 1
	start_game()
		

func start_game() -> void:
	print("Starting game on Level %d" % level)
	$SpawnTimer.wait_time = spawn_timer
	$SpawnTimer.start()


func _on_SpawnTimer_timeout() -> void:
	randomize()
	var roll = randf()
	var chance = 100 - (roll * 100)
	print("Roll %f" % roll)
	print("Chance %f" % chance)
	if chance <= spawn_chance:
		spawn_zombie()
	else:
		print("NOT SPAWNING")

func spawn_zombie() -> void:
	randomize()
	print("Spawning Zombie")
	
	var spawner_pos = get_position()
	
	var zombie: Zombie = load(ZOMBIE_PATH).instance()
	zombie_container.add_child(zombie)
	zombie.global_position = Vector2(
		spawner_pos.x,
		rand_range(spawner_pos.y, spawner_pos.y + get_size().y)
	)
