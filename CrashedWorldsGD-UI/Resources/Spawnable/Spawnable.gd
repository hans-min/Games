extends Resource
class_name Spawnable

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export var scene : PackedScene
@export var quantity : int = 0

func _init(sceneToSpawn : PackedScene = null, amount : int = 0):
	scene = sceneToSpawn
	quantity = amount

