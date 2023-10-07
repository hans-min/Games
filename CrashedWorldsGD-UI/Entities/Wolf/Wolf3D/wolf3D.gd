extends CharacterBody3D

var target : Player
var targetPos
var speed = 4
var guardSpeed = 6
var jumpForce = 5
var seePlayer
var target_pos : Vector3 = Vector3(0,1,0)
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var isAttacking
var canDamage

enum states {AGGRO, ATTACK}

@export var State: states:
	set(val):
		State = val	
		#_on_state_changed(val)
	get : return State

@export var Stats : EntityStats
@export var damage : int = 1

var viewportworkaround : ViewportTexture 
var workaroundDone : bool = false

#------------------------------------------------------------------------------- BASE METHODS
# Called when the node enters the scene tree for the first time.
func _ready():
	await RenderingServer.frame_post_draw
	viewportworkaround = $SubViewport.get_texture()
	#_on_state_changed(State)
	Stats = Stats.duplicate()
	Stats.connect("death", on_death)
	Stats.connect("update", on_life_update)
	Stats.update.emit()
	
	_hide()
	
	set_process(false)
	set_physics_process(false)
	
	seePlayer = true
	isAttacking = false
	canDamage = true
	
	target = SceneManager.player
	
	State = states.AGGRO

func _physics_process(delta):
	match State :
		states.AGGRO : _Aggro()
		states.ATTACK : _Attack()

	velocity.y -= gravity * delta

	if velocity.x >= 0:
		$SubViewport/Wolf.flip(true)
	else:
		$SubViewport/Wolf.flip(false)
	
	move_and_slide()

# ------------------------------------------------------------------------------ CUSTOM METHODS
## When the AI detect the Player at close range
func _Aggro():
	if target :
		var movement = (target.global_position - global_position).normalized() * speed
		velocity = movement
		velocity.y = -2
		#INSERT ANIMATIONS

## When the AI is at attack range, freeze and prepare to jump
func _Attack():
	if (!isAttacking) : 
		isAttacking = true
		targetPos = (target.global_position - global_position).normalized()
		velocity = Vector3.ZERO
		$AttackPrep.start()
		#_Bite()

## Called if the AI colide with the Player, deals damage and start timer for next attack
func _Bite():
	# damage to the Player
	print("Taking damage !")

func on_death():
	$DeathSound.play()
	SceneManager.dropRequest.emit(Stats.lootable.dropLoot(), global_position)
	await get_tree().create_timer(0.21).timeout
	queue_free()

func on_life_update():
	$SubViewport/EntityStats.max_value = Stats.maxLife
	$SubViewport/EntityStats.value = Stats.life

func _hide():
	$Mesh.hide()

func _show():
	$Mesh.show()
	
func _check_player():
	var bodies = $AreaAttack.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			State = states.ATTACK
		else:
			State = states.AGGRO
#------------------------------------------------------------------------------- SIGNALS

func _on_area_attack_body_entered(body):
	if body is Player:
		State = states.ATTACK
		target = body

func _on_area_attack_body_exited(body):
	if body is Player:
		#State = states.AGGRO
		target = body

func _on_area_dmg_body_entered(body):
	if body is Player:
		if (canDamage):
			body.Stats.damage(damage)
			$DamageCooldown.start()
			_Bite()
			canDamage = false

func _on_attack_prep_timeout():
	# BITE DASH GOES HERE
	$AttackCooldown.start()
	velocity = targetPos * speed * 2
	if is_on_floor():
		velocity.y = jumpForce

func _on_attack_cooldown_timeout():
	_check_player()
	isAttacking = false

func _on_damage_cooldown_timeout():
	canDamage = true
