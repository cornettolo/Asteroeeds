extends RigidBody2D

signal destroyed_asteroid(score_value)

var new_pos = Vector2()
var is_outside = false
var rng = RandomNumberGenerator.new()

export (int) var health = 50
export (int) var damage = 10
export (int) var score_value = 15

onready var sprite = $'Sprite'
onready var hitTimer = $'HitTimer'
onready var hitDetector = $'HitDetection'
onready var particle = $'Particles2D'

onready var ParentNode = $'..'

onready var gameManager = get_tree().get_root().get_node('Scene/GameManager')

onready var max_health = health

func get_damage():
	return damage
	
	
func on_destroy():
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

func _ready():
	particle.emitting = false
	sprite.modulate = Color(1, 1, 1)
	rng.randomize()
	linear_velocity = Vector2(rng.randf_range(-20,20),rng.randf_range(-20,20))
	angular_velocity = rng.randf_range(-3,3)
	
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
		if int((max_health - health)/25):
			particle.emitting = true
			particle.amount = int((max_health - health)/25)
		if health <= 0:
			on_destroy()


func _on_HitTimer_timeout():
	sprite.modulate = Color(1, 1, 1)
	pass # Replace with function body.
