extends Node3D

var isWin : bool = false

func _ready():
	isWin = SceneManager.isWon
	$VignettePlayer.play("Vignette")
	match isWin:
		true : 
			$AnimationPlayer.play("Floating")
		false : 
			$Node3D.hide()
			$CanvasLayer/MarginContainer/Label.text = "YOU PERISHED..."
	
	


func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu_and_game_over/main_menu.tscn")
