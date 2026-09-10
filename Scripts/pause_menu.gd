extends Control

func _ready():
	visible = false
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	visible = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	visible = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	resume()
	get_tree().change_scene_to_file("res://MenuAssets/Title_Screen.tscn")
	
func _process(delta):
	testEsc()
	
func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
