extends Node

# preload obstacles
var stump_scene = preload("res://scenes/stump.tscn")
var rock_scene = preload("res://scenes/rock.tscn")
var barrel_scene = preload("res://scenes/barrel.tscn")
var bird_scene = preload("res://scenes/bird.tscn")
var obstacle_types = [stump_scene, rock_scene, barrel_scene]
var obstacles: Array
var bird_heights = [200, 300]

# game variables
const DINO_START_POS = Vector2i(150, 485)
const CAM_START_POS = Vector2i(576, 324)
var speed: float
const START_SPEED = 10.0
const MAX_SPEED = 25
var screen_size: Vector2i
var ground_height: int
var score: int = 0
const SCORE_MODIFIER = 10
const SPEED_MODIFIER = 5000
var game_running: bool
var last_obstacle

# Called when the node enters the scene tree for the first time. 
func _ready():
	score = 0
	show_score(score)
	screen_size = get_window().size
	ground_height = $Ground.get_node('Image').texture.get_height()
	new_game()

func new_game():
	game_running = false
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	$HUD.get_node("StartLabel").show()

func show_score(score):
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

func generate_obstacle():
	if obstacles.is_empty() or last_obstacle.position.x < score + randi_range(300, 500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs = obs_type.instantiate()
		var obs_height = obs.get_node("Image").texture.get_height()
		var obs_scale = obs.get_node("Image").scale
		var obs_x = screen_size.x + score + 100
		var obs_y = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
		last_obstacle = obs
		add_obstacle(obs, obs_x, obs_y)

func add_obstacle(obs, x, y):
	obs.position = Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not game_running:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
		return
	speed = START_SPEED + score / SPEED_MODIFIER
	if speed > MAX_SPEED:
		speed = MAX_SPEED
	generate_obstacle()
	score += speed
	show_score(score)
	$Dino.position.x += speed
	$Camera2D.position.x += speed
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
