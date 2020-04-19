extends Node

const ZOMBIE_NOISE_COUNT = 7 # 7 groans! weow!
const ZOMBIE_NOISE_CHANCE = 50 # 100 = 100% chance

var buy_menu: Popup
var player: KinematicBody2D
var shade: CanvasModulate
var zombie_spawn: ColorRect

func _ready() -> void:
	randomize()
	buy_menu = $"/root".find_node("BuyMenu", true, false)
	player = $"/root".find_node("Player", true, false)
	shade = $"/root".find_node("Shade", true, false)
	zombie_spawn = $"/root".find_node("ZombieSpawn", true, false)

	get_tree().call_group("HUD", "update_money", Global.money)
	get_tree().call_group("HUD", "update_ammo", Global.shotgun_ammo, Global.rocket_ammo)

	Global.in_shop = true # first time
	update_main_view()


func increase_money(amount: int) -> void:
	if not $CoinPickup.playing:
		$CoinPickup.play()
	Global.money += amount
	get_tree().call_group("HUD", "update_money", Global.money)


func _on_ZombieNoiseTimer_timeout():
	var chance = 100 - (randf() * 100)
	if chance <= ZOMBIE_NOISE_CHANCE:
		play_random_zombie_groan()


func play_random_zombie_groan() -> void:
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
