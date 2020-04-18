extends CanvasLayer
class_name HUD

func _ready() -> void:
	update_money_label()
	pass
	
func update_hud() -> void:
	update_money_label()
	

func update_money_label() -> void:
	$Money/Label.text = "Money: $%d" % Global.money
