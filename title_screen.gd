extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Main_Scene.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
	

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	print(value)


func _on_resolution_item_selected(index):
	match index:
		0	:
			DisplayServer.window_set_size(Vector2i(1600,900))	
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))
