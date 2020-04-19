extends Node2D


func _on_Area2D_body_entered(_body):
	Global.money += 30
	$AnimationPlayer.play("collect")
	#todo play sound???


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
