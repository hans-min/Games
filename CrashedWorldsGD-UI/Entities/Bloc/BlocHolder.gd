extends Sprite3D

@export var item : ItemHolder
signal buyItem

func _ready():
	texture = item.item.icon

func use():
	buyItem.emit(item, 1)
