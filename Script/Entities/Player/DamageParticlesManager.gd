extends Node

onready var PlayerNode = $'..'
onready var ParentNode = $'../..'

onready var SmokeParticle = $'Smoke'
onready var FireParticle = $'Fire'

func _process(delta):
	SmokeParticle.emitting = PlayerNode.health < PlayerNode.max_health/2
	FireParticle.emitting = PlayerNode.health < PlayerNode.max_health/4
