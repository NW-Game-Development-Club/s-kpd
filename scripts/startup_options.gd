extends Control

# This adds button funcionality for the back and singleplayer button


# When back button is pressed it goes back to the mainMenu Scene.
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")

# When the singleplauer button is pressed it plays testLevel Scene.
func _on_singleplayer_pressed() -> void:
	print("Changing to test")
	get_tree().change_scene_to_file("res://scenes/testLevel.tscn")
