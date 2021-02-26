extends Entity

class_name Asteroid

signal destroyed_asteroid(score_value)

onready var scorePop = preload("res://Prefabs/OtherEffects/LabelPop.tscn")

export (int) var new_asteroids = 5
export (int) var score_value = 50

var SmallAsteroid = null 
var rng = RandomNumberGenerator.new()
var destroyed = false

onready var sprite = $'Sprite'
onready var hitTimer = $'HitTimer'
onready var particle = $'Particles2D'

onready var collisionShape = $'MainCollisionShape2D'
onready var secondCollisionShape = $'SmallCollisionShape2D'
onready var explosionEffect = $'ExplosionEffect'

onready var gameManager = get_tree().get_root().get_node('Scene/GameManager')
onready var ParentNode = $'..'

func on_destroy():
	destroyed = true
	sprite.visible = false
	hitDetector.queue_free()
	collisionShape.queue_free()
	secondCollisionShape.queue_free()
	explosionEffect.play(0.8)
	
	
	var score_pop = scorePop.instance()
	score_pop.set_text(str(score_value))
	score_pop.set_global_position(position)
	ParentNode.call_deferred("add_child", score_pop)
	
	for _i in range(new_asteroids):
		var new_asteroid_instance = SmallAsteroid.instance()
		new_asteroid_instance.position = position + Vector2(rng.randf_range(-10,10),rng.randf_range(-10,10))
		ParentNode.call_deferred("add_child", new_asteroid_instance)
	emit_signal("destroyed_asteroid", score_value)




func _ready():
	# particle.emitting = false
	sprite.modulate = Color(1, 1, 1)
	rng.randomize()
	linear_velocity = Vector2(rng.randf_range(-35,35),rng.randf_range(-35,35))
	angular_velocity = rng.randf_range(-5,5)
	SmallAsteroid = load("res://Prefabs/Entities/Asteroids/SmallAsteroid.tscn")
	
	self.connect('destroyed_asteroid', gameManager, '_on_Asteroid_destroyed')


func _on_Area2D_body_entered(body):
	sprite.modulate = Color(1, 0, 0)
	hitTimer.start(0.1)
#	if int((max_health - health)/25):
#		particle.emitting = true
#		particle.amount = int((max_health - health)/25)
	._on_Area2D_body_entered(body)
	
	# print('collision between: ' + str(hitDetector) + ' and ' + str(body))
#	if not body.is_in_group("border") and body != hitDetector and body != self:
#		if body.is_in_group("bullet"):
#			health -= body.get_node('.').get_damage()
#		sprite.modulate = Color(1, 0, 0)
#		hitTimer.start(0.1)
#		if int((max_health - health)/25):
#			particle.emitting = true
#			particle.amount = int((max_health - health)/25)
#		if health <= 0:
#			on_destroy()


func _on_HitTimer_timeout():
	sprite.modulate = Color(1, 1, 1)


func _on_ExplosionDurationTimer_timeout():
	queue_free()
