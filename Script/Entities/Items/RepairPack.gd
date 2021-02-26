extends Entity

var heal_amount = 20

var rng = RandomNumberGenerator.new()
var destroyed = false

onready var sprite = $"Sprite"
onready var collisionShape = $"CollisionShape2D"
onready var explosionEffect = $"ExplosionEffect"

func _ready():
	rng.randomize()
	linear_velocity = Vector2(rng.randf_range(-35,35),rng.randf_range(-35,35))
	angular_velocity = rng.randf_range(-5,5)
	
	
func _on_Area2D_body_entered(body):
	._on_Area2D_body_entered(body)
	print(body)


func get_healing():
	on_destroy()
	return heal_amount


func on_destroy():
	destroyed = true
	sprite.visible = false
	hitDetector.queue_free()
	collisionShape.queue_free()
	explosionEffect.play(1)

func _on_DurationTimer_timeout():
	queue_free()
