extends Button

var is_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", button_down)
	connect("button_up", button_up)
	connect("mouse_exited", button_up)

func button_down():
	is_pressed = true

func button_up():
	is_pressed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_pressed:
		get_parent().get_parent().get_node("Dino").jump()
