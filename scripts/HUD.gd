extends CanvasLayer
class_name HUD

#onready var pistol_ammo_label = $HBoxContainer/PistolAmmo/PistolAmmoLabel
onready var shotgun_ammo_label = $HBoxContainer/ShotgunAmmo/ShotgunAmmoLabel
onready var rocket_ammo_label = $HBoxContainer/RocketAmmo/RocketAmmoLabel

onready var zombie_count_label = $HBoxContainer/KilledLabel/KilledLabel
onready var wave_label = $HBoxContainer/Wave/WaveLabel

var shotgun_ammo_text: String
var rocket_ammo_text: String

var zombie_count_text: String
var wave_text: String

func _ready() -> void:
	shotgun_ammo_text = shotgun_ammo_label.text
	rocket_ammo_text = rocket_ammo_label.text
	zombie_count_text = zombie_count_label.text
	wave_text = wave_label.text
	pass


func update_money() -> void:
	$HBoxContainer/Money/MoneyLabel.text = "Money: $%d" % Global.money


func update_ammo() -> void:
	$HBoxContainer/PistolAmmo.visible = Global.has_pistol
	$HBoxContainer/ShotgunAmmo.visible = Global.has_shotgun
	$HBoxContainer/RocketAmmo.visible = Global.has_rocket

	shotgun_ammo_label.text = shotgun_ammo_text % Global.shotgun_ammo
	rocket_ammo_label.text = rocket_ammo_text % Global.rocket_ammo


func update_zombie_count() -> void:
	zombie_count_label.text = zombie_count_text % Global.current_wave_zombie_killed


func update_wave() -> void:
	wave_label.text = wave_text % Global.current_wave
