extends Node3D

#@onready var item_scene = preload("res://Entities/ItemDrop/ItemDrop.tscn")

#@export var spawned_items: Array[ItemHolder]

var spawned_ai: Array[Spawnable]
var spawned_objects: Array[Spawnable]
var size: int
var scale_quantity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_parent().ready
	scale_quantity = GameOptions.worldSize / 256.0
	spawn_objects()
	spawn_creatures()
	
	

func spawn_creatures() -> void:
	for scene in spawned_ai:
		for i in range(scene.quantity):
			var inst = scene.scene.instantiate()
			call_deferred("add_child", inst)
			await inst.ready
			inst.position = create_random_position()
			inst.scale = Vector3(2.5,2.5,2.5)
			
			#print("ai pos: "+ str(wolf.position))
			

func spawn_objects() -> void:
	for scene in spawned_objects:
		for i in range(scene.quantity):
			var object = scene.scene.instantiate()
			call_deferred("add_child", object)
			await object.ready
			object.global_position = create_random_position()
			object.scale = Vector3(1,1,1)
			
			#print("globalpos: "+ str(object.global_position))

# func spawn_items() -> void:
# 	for item in spawned_items:
# 		for i in range(item.quantity):
# 			var item_drop: ItemDrop = item_scene.instantiate()
# 			item_drop.item = item
# 			item_drop.scale = Vector3(2.5,2.5,2.5)
# 			add_child(item_drop)
# 			item_drop.global_position = create_random_position(55,60)
# 			#print("globalpos of item: "+ str(item_drop.global_position))

func create_random_position(min_range: int = 0, max_range: int = size) -> Vector3:
	max_range = GameOptions.worldSize
	var x = randi_range(min_range, max_range)
	var z = randi_range(min_range, max_range)
	var y: int = get_parent().get_heighest_cell(x, z)
	return Vector3(x, y + 1.1, z)
