extends VBoxContainer

@export var gameplay_scene:PackedScene
@onready var gridMap = get_parent().get_parent().get_node("SubViewport/MenuBackground/GridMap")

signal regenerate

func _ready() -> void:
	$MarginContainer/Start.grab_focus()
	connect("regenerate", gridMap.generateMap)
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_biome_button_item_selected(index:int) -> void:
	GameOptions.biomeIndex = index
	regenerate.emit()

func _on_size_button_item_selected(index):
	GameOptions.worldSize = 256 + index * 200
