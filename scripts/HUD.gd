extends CanvasLayer
class_name HUD

#onready var pistol_ammo_label = $HBoxContainer/PistolAmmo/PistolAmmoLabel
onready var shotgun_ammo_label = $HBoxContainer/ShotgunAmmo/ShotgunAmmoLabel
onready var rocket_ammo_label = $HBoxContainer/RocketAmmo/RocketAmmoLabel

func _ready() -> void:
	#base_ammo_text = $HBoxContainer/Ammo/AmmoLabel.text
	pass


func update_money(money: int) -> void:
	$HBoxContainer/Money/MoneyLabel.text = "Money: $%d" % money


func update_ammo(shotgun_ammo: int, rocket_ammo: int) -> void:
	#shotgun_ammo_label.text = 
	pass
