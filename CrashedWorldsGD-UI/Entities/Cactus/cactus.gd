extends Node3D

@export var lootable : Lootable
@export var life : int = 3
# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

func loot() -> Array[Item]: 
	life -= 1
	if life > 0: return []
	queue_free()
	return lootable.dropLoot()

func _ready():
	for i in get_children():
		i.hide()
	
	var rng = randi_range(1,2)
	match rng:
		1: 
			$Cac_01.show()
			$Cac_01_col.show()
			$Cac_02.queue_free()
			$Cac_02_col.queue_free()
		2: 
			$Cac_02.show()
			$Cac_02_col.show()
			$Cac_01.queue_free()
			$Cac_01_col.queue_free()
	
	scale *= randf_range(0.5,1.0)
	rotation_degrees.y = randf_range(0,360)
