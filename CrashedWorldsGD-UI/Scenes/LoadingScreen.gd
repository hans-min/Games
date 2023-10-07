extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	$Control2/Control/PlayerSprite.play("default")
	await get_tree().create_timer(1).timeout
	print("done")
	queue_free()
	

