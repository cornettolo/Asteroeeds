extends KinematicBody2D

export (float) var max_speed = 40
export (float) var min_speed = -1
export (float) var max_acceleration = 1.05
export (float) var max_drag = 120
export (float) var drag = 3
export (float) var rotation_speed = 2.4
export (int) var health = 100

signal change_health(value)
signal moved

class_name Player, "res://Sprites/Entities/Ships/spear_class/spear_class.png"

var velocity = Vector2()
var drift_velocity = Vector2()
var speed = 0.0
var acceleration = 0.0
var rotation_dir = 0.0
var is_drifting = false
var shoot_end_cycle = true
var first_move = true
var max_health = 0
var destroyed = false

onready var ParentNode = $'..'
onready var hitEffectsTimer = $"Timers/HitEffect"
onready var hitDetector = $'HitDetection'
onready var collisionShape = $'CollisionShape2D'
onready var sprite = $'Sprite'
onready var damageEffect = $'DamageParticles'
onready var explosionEffect = $'Explosion'
onready var gameManager = get_tree().get_root().get_node('Scene/GameManager')


func input():
	is_drifting = false
	velocity = Vector2()
	rotation_dir = 0
	acceleration = 0
	if Input.is_action_pressed('turn_right'):
		rotation_dir += Input.get_action_strength("turn_right")
	if Input.is_action_pressed('turn_left'):
		rotation_dir -= Input.get_action_strength("turn_left")
	if Input.is_action_pressed('slow_down'):
		acceleration -= Input.get_action_strength("slow_down")*max_acceleration
	if Input.is_action_pressed('accelerate'):
				acceleration += Input.get_action_strength("accelerate")*max_acceleration	
	if first_move and (rotation_dir != 0 or acceleration != 0):
		emit_signal("moved")
		first_move = false	
	is_drifting = Input.is_action_pressed('drift')


func accelerate():
	speed += acceleration
	if speed > max_speed:
		speed = max_speed
	elif speed < min_speed:
		speed = min_speed
			
	if speed > 0:
		velocity = Vector2(speed, 0).rotated(rotation)
	else:
		velocity = Vector2(-speed, 0).rotated(rotation)	
	velocity = velocity.normalized() * speed + drift_velocity/(1+drag/100)
	drift_velocity = velocity
	if drift_velocity.length() > max_drag:
		drift_velocity = drift_velocity.normalized() * max_drag
	speed = speed/((1+drag/25))


func drift():
	acceleration = 0
	velocity = drift_velocity
	drift_velocity = drift_velocity/(1+drag/400)
	speed = speed/((1+drag/25))


func check_outside():
	if position.x > 325:
		position.x = -5
	if position.x < -5:
		position.x = 325
	if position.y > 185:
		position.y = -5
	if position.y < -5:
		position.y = 185


func get_damage():
	return 10
	
func damaged(amount):
	health -= amount
	emit_signal("change_health", health)
	sprite.modulate = Color(1, 0, 0)
	hitEffectsTimer.start(0.1)
	if health <= 0:
		on_destroy()

func healed(amount):
	if health + amount > max_health:
		health = max_health
	else:
		health += amount
	emit_signal("change_health", health)
	sprite.modulate = Color(0, 1, 0)
	hitEffectsTimer.start(0.1)


func on_destroy():
	destroyed = true
	sprite.visible = false
	hitDetector.queue_free()
	collisionShape.queue_free()
	damageEffect.queue_free()
	explosionEffect.play(3.2)


func _ready():
	sprite.modulate = Color(1, 1, 1)
	self.connect('change_health', gameManager, '_on_playerHealth_change')
	self.connect('moved', gameManager, '_on_player_move')
	max_health = health
	emit_signal("change_health", health)


func _physics_process(delta):
	if (destroyed):
		pass
	input()
	if is_drifting:
		drift()
	else:
		accelerate()
	check_outside()
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	var body_node = body.get_node('.')
	if body != hitDetector and body != self:
		if body_node.has_method('get_damage'):
			damaged(body_node.get_damage())
		if body_node.has_method('get_healing'):
			healed(body_node.get_healing())


func _on_HitTimer_timeout():
	sprite.modulate = Color(1, 1, 1)



func _on_ExplosionDurationTimer_timeout():
	queue_free()
