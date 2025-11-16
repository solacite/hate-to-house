extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var punching: bool = false

func _ready() -> void:
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump
	if not punching and Input.is_action_just_pressed("a_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("a_hit") and is_on_floor() and not punching:
		punching = true
		velocity.x = 0
		sprite.play("punch")

	if not punching:
		var direction := Input.get_axis("a_left", "a_right")
		if direction != 0:
			sprite.flip_h = direction < 0
			if sprite.animation != "walk":
				sprite.play("walk")
			velocity.x = direction * SPEED
		else:
			if is_on_floor():
				velocity.x = 0
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED * delta * 0.5)
			if sprite.animation != "idle":
				sprite.play("idle")

	move_and_slide()

func _on_animation_finished() -> void:
	if sprite.animation == "punch":
		punching = false
		var dir := Input.get_axis("a_left", "a_right")
		if dir != 0:
			sprite.play("walk")
		else:
			sprite.play("idle")
