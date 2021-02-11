extends Asteroid

class_name SM_Asteroid
#	export (int) var health = 50
#	export (int) var damage = 10
#	export (int) var score_value = 15


func on_destroy():
	emit_signal("destroyed_asteroid", score_value)
	queue_free()
	
