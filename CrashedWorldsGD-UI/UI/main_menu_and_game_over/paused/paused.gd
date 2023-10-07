extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_resume")

func _resume() -> void:
	grab_focus()
	hide()
	get_parent().get_tree().paused = false

func pause() -> void:
	show()

func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),  value)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Soundtrack"),  value)
