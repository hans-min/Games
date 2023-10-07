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


