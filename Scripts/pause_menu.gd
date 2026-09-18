#extends control to pause menu script
extends Control

#function at the start of the scene
func _ready():
	
	#disables visibility
	visible = false
	
	#reset animation
	$AnimationPlayer.play("RESET")

#function for resume
func resume():
	
	#unpause the scene
	get_tree().paused = false
	
	#menu is made invisible
	visible = false
	
	#transition animation
	$AnimationPlayer.play_backwards("blur")

#function for pausing
func pause():
	
	#pause the scene
	get_tree().paused = true
	
	#makes the menu visible
	visible = true
	
	#transition in
	$AnimationPlayer.play("blur")

#function to open the menu
func testEsc():
	
	#checks whether escape is pressed and pauses
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		
		#calls pause function
		pause()
		
	#checks whether escape is pressed
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		
		#calls resume function
		resume()

#function to resume
func _on_resume_pressed():
	
	#resumes function
	resume()

#function on quit
func _on_quit_pressed():
	
	#resumes the scene
	resume()
	
	#changes the scene to the main menu
	get_tree().change_scene_to_file("res://MenuAssets/Title_Screen.tscn")

#calls function for test escape
func _process(_delta):
	testEsc()
	
#function for reset
func _on_restart_pressed():
	
	#resumes the scene
	resume()
	
	#resets the scene
	get_tree().reload_current_scene()
