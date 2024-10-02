extends Control

func _on_button_pressed() -> void:
	var audio_player = get_node("AudioStreamPlayer")
	if audio_player:
		audio_player.stop()

	get_tree().change_scene_to_file("res://Scenes/game.tscn")
