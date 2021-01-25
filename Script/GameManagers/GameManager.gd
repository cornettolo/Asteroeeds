extends Node2D

export (int) var asteroidSpawnTime = 3

onready var asteroidSpawnTimer = $'AsteroidSpawnTimer'
onready var entitiesNode = $'../Entities'
onready var scoreGUI = $"../GUI/GUITop/ScoreCounter/ScoreNumber"
onready var shipHealthGUI = $"../GUI/GUIBottom/ShipInfoCounters/HealthNumber"
onready var istructions = $"../GUI/Istructions"
onready var gameOver = $"../GUI/Game Over Screen"

const Asteroid = preload("res://Prefabs/Entities/Asteroid.tscn")
var rng = RandomNumberGenerator.new()

var score = 0
var playerHealth = 0


func _ready():
	asteroidSpawnTimer.one_shot = true
	rng.randomize()
	gameOver.visible = false
	updateUI(str(score), 'score')
	updateUI(str(playerHealth), 'shipinfo.health')


func reset_scene():
	get_tree().reload_current_scene()


func spawn_asteroid():
	var new_asteroid_instance = Asteroid.instance()
	var toss = rng.randi_range(0,1)
	if(toss > 0):
		new_asteroid_instance.position = Vector2(330,rng.randf_range(0,190))
	else:
		new_asteroid_instance.position = Vector2(rng.randf_range(0,330),190)
	entitiesNode.call_deferred("add_child", new_asteroid_instance)


func _on_player_move():
	if (istructions):
		istructions.queue_free()
	asteroidSpawnTimer.start(asteroidSpawnTime)
	print('moved')


func _on_AsteroidSpawnTimer_timeout():
	asteroidSpawnTimer.start(asteroidSpawnTime/log(float(score)/100))
	spawn_asteroid()


func _on_Asteroid_destroyed(add_score):
	if (playerHealth > 0):
		score += add_score
		updateUI(str(score), 'score')


func _on_playerHealth_change(value):
	playerHealth = value
	if shipHealthGUI:
		updateUI(str(playerHealth), 'shipinfo.health')
	if playerHealth <= 0:
		playerHealth = 0
		updateUI(str(playerHealth), 'shipinfo.health')
		gameOver.visible = true


func _process(_delta):
	if Input.is_action_pressed('drift') and gameOver.visible:
		reset_scene()


func updateUI(data, key):
	if key=='score':
		scoreGUI.text = data
	if key=='shipinfo.health':
		shipHealthGUI.text = data


