extends Node3D
class_name MainGame

@onready var itemdrop = preload("res://Entities/ItemDrop/ItemDrop.tscn")

#func _input(event):
#	if event.is_action_pressed("ui_accept"):
#		$Wolf/SubViewport/Node2D.calculate_hue()
#		random_terrain()



func _ready():
	ALTC.world_time_played = Time.get_ticks_msec()
	randomize()
	UseEffect.connect("destroyGrid", destroyGrid)
	UseEffect.connect("placeGrid", placeGrid)
	UseEffect.connect("destroyObject", dropItem)
	SceneManager.connect("dropRequest", dropItem)

func destroyGrid(pos: Vector3i):
#	print(pos)
	var blocID = $GridMap.get_cell_item(pos)
	
	var blocitem = []
	match blocID:
		0: blocitem.append(load("res://Resources/Item/Blocs/GrassBloc.tres"))
		1: blocitem.append(load("res://Resources/Item/Blocs/DirtBloc.tres"))
		2: blocitem.append(load("res://Resources/Item/Blocs/StoneBloc.tres"))
		3: blocitem.append(load("res://Resources/Item/Blocs/GrassyStoneBloc.tres"))
		4: blocitem.append(load("res://Resources/Item/Blocs/SandBloc.tres"))
		5:
			blocitem.append(load("res://Resources/Item/Lootables/Berries/RedBerry.tres"))
			blocitem.append(load("res://Resources/Item/Lootables/Wood.tres"))

	for i in blocitem:
		dropItem([i], pos)
		$GridMap.set_cell_item(pos, $GridMap.INVALID_CELL_ITEM)
		$DestroyBlockSound.play()


func placeGrid(pos: Vector3i, id:int):
	if $GridMap.get_cell_item(pos) == $GridMap.INVALID_CELL_ITEM:
		$GridMap.set_cell_item(pos, id)
		$PlaceBlocSound.play()

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
		
func _pause() -> void:
	$Paused.pause()
	get_tree().paused = true

func dropItem(items : Array[Item], pos : Vector3):
	for i in items:
		var holder = ItemHolder.new(i, 1)
		var inst = itemdrop.instantiate()
		inst.item = holder
		$GridMap/Spawner.call_deferred("add_child", inst)
		inst.global_position = Vector3(pos.x + 0.5, pos.y + 0.5, pos.z+0.5)
