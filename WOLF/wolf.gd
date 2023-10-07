extends CharacterBody2D

const speed = 200
const friction = 0.01
const acceleration = 2
var rotation_speed = 1.5

func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.normalized() * speed

	if velocity.y != 0:
		$AnimatedSprite2D.animation = "walk_down" if velocity.y > 0 else "walk_up"
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "walk_right" if velocity.x > 0 else "walk_left"
	if velocity.length() > 0:
			$AnimatedSprite2D.play()
	else:
			$AnimatedSprite2D.stop()

	#rotation += rotation_dir * rotation_speed * delta
	position += velocity * delta

