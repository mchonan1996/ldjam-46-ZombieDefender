extends Control


func _on_PlayButton_pressed() -> void:
	$BGM.stop()
	yield(get_tree(), "idle_frame")
	get_tree().change_scene("res://levels/TemplateLevel.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit(0)


func _on_BackToMenu_pressed():
	get_tree().change_scene("res://levels/MainMenu.tscn")
