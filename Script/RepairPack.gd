extends Entity

var heal_amount = 20

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	linear_velocity = Vector2(rng.randf_range(-35,35),rng.randf_range(-35,35))
	angular_velocity = rng.randf_range(-5,5)
	
	
func _on_Area2D_body_entered(body):
	._on_Area2D_body_entered(body)
	print(body)


func get_healing():
	queue_free()
	return heal_amount
