extends CharacterBody2D

const GRAVITY = 4200
const JUMP_SPEED = -1800.0

func jump():
	if not is_on_floor():
		return
	velocity.y = JUMP_SPEED
	$JumpSound.play()

func duck():
	if not is_on_floor():
		return
	$DinoAnimation.play("duck")
	$RunCol.disabled = true

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if get_parent().get_node("Controls").get_node("Duck").is_pressed:
		return
	if is_on_floor():
		$RunCol.disabled = false		
		if not get_parent().game_running:
			$DinoAnimation.play("idle")			
		elif Input.is_key_pressed(KEY_SPACE):
			jump()
		elif Input.is_key_pressed(KEY_DOWN):
			duck()
		else:
			$DinoAnimation.play("run")
	else:
		$DinoAnimation.play("jump")
	
	move_and_slide()
