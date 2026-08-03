extends Control

var volume = 100
@onready var VolumeLabel = $Volume

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	print(value)

func _on_resolution_button_item_selected(index):
	match index:
		0	:
			DisplayServer.window_set_size(Vector2i(1600,900))	
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://Title_Screen.tscn")

func _on_volume_slider_value_changed(value):
	VolumeLabel.textContent = value
	
	
