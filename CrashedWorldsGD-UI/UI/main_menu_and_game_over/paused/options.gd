extends VBoxContainer

func _ready() -> void:
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	var root = get_tree().get_root().get_tree()
	root.paused = false
	root.change_scene_to_file("res://UI/main_menu_and_game_over/main_menu.tscn")
