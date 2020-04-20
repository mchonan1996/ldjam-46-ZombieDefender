extends PopupPanel
class_name BuyMenu

const PISTOL_PRICE: int = 49
const SHOTGUN_PRICE: int = 399
const ROCKETS_PRICE: int = 2499
const AMMO_PRICE: int = 50

const COLOR_SOLD = Color("00ab23")
const SOUND_COIN_PATH = "res://sounds/coin_pickup.ogg"

onready var fight_button = $VBoxContainer/CenterContainer/FightButton

onready var pistol_buy_button = $VBoxContainer/HBoxContainer/PistolPanel/VBoxContainer/BuyPistol
onready var shotgun_buy_button = $VBoxContainer/HBoxContainer/ShotgunPanel/VBoxContainer/BuyShotgun
onready var rockets_buy_button = $VBoxContainer/HBoxContainer/RocketPanel/VBoxContainer/BuyRockets

var no_money_alert_active: bool = false

signal buying_finished

func _ready():
	begin_shopping()


func begin_shopping() -> void:
	if Global.current_wave == 0: # before first wave
		fight_button.disabled = true # until player buys pistol
		$JimSounds.stream = load("res://sounds/Jim-Intro.ogg")
		$JimSounds.play()
	else:
		$JimSounds.stream = load("res://sounds/Jim-WelcomeBack1.ogg")
		$JimSounds.play()


func _on_BuyPistol_pressed():
	if Global.money < PISTOL_PRICE:
		no_cash()
		return

	Global.money -= PISTOL_PRICE
	Global.has_pistol = true
	fight_button.disabled = false
	set_button_sold(pistol_buy_button)

	$SFX.stream = load(SOUND_COIN_PATH)
	$SFX.play()
	$JimSounds.stream = load("res://sounds/Jim-Pistol.ogg")
	$JimSounds.play()
	get_tree().call_group("HUD", "update_money")
	get_tree().call_group("HUD", "update_ammo")


func _on_BuyShotgun_pressed():
	var price = SHOTGUN_PRICE
	if Global.has_shotgun:
		price = AMMO_PRICE

	if Global.money < price:
		no_cash()
		return

	Global.money -= price

	set_button_sold(shotgun_buy_button)

	$SFX.stream = load(SOUND_COIN_PATH)
	$SFX.play()

	if not Global.has_shotgun:
		Global.has_shotgun = true
		$JimSounds.stream = load("res://sounds/Jim-Shotgun.ogg")
		$JimSounds.play()
	else:
		Global.shotgun_ammo += 15

	get_tree().call_group("HUD", "update_money")
	get_tree().call_group("HUD", "update_ammo")


func _on_BuyRockets_pressed():
	var price = ROCKETS_PRICE
	if Global.has_rocket:
		price = AMMO_PRICE
		
	if Global.money < price:
		no_cash()
		return

	Global.money -= price

	set_button_sold(rockets_buy_button)

	$SFX.stream = load(SOUND_COIN_PATH)
	$SFX.play()

	if not Global.has_rocket:
		Global.has_rocket = true
		$JimSounds.stream = load("res://sounds/Jim-RocketLauncher.ogg")
		$JimSounds.play()
	else:
		Global.rocket_ammo += 5

	get_tree().call_group("HUD", "update_money")
	get_tree().call_group("HUD", "update_ammo")


func set_button_sold(button: Button) -> void:
	if button == $VBoxContainer/HBoxContainer/PistolPanel/VBoxContainer/BuyPistol:
		button.text = "SOLD"
		button.disabled = true
	else:
		button.text = "Buy Ammo - $%d" % AMMO_PRICE


func no_cash() -> void:
	if no_money_alert_active:
		return
	no_money_alert_active = true
	$NoMoneyTimer.start()
	$JimSounds.stream = load("res://sounds/Jim-NoMoney.ogg")
	$JimSounds.play()


func _on_NoMoneyTimer_timeout():
	no_money_alert_active = false


func _on_FightButton_pressed():
	hide()
	emit_signal("buying_finished")
