extends Asteroid

class_name SM_Asteroid
#	export (int) var health = 50
#	export (int) var damage = 10
#	export (int) var score_value = 15


func on_destroy():
	var score_pop = scorePop.instance()
	score_pop.set_text(str(score_value))
	score_pop.set_global_position(position)
	ParentNode.call_deferred("add_child", score_pop)
	
	emit_signal("destroyed_asteroid", score_value)
	queue_free()
	
