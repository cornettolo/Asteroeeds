extends RigidBody2D

export (float) var duration = 60
export (Vector2) var direction = Vector2()
export (Vector2) var velocity = Vector2()

onready var destroyTimer = $'DestroyTimer'

func _ready():
	destroyTimer.start(10)

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()

func _on_DestroyTimer_timeout():
	queue_free()


func _on_CollisionDetector_area_entered(area):
	if not area.is_in_group("player"):
		queue_free()
