extends Node2D

export (int) var asteroidSpawnTime = 6.0
export (int) var repairpackSpawnTime = 3.0

onready var asteroidSpawnTimer = $'AsteroidSpawnTimer'
onready var repairSpawnTimer = $'RepairSpawnTimer'
onready var entitiesNode = $'../Entities'
onready var UI = $"../GUI"
onready var PopupControl = $"../Popup"
onready var scoreGUI = $"../GUI/GUITop/ScoreCounter/ScoreNumber"
onready var shipHealthGUI = $"../GUI/GUIBottom/ShipInfoCounters/HealthNumber"
# onready var istructionsUI = $"../GUI/Istructions"
# onready var gameOverUI = $"../GUI/Game Over Screen"
# onready var pauseUI = $"../GUI/Pause Screen"

const Asteroid = preload("res://Prefabs/Entities/Asteroids/Asteroid.tscn")
const Repair = preload("res://Prefabs/Entities/RepairPack.tscn")
var rng = RandomNumberGenerator.new()

var score = 0
var playerHealth = 0
var game_started = true
var paused = false

const PauseScreen = preload("res://Prefabs/UI/Menus/Pause Screen.tscn")
const GameOverScreen = preload("res://Prefabs/UI/Menus/Game Over Screen.tscn")

var pauseNode = null
var gameoverNode = null

func _ready():
	asteroidSpawnTimer.one_shot = true
	rng.randomize()
	
	UI.visible = true
	# istructiownsUI.visible = true
	# gameOverUI.visible = false
#	pauseUI.visible = false
	updateUI(str(score), 'score')
	updateUI(str(playerHealth), 'shipinfo.health')
	

func reset_scene():
	get_tree().reload_current_scene()


func pause():
	# show pause
	pauseNode = PauseScreen.instance()
	PopupControl.add_child(pauseNode)
	pauseNode.visible = true
	pauseNode.connect("button_pressed", self, "_on_GUI_button_pressed")
	
	paused = true
	get_tree().paused = Node.PAUSE_MODE_PROCESS
	
func unpause():
#	pauseUI.visible = false
	# remove pause
	pauseNode.queue_free()
	paused = false
	get_tree().paused = false


func game_over():
	gameoverNode = GameOverScreen.instance()
	PopupControl.add_child(gameoverNode)
	gameoverNode.visible = true
	gameoverNode.connect("button_pressed", self, "_on_GUI_button_pressed")


func spawn_asteroid():
	var new_asteroid_instance = Asteroid.instance()
	var toss = rng.randi_range(0,1)
	if(toss > 0):
		new_asteroid_instance.position = Vector2(330,rng.randf_range(0,190))
	else:
		new_asteroid_instance.position = Vector2(rng.randf_range(0,330),190)
	entitiesNode.call_deferred("add_child", new_asteroid_instance)

func spawn_repair():
	var new_repair_instance = Repair.instance()
	var toss = rng.randi_range(0,1)
	if(toss > 0):
		new_repair_instance.position = Vector2(330,rng.randf_range(0,190))
	else:
		new_repair_instance.position = Vector2(rng.randf_range(0,330),190)
	entitiesNode.call_deferred("add_child", new_repair_instance)


func _on_player_move():
#	if (istructionsUI):
#		istructionsUI.queue_free()
	game_started = true
	asteroidSpawnTimer.start(asteroidSpawnTime)
	repairSpawnTimer.start(repairpackSpawnTime)


func _on_AsteroidSpawnTimer_timeout():
	var wait_time = asteroidSpawnTime
	if log(float(score)/200) > 1:
		wait_time = asteroidSpawnTime/(log(float(score)/200))
	asteroidSpawnTimer.start(wait_time)
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
		game_over()
		game_started = false


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pause()


func _process(_delta):	
	if Input.is_action_just_released("ui_pause") and game_started:
		if paused:
			unpause()
		else:
			pause()
		
		
func updateUI(data, key):
	if key=='score':
		scoreGUI.text = data
	if key=='shipinfo.health':
		shipHealthGUI.text = data


func _on_RepairSpawnTimer_timeout():
	var wait_time = repairpackSpawnTime
	repairSpawnTimer.start(wait_time)
	spawn_repair()


func _on_GUI_button_pressed(value):
	if value == 'quit':
		get_tree().quit()
	if value == 'restart':
		reset_scene()
	if value == 'resume':
		unpause()
	print(value)
