extends CharacterBody2D

const GRAVITY = 4200
const JUMP_SPEED = -1800.0

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		$RunCol.disabled = false		
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_SPEED
			$JumpSound.play()
		elif Input.is_action_pressed("ui_down"):
			$DinoAnimation.play("duck")
			$RunCol.disabled = true
		else:
			$DinoAnimation.play("run")
	else:
		$DinoAnimation.play("jump")
	
	move_and_slide()
