#extends control to death menu script
extends Control

#function on continue button pressed
func _on_continue_button_pressed():
	
	#changes scene to main scene
	get_tree().change_scene_to_file("res://Scenes/Main_Scene.tscn")

#function on exit button pressed
func _on_exit_button_pressed():
	
	#changes to title screen
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")
