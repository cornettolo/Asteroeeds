extends RigidBody2D

export (float) var duration = 60
export (Vector2) var direction = Vector2()
export (Vector2) var velocity = Vector2()

func _process(delta):
	# velocity = move_and_slide(velocity)
	pass

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
