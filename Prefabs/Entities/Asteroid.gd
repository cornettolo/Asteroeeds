extends RigidBody2D

var new_pos = Vector2()
var is_outside = false

var health = 200

onready var sprite = $'Sprite'
onready var hitTimer = $'HitTimer'
onready var hitDetector = $'HitDetection'

func check_outside():
	if position.x > 330:
		is_outside = true
		new_pos.x = -10
		new_pos.y = position.y
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
	if position.x < -10:
		is_outside = true
		new_pos.x = 330
		new_pos.y = position.y
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
	if position.y > 190:
		is_outside = true
		new_pos.x = position.x
		new_pos.y = -10
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))
	if position.y < -10:
		is_outside = true
		new_pos.x = position.x
		new_pos.y = 190
		# print("[Asteroid] outside x: " + str(position.x) + " y: " + str(position.y))

func _ready():
	sprite.modulate = Color(1, 1, 1)
	
func _integrate_forces(state):
	if is_outside:
		var t = state.get_transform()
		t.origin.x = new_pos.x
		t.origin.y = new_pos.y
		state.set_transform(t)
		is_outside = false

func _physics_process(delta):
	check_outside()


func _on_Area2D_body_entered(body):
	print('collision between: ' + str(hitDetector) + ' and ' + str(body))
	if not body.is_in_group("border") and body != hitDetector:
		print(body.name)
		health -= 12
		sprite.modulate = Color(1, 0, 0)
		hitTimer.start(0.1)
		if health < 0:
			queue_free()


func _on_HitTimer_timeout():
	sprite.modulate = Color(1, 1, 1)
	pass # Replace with function body.
