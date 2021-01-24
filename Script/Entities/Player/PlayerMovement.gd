 extends KinematicBody2D

export (float) var max_speed = 40
export (float) var max_acceleration = 1.05
export (float) var max_drag = 120
export( float) var drag = 3
export (float) var rotation_speed = 2.4
export (int) var rate_of_fire = 400

const BaseBullet = preload("res://Prefabs/Entities/Bullet.tscn")

var velocity = Vector2()
var drift_velocity = Vector2()
var speed = 0
var acceleration = 0
var rotation_dir = 0
var is_drifting = false
var is_shooting = false
var shoot_end_cycle = true

onready var ParentNode = $'..'
onready var shootTimer = $'ShootTimer'

func input():
	is_drifting = false
	velocity = Vector2()
	rotation_dir = 0
	acceleration = 0
	if Input.is_action_pressed('turn_right'):
		rotation_dir += 1
	if Input.is_action_pressed('turn_left'):
		rotation_dir -= 1
	if Input.is_action_pressed('slow_down'):
		acceleration -= max_acceleration
	if Input.is_action_pressed('accelerate'):
		acceleration += max_acceleration
	is_shooting = Input.is_action_pressed('shoot')
	is_drifting = Input.is_action_pressed('drift')

func accelerate():
	speed += acceleration
	if speed > max_speed:
		speed = max_speed
	elif speed < 0:
		speed = 0
			
	if speed > 0:
		velocity = Vector2(speed, 0).rotated(rotation)
	else:
		velocity = Vector2(-speed, 0).rotated(rotation)	
		
	velocity = velocity.normalized() * speed + drift_velocity/(1+drag/100)
	drift_velocity = velocity
	
	if drift_velocity.length() > max_drag:
		drift_velocity = drift_velocity.normalized() * max_drag

func drift():
	velocity = drift_velocity
	drift_velocity = drift_velocity/(1+drag/400)
	speed = speed/((1+drag/25))

func shoot():
	shootTimer.set_one_shot(true)
	shootTimer.start(1/rate_of_fire)
	
	var bullet = BaseBullet.instance()
	bullet.name = "pewpew"
	var bullet_pos = Vector2(12, 0).rotated(rotation)
	bullet.position = self.position + Vector2(bullet_pos)
	bullet.rotation = self.rotation
	# bullet.velocity = self.velocity + Vector2(0,1).rotated(self.rotation+3*PI/2) * 200
	bullet.set_linear_velocity(self.velocity + Vector2(0,1).rotated(self.rotation+3*PI/2) * 200)
	ParentNode.add_child(bullet)

	shoot_end_cycle = false


func _physics_process(delta):
	input()
	
	if is_drifting:
		drift()
	else:
		accelerate()
		
	if is_shooting and shoot_end_cycle:
		shoot()
		
	rotation += rotation_dir * rotation_speed * delta
	velocity = move_and_slide(velocity)


func _on_ShootTimer_timeout():
	shoot_end_cycle = true
