extends Node

onready var PlayerNode = $'..'
onready var ParentNode = $'../..'

onready var thrusters = {
	'front': [$'Front',$'Front2'],
	'rear': $"Rear",
	'left': [$"Left",$"Left2"],
	'right': [$"Right",$"Right2"],
}


func _process(delta):
	thrusters['rear'].emitting = PlayerNode.acceleration > 0
	thrusters['front'][0].emitting = PlayerNode.acceleration < 0
	thrusters['front'][1].emitting = PlayerNode.acceleration < 0
	thrusters['left'][0].emitting = PlayerNode.rotation_dir > 0
	thrusters['right'][1].emitting = PlayerNode.rotation_dir > 0
	thrusters['right'][0].emitting = PlayerNode.rotation_dir < 0
	thrusters['left'][1].emitting = PlayerNode.rotation_dir < 0
