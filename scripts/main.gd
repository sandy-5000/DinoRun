extends Node

# game variables
const DINO_START_POS = Vector2i(150, 485)
const CAM_START_POS = Vector2i(576, 324)

var speed: float
const START_SPEED = 10.0
const MAX_SPEED = 25
var screen_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Dino.position = DINO_START_POS
	$Dino.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = START_SPEED
	
	$Dino.position.x += speed
	$Camera2D.position.x += speed
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
