extends RigidBody2D

signal destroyed_asteroid(score_value)

const SmallAsteroid = preload("res://Prefabs/Entities/SmallAsteroid.tscn")


var new_pos = Vector2()
var is_outside = false
var rng = RandomNumberGenerator.new()

export (int) var health = 100
export (int) var damage = 20
export (int) var new_asteroids = 5
export (int) var score_value = 50

onready var sprite = $'Sprite'
onready var hitTimer = $'HitTimer'
onready var hitDetector = $'HitDetection'

onready var gameManager = get_tree().get_root().get_node('Scene/GameManager')

onready var ParentNode = $'..'

func on_destroy():
	for _i in range(new_asteroids):
		var new_asteroid_instance = SmallAsteroid.instance()
		new_asteroid_instance.position = position + Vector2(rng.randf_range(-10,10),rng.randf_range(-10,10))
		ParentNode.call_deferred("add_child", new_asteroid_instance)
	emit_signal("destroyed_asteroid", score_value)
	queue_free()

func check_outside():
	if position.x > 325:
		is_outside = true
		new_pos.x = -5
		new_pos.y = position.y
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
	if position.x < -5:
		is_outside = true
		new_pos.x = 325
		new_pos.y = position.y
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
	if position.y > 185:
		is_outside = true
		new_pos.x = position.x
		new_pos.y = -5
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
	if position.y < -5:
		is_outside = true
		new_pos.x = position.x
		new_pos.y = 185
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
		
		
func get_damage():
	return damage

func _ready():
	sprite.modulate = Color(1, 1, 1)
	rng.randomize()
	linear_velocity = Vector2(rng.randf_range(-35,35),rng.randf_range(-35,35))
	angular_velocity = rng.randf_range(-5,5)
	
	self.connect('destroyed_asteroid', gameManager, '_on_Asteroid_destroyed')
	
	
func _integrate_forces(state):
	if is_outside:
		var t = state.get_transform()
		t.origin.x = new_pos.x
		t.origin.y = new_pos.y
		state.set_transform(t)
		is_outside = false

func _physics_process(_delta):
	check_outside()


func _on_Area2D_body_entered(body):
	# print('collision between: ' + str(hitDetector) + ' and ' + str(body))
	if not body.is_in_group("border") and body != hitDetector and body != self:
		if body.is_in_group("bullet"):
			health -= body.get_node('.').get_damage()
		else:
			health -= 8
		sprite.modulate = Color(1, 0, 0)
		hitTimer.start(0.1)
		if health <= 0:
			on_destroy()


func _on_HitTimer_timeout():
	sprite.modulate = Color(1, 1, 1)
	pass # Replace with function body.
