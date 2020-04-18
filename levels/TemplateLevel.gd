extends Node2D


func _ready():
	get_tree().call_group("HUD", "update_money", Global.money)
