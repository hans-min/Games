extends DirectionalLight3D

@export var speed : float = 0.005

func _ready():
	speed = randf_range(-0.01,0.01)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	rotation.x += speed * 0.1
