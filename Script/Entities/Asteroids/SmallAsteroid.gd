extends Asteroid

class_name SM_Asteroid

func on_destroy():
	destroyed = true
	sprite.visible = false
	hitDetector.queue_free()
	collisionShape.queue_free()
	secondCollisionShape.queue_free()
	explosionEffect.play(0.6)
	
	var score_pop = scorePop.instance()
	score_pop.set_text(str(score_value))
	score_pop.set_global_position(position)
	ParentNode.call_deferred("add_child", score_pop)
	
	emit_signal("destroyed_asteroid", score_value)

	


func _on_DurationTimer_timeout():
	queue_free()
