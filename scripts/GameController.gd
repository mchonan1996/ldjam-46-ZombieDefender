extends Node

const ZOMBIE_NOISE_COUNT = 7 # 7 groans! weow!
const ZOMBIE_NOISE_CHANCE = 50 # 100 = 100% chance

const BGM_FIGHT = "res://music/battle.ogg"
const BGM_BUY = "res://music/lobby.ogg"

var buy_menu: BuyMenu
var player: KinematicBody2D
var shade: CanvasModulate
var zombie_spawn: ZombieSpawn

signal wave_started

func _ready() -> void:
	randomize()
	buy_menu = $"/root".find_node("BuyMenu", true, false)
	player = $"/root".find_node("Player", true, false)
	shade = $"/root".find_node("Shade", true, false)
	zombie_spawn = $"/root".find_node("ZombieSpawn", true, false)

	get_tree().call_group("HUD", "update_money")
	get_tree().call_group("HUD", "update_ammo")
	get_tree().call_group("HUD", "update_wave")
	get_tree().call_group("HUD", "update_zombie_count")

	go_to_shop() # First time


func increase_money(amount: int) -> void:
	if not $CoinPickup.playing:
		$CoinPickup.play()
	Global.money += amount
	get_tree().call_group("HUD", "update_money")


func _on_ZombieNoiseTimer_timeout():
	if Global.in_shop:
		return

	var chance = 100 - (randf() * 100)
	if chance <= ZOMBIE_NOISE_CHANCE:
		play_random_zombie_groan()


func play_random_zombie_groan() -> void:
	randomize()
	var i = randi() % ZOMBIE_NOISE_COUNT + 1
	$ZombieNoise.stream = load("res://sounds/zombie_groan%d.ogg" % i)
	$ZombieNoise.play()


func update_main_view() -> void:
	if not Global.in_shop:
		# show game
		player.visible = true
		buy_menu.hide()
		shade.visible = false
	else:
		# hide game, show shop
		player.visible = false
		buy_menu.popup()
		shade.visible = true
		yield(get_tree(), "idle_frame")
		buy_menu.begin_shopping()

	set_bgm()


func set_bgm() -> void:
	if not Global.in_shop:
		$BGM.stop()
		$BGM.stream = load(BGM_FIGHT)
		$BGM.play()
	else:
		$BGM.stop()
		$BGM.stream = load(BGM_BUY)
		$BGM.play()


func _on_BuyMenu_buying_finished():
	print("GameController: Wave Finished!")
	go_to_battle()


func go_to_battle() -> void:
	Global.in_shop = false
	Global.current_wave += 1
	Global.current_wave_zombie_cnt = 15 * Global.current_wave
	Global.current_wave_zombie_killed = 0
	print("START WAVE %d (%d zombies)" % [Global.current_wave, Global.current_wave_zombie_cnt])
	update_main_view()
	get_tree().call_group("HUD", "update_wave")
	get_tree().call_group("HUD", "update_zombie_count")
	emit_signal("wave_started")


func go_to_shop():
	Global.in_shop = true
	update_main_view()


func go_to_game_over():
	print("Game Over!")
	pass


func _on_ZombieSpawn_wave_finished():
	go_to_shop()


func _on_GameOverZone_body_entered(body):
	go_to_game_over()
