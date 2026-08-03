extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Main_Scene.tscn")

func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://Option_Menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
	
