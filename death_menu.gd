extends Control

func _on_continue_button_pressed():
	get_tree().change_scene_to_file("res://Main_Scene.tscn")
	
func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://MenuAssets/Title_Screen.tscn")
