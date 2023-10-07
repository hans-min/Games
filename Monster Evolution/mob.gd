extends CharacterBody2D

enum State {
	WALKING,
	DEAD,
}

const WALK_SPEED = 200.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var platform_detector := $FloorDetector as RayCast2D
@onready var floor_detector_left := $EdgeDetectorLeft as RayCast2D
@onready var floor_detector_right := $EdgeDetectorRight as RayCast2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var _state := State.WALKING

func _physics_process(delta: float) -> void:
	if _state == State.WALKING && velocity.is_zero_approx():
		velocity.x = -WALK_SPEED
	if not floor_detector_right.is_colliding():
		velocity.x = -WALK_SPEED
	elif not floor_detector_left.is_colliding():
		velocity.x = WALK_SPEED

	if is_on_wall():
		velocity.x = -velocity.x
	
		
	animated_sprite.flip_h = velocity.x > 0
	velocity.y += gravity * delta
	move_and_slide()
