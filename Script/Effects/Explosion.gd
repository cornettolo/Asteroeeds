extends Node2D

onready var durTimer = $'DurationTimer'
onready var durParticles = $'ExplosionParticles'

func play(duration):
	durTimer.wait_time = duration
	durParticles.lifetime = duration
	durParticles.emitting = true
	durTimer.start()
