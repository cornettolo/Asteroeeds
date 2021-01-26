extends RigidBody2D

export (float) var duration = 60
export (int) var damage = 24
export (Vector2) var direction = Vector2()
export (Vector2) var velocity = Vector2()

onready var destroyTimer = $'DestroyTimer'
onready var sprite = $"Sprite"
onready var hitParticle = $"HitParticle"
onready var collisionDetector = $"CollisionDetector"
onready var collisionShape = $'CollisionShape2D'

var hitted = false

func _ready():
	destroyTimer.start(10)
	hitParticle.one_shot = true

func get_damage():
	return damage


func _physics_process(delta):
	if hitted:
		collisionShape.disabled = true
		collisionDetector.get_node("CollisionShape2D").disabled = true
		linear_velocity = Vector2(0 ,0)
		angular_velocity = 0

func _on_DestroyTimer_timeout():
	queue_free()

func _on_CollisionDetector_area_entered(area):
	if not area.is_in_group("player"):
		destroyTimer.start(10)
		sprite.visible = false
		hitParticle.emitting = true
		hitted = true
