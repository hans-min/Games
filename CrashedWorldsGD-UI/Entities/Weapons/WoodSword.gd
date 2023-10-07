extends Node3D

@export_group("Item")
@export var item : ItemHolder

@export_group("Custom Properties")
@export var damage : int = 1

func _ready():
	$Sprite3D.texture = item.item.icon

func use():
	$AnimationPlayer.play("Attack")


func _on_area_3d_body_entered(body):
	if "Stats" in body and not body is Player:
		body.Stats.damage(damage)
		$HitSound.play()
		$HitSound.pitch_scale = randf_range(0.8,1.2)

