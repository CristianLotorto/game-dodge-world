extends Area2D

func _on_bulletAnimation_animation_finished(anim_name):
	queue_free()
	
func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		queue_free()
