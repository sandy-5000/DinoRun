extends Node

# preload obstacles
var stump_scene = preload("res://scenes/stump.tscn")
var rock_scene = preload("res://scenes/rock.tscn")
var barrel_scene = preload("res://scenes/barrel.tscn")
var bird_scene = preload("res://scenes/bird.tscn")
var obstacle_types = [stump_scene, rock_scene, barrel_scene]
var obstacles: Array
var bird_heights = [200, 400]

# game variables
const DINO_START_POS = Vector2i(150, 485)
const CAM_START_POS = Vector2i(576, 324)
var difficulty: float
const MAX_DIFFICULTY = 2
var speed: float
const START_SPEED = 10.0
const MAX_SPEED = 20
var screen_size: Vector2i
var ground_height: int
var score: int
var highscore: int = 100000
const SCORE_MODIFIER = 10
const SPEED_MODIFIER = 5000
var game_running: bool
var last_obstacle

# Called when the node enters the scene tree for the first time. 
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node('Image').texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	score = 0
	difficulty = 0
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	show_score()
	$HUD.get_node("HighScoreLabel").text = "HIGHSCORE: " + str(highscore / SCORE_MODIFIER) + " "
	game_running = false
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	get_tree().paused = false

func game_over():
	get_tree().paused = true
	game_running = false
	$GameOver.show()


func show_score():
	var display_score = str(score / SCORE_MODIFIER)
	$HUD.get_node("ScoreLabel").text = " SCORE: " + display_score
	if score > highscore:
		$HUD.get_node("HighScoreLabel").text = "HIGHSCORE: " + display_score + " "
		highscore = score

func adjust_difficulty():
	difficulty += score / 10000
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func generate_obstacle():
	if obstacles.is_empty() or last_obstacle.position.x < score + randi_range(-300, 300):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = int(difficulty) + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Image").texture.get_height()
			var obs_scale = obs.get_node("Image").scale
			var obs_x = screen_size.x + score + 100 * (i + 1)
			var obs_y = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			last_obstacle = obs
			add_obstacle(obs, obs_x, obs_y)
		if difficulty >= 1 and randi() % 2 == 0:
			obs = bird_scene.instantiate()
			var obs_x = screen_size.x + score + 100
			var obs_y = bird_heights[randi() % bird_heights.size()]
			add_obstacle(obs, obs_x, obs_y)

func add_obstacle(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func remove_obstacle(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Dino":
		game_over()

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
	show_score()
	adjust_difficulty()
	$Dino.position.x += speed
	$Camera2D.position.x += speed
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
	for obs in obstacles:
		if obs.position.x < $Camera2D.position.x - screen_size.x:
			remove_obstacle(obs)
