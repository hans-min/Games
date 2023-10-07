extends CharacterBody3D

class_name Player

var SPEED = 6.0
var JUMP_VELOCITY = 4.5

signal useItem

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var Stats : EntityStats

var screen_x_size : float # Used to flip character based on mouse pos
var iswet : bool = false
var isControllerInUse : bool = true

# Declare a new variable for the raycast (added)
var raycast : RayCast3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	connect("useItem", UseEffect.useItemType)
	Stats.duplicate()
	Stats.connect("update", _on_life_changed)
	Stats.connect("damaged", _on_damaged)
	Stats.connect("healed", _on_healed)
	Stats.connect("death", _on_death)
	Stats.update.emit()
	
	screen_x_size = get_viewport().size.x
	
	UseEffect.playerStats = Stats
	SceneManager.player = self
	
	raycast = $RayCast3D
	
	global_position = Vector3(GameOptions.worldSize / 2.0, 60, GameOptions.worldSize / 2.0 + 5)


func _unhandled_input(event):
	# ITEM USAGE
	if event.is_action_pressed("LMB"):
		if $Equiped.get_child_count() > 0:                     # If item is equiped
			$Equiped.get_child(0).use()  
			$SwingSound.pitch_scale = randf_range(0.8,1.2)
			$SwingSound.play()
			useItem.emit($Equiped.get_child(0).item, $Camera3D)# pass the info to singleton
			if $Equiped.get_child(0).item.quantity <= 0:         # if there is no more item after that
				$Equiped.get_child(0).queue_free()             # delete the item

func _input(event):
	if event is InputEventMouseMotion:
		if event.position.x >= screen_x_size / 2.0:
			$AnimatedSprite3D.flip_h = false
			$Equiped.position.x = 0.3
			$Equiped.scale.x = 1
		else:
			$AnimatedSprite3D.flip_h = true
			$Equiped.position.x = -0.3
			$Equiped.scale.x = -1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		ALTC.player_jump += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if velocity == Vector3.ZERO:
		$AnimatedSprite3D.play("Idle")
		$Camera3D.position.z = lerp($Camera3D.position.z, 3.75, 0.1)
		$CPUParticles3D.emitting = false
	else:
		$Camera3D.position.z = lerp($Camera3D.position.z, 4.25, 0.1)
		$AnimatedSprite3D.play("Run")
		if is_on_floor():
			$CPUParticles3D.emitting = true
		else :
			$CPUParticles3D.emitting = false
		

		
		###SOUND###
		if $Timer.time_left <= 0 and is_on_floor(): 
			#Raycast under player
			var collider = raycast.get_collider()
			#Get the gridmap
			var grid_map = collider
			#Get cell corresponding
			var cell_pos = Vector3(round(position.x),round(position.y-2),round(position.z))
			if collider:
				if iswet : 
					$WaterFootsteps.pitch_scale = randf_range(0.8,1.2)
					$WaterFootsteps.play()
				if collider.get_class() == "CharacterBody3D": 
					$GrassFootsteps.pitch_scale = randf_range(0.8,1.2)
					$GrassFootsteps.play()
				if collider.name == "GridMap":
					if grid_map.get_cell_item(cell_pos) == 0:
							$GrassFootsteps.pitch_scale = randf_range(0.8,1.2)
							$GrassFootsteps.play()
					elif grid_map.get_cell_item(cell_pos) == 1:
						$DirtFootsteps.pitch_scale = randf_range(0.8,1.2)
						$DirtFootsteps.play()
					elif grid_map.get_cell_item(cell_pos) == 2:
						$StoneFootsteps.pitch_scale = randf_range(0.8,1.2)
						$StoneFootsteps.play()
					elif grid_map.get_cell_item(cell_pos) == 3:
						$GrassyStoneFootsteps.pitch_scale = randf_range(0.8,1.2)
						$GrassyStoneFootsteps.play()
					elif grid_map.get_cell_item(cell_pos) == 4:
						$SandFootsteps.pitch_scale = randf_range(0.8,1.2)
						$SandFootsteps.play()
					else:
						$GrassFootsteps.pitch_scale = randf_range(0.8,1.2)
						$GrassFootsteps.play()
					
				$Timer.start(0.4)
		###SOUND###
	move_and_slide()

func _process(delta):
	if isControllerInUse:
		var movement = Vector2.ZERO
		movement.x = Input.get_action_strength("cursor_right") - Input.get_action_strength("cursor_left")
		movement.y = Input.get_action_strength("cursor_down") - Input.get_action_strength("cursor_up")
		
#		if abs(movement.x) == 1 and abs(movement.y) == 1:
#			movement = movement.normalized()
			
		movement = movement * 600.0 * delta
		Input.warp_mouse(get_tree().get_root().get_mouse_position() + movement)
	
	if global_position.y < -10:
		_on_death()
		

func equip(item : ItemHolder):
	if $Equiped.get_child_count() > 0:
		for i in $Equiped.get_children():
			i.queue_free()
	if item :
		$Equiped.show()
		var inst
		if item.item.objectScenePath:
			inst = load(item.item.objectScenePath).instantiate()
			if inst.item == null:
				inst.item = item
			if inst.has_signal("buyItem"):
				inst.connect("buyItem", $Inventory.buyItem)
			$Equiped.add_child(inst)

	else:
		if $Equiped.get_child_count() > 0:
			$Equiped.get_child(0).queue_free()
		$Equiped.hide()

# ------------------------------------------------------------------------------ SIGNALS

func _on_life_changed():
	$Life/SubViewport/EntityStats.max_value = Stats.maxLife
	$Life/SubViewport/EntityStats.value = Stats.life

func _on_damaged():
	ALTC.player_damage_taken += 1
	$AnimationPlayer.play("screenshake")

func _on_healed():
	pass

func _on_death():
	SceneManager.isWon = false
	ALTC.world_escaped = false
	ALTC.world_time_played = Time.get_ticks_msec() - ALTC.world_time_played
	ALTC.game_over.emit()
	goToEndScreen()


func goToEndScreen():
	$Cinematic/AnimationPlayer.play("Vignette")


func _hide(): $AnimatedSprite3D.hide()

func _show(): $AnimatedSprite3D.show()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Vignette":
		get_tree().change_scene_to_file("res://UI/main_menu_and_game_over/game_over.tscn")


func _on_wet_detector_area_entered(area):
	if area.name == "WaterPlane" : iswet = true

func _on_wet_detector_area_exited(area):
	if area.name == "WaterPlane" : iswet = false

# ------------------------------------------------------------------------------ POTIONS

func _on_speed(value):
	SPEED = 6.0 + value
	await get_tree().create_timer(10).timeout
	SPEED = 6.0

func _on_jump(value):
	JUMP_VELOCITY = 4.5 + value
	await get_tree().create_timer(10).timeout
	JUMP_VELOCITY = 4.5

func _on_light():
	$Light.visible = true
	await get_tree().create_timer(30).timeout
	$Light.visible = false

func _on_tp():
	global_position = Vector3(GameOptions.worldSize / 2.0, 60, GameOptions.worldSize / 2.0 + 5)
