extends Node

const BaseBullet = preload("res://Prefabs/Entities/Bullet.tscn")

export (int) var rate_of_fire = 5

onready var shootTimer = $"../Timers/Shoot"
onready var PlayerNode = $'..'
onready var ParentNode = $'../..'

var is_shooting = false
var shoot_end_cycle = true
var shoot_mirror = false

func input():
	is_shooting = Input.is_action_pressed('shoot')


func shoot():
	var bullet = BaseBullet.instance()
	var bullet_pos = Vector2(10 + PlayerNode.velocity.length()/50, 1).rotated(PlayerNode.rotation)
	if (shoot_mirror):
		bullet_pos = Vector2(10 + PlayerNode.velocity.length()/50, -1).rotated(PlayerNode.rotation)
		bullet.get_node("Sprite").flip_h = true
		
	bullet.position = PlayerNode.position + Vector2(bullet_pos)
	bullet.rotation = PlayerNode.rotation
	bullet.set_linear_velocity(PlayerNode.velocity + Vector2(0,1).rotated(PlayerNode.rotation+3*PI/2) * 350)
	
	ParentNode.add_child(bullet)

	shoot_mirror = !shoot_mirror

	var timer_time = 1.0/rate_of_fire
	shootTimer.start(timer_time)
	shoot_end_cycle = false

func _process(delta):
	input()
	
	if is_shooting and shoot_end_cycle:
		shoot()


func _on_Shoot_timeout():
	shoot_end_cycle = true
