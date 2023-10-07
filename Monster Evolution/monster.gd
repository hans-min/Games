extends CharacterBody2D

const SPEED = 300.0
const jump_velocity = -400.0
const TERMINAL_VELOCITY = 400

var is_attacking := false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	elif Input.is_action_just_released("ui_accept") and velocity.y < 0.0:
		# The player let go of jump early, reduce vertical momentum.
		velocity.y *= 0.6
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)

	# Get the input direction_x and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x: = Input.get_axis("ui_left", "ui_right") * SPEED
	velocity.x = move_toward(velocity.x, direction_x, SPEED * 6 * delta)

	if not is_zero_approx(velocity.x):
		animated_sprite.flip_h = velocity.x < 0

	move_and_slide()

	if Input.is_action_just_pressed("attack"):
		is_attacking = true
	var animation := get_animation()
	if animation != animated_sprite.animation:
		animated_sprite.play(animation)

func get_animation() -> String:
	var animation_new: String
	if is_on_floor():
		if absf(velocity.x) > 0.1:
			animation_new = "run"
			#animated_sprite.flip_h = velocity.x < 0
		else:
			animation_new = "idle"
	else:
		animation_new = "jump"
	if is_attacking:
		velocity.x = 0
		animation_new = "attack"
	return animation_new


func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false


func _on_area_2d_body_entered(body:Node2D) -> void:
	if is_attacking && body.is_in_group("enemy"):
		print("snail shall die")