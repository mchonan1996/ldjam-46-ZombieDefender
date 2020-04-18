extends CanvasLayer
class_name HUD

func _ready() -> void:
	pass


func update_money(money: int) -> void:
	$HBoxContainer/Money/MoneyLabel.text = "Money: $%d" % money


func update_ammo(ammo: int) -> void:
	$HBoxContainer/Ammo/AmmoLabel.text = "Ammo: %d" % ammo
