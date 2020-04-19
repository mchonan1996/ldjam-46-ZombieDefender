extends Node

func _ready() -> void:
	get_tree().call_group("HUD", "update_money", Global.money)
	

func increase_money(amount: int) -> void:
	if not $CoinPickup.playing:
		$CoinPickup.play()
	Global.money += amount
	get_tree().call_group("HUD", "update_money", Global.money)
