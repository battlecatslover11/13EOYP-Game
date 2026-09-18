#extends control for option menu script
extends Control

#variables for volumes and the labels
@onready var volume = 100
@onready var VolumeLabel = $Volume

#function on volume value changed
func _on_volume_value_changed(value):
	
	#changes volume to set value
	AudioServer.set_bus_volume_db(0, value)
	print(value)

#function that changes the resolution
func _on_resolution_button_item_selected(index):
	
	#changes resolution based on the selected option
	match index:
		0	:
			DisplayServer.window_set_size(Vector2i(1600,900))	
		1:
			DisplayServer.window_set_size(Vector2i(1280,720))

#function for return button pressed
func _on_return_button_pressed():
	
	#changes scene to title screen
	get_tree().change_scene_to_file("res://MenuAssets/Title_Screen.tscn")

#function that gets the values of the volume slider
func _on_volume_slider_value_changed(volume):
	
	#changes text to volume
	VolumeLabel.text = str(int(volume))
	
	
