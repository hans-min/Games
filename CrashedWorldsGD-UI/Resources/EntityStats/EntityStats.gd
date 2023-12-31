extends Resource
## Resource used to create entities. 
class_name EntityStats

## emited on death of the entity.
signal death
## emited on value changed
signal update
## emited if Lootable has been assigned
signal lootDropped

signal damaged
signal healed

@export_group("Basic Stats")
## life of the entity. Will emit death signal when reaching 0 or below
@export var life : int = 1
@export var maxLife : int = 1
@export var lootable : Lootable

# ------------------------------------------------------------------------------ Basic METHODS

## Basic init method.
func _init(newLife : int = 1, newMaxLife : int = 1, loot : Lootable = null) -> void:
	life = newLife
	maxLife = newMaxLife
	lootable = loot

# ------------------------------------------------------------------------------ CUSTOM METHODS

## Use this method to substract a certain amount of life from an entity.
func damage(amount : int = 1) -> int:
	life -= amount
	makeLifeValid()
	damaged.emit()
	return life

## Use this method to add a certain amount of life to an entity.
func heal(amount : int = 1) -> int:
	life += amount
	makeLifeValid()
	healed.emit()
	return life

## Use this method to increase maxLife.
func addMaxLife(amount : int = 1) -> int:
	maxLife += amount
	makeLifeValid()
	return maxLife

## Method that is used by damage() and heal(). 
## Will perform a clamp between 0 and maxLife.
func makeLifeValid() -> void:
	life = clamp(life, 0, maxLife)
	update.emit()
	if life <= 0 : death.emit()
	if lootable != null : lootDropped.emit(lootable)
	
