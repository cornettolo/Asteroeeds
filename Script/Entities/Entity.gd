extends RigidBody2D

class_name Entity

export (int) var damage = 0

var is_outside = false
var new_pos = Vector2()


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
	
func _integrate_forces(state):
	if is_outside:
		var t = state.get_transform()
		t.origin.x = new_pos.x
		t.origin.y = new_pos.y
		state.set_transform(t)
		is_outside = false	
		
func get_damage():
	return damage

func _physics_process(_delta):
	check_outside()
