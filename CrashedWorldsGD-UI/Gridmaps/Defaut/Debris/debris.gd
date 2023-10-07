extends Node3D

@onready var wolf = preload("res://Entities/Wolf/Wolf3D/wolf3D.tscn")
@export var spawn_quantity : int = 5
var isDone : bool = false
# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export var lootable : Lootable
@export var life : int = 5
# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

func _ready():
	rotation_degrees.y = randf_range(0.0,360.0)

# ------------------------------------------------------------------------------ CUSTOM METHODS

func loot() -> Array[Item]: 
	life -= 1
	if life > 0: return []
	queue_free()
	return lootable.dropLoot()

# ------------------------------------------------------------------------------ SIGNALS

func _on_area_3d_body_entered(body):
	if !isDone:
		if body is Player:
			spawn_quantity += randi_range(-2,3)
			for i in spawn_quantity:
				var rngx = randf_range(-2.0,2.0)
				var rngz = randf_range(-2.0,2.0)
				var inst = wolf.instantiate()
				get_parent().call_deferred("add_child", inst)
				inst.global_position = global_position + Vector3(rngx, 2.0, rngz)
				inst.scale = Vector3(2.5,2.5,2.5)
				isDone = true
