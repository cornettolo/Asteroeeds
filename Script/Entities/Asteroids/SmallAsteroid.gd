extends Asteroid

class_name SM_Asteroid
#	export (int) var health = 50
#	export (int) var damage = 10
#	export (int) var score_value = 15


func on_destroy():
	emit_signal("destroyed_asteroid", score_value)
	queue_free()
	
func _ready():
	particle.emitting = false
	sprite.modulate = Color(1, 1, 1)
	rng.randomize()
	linear_velocity = Vector2(rng.randf_range(-35,35),rng.randf_range(-35,35))
	angular_velocity = rng.randf_range(-5,5)
	
	self.connect('destroyed_asteroid', gameManager, '_on_Asteroid_destroyed')
