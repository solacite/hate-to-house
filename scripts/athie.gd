extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump
	if Input.is_action_just_pressed("a_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("a_left", "a_right")
	if direction:
		if sprite.animation != "walk":
			sprite.play("walk")
		velocity.x = direction * SPEED
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
