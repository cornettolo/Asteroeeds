extends Node2D

export (float) var duration = 0.6
export (int) var speed = 12
export (int) var label = ''

onready var durationTimer = $"DurationTimer"
onready var labelNode = $"Label"

func _ready():
	durationTimer.wait_time = duration
	if labelNode:
		labelNode.set_text(label)
	durationTimer.start()

func _process(delta):
	position.y -= speed * delta
	# print(position.y)


func set_text(txt):
	label = txt
	if labelNode:
		labelNode.set_text(label)

func _on_DuratiionTimer_timeout():
	queue_free()
