extends Sprite3D

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export var item : ItemHolder

signal buyItem

var duration
signal heal
signal speed
signal light
signal jump
signal teleport
signal life_up


# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

func _ready():
	connect("heal", UseEffect.playerStats.heal)
	connect("life_up", UseEffect.playerStats.addMaxLife)
	connect("speed", SceneManager.player._on_speed)
	connect("jump", SceneManager.player._on_jump)
	connect("light", SceneManager.player._on_light)
	connect("teleport", SceneManager.player._on_tp)
	texture = item.item.icon

# ------------------------------------------------------------------------------ CUSTOM METHODS
func use():
	#Potion sound
	$AudioStreamPlayer.play()
	match item.item.itemName:
		"Heal Potion" : heal.emit(5)
		"Life Potion" : life_up.emit(1)
		"Speed Potion" : speed.emit(4)
		"Jump Potion" : jump.emit(5)
		"Light Potion" : light.emit()
		"Teleport Potion" : teleport.emit()

	buyItem.emit(item, 1)

# ------------------------------------------------------------------------------ SIGNALS


