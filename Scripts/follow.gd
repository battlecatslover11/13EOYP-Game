#extends the follow state
extends State

#entering a new state
func enter():
	
	#calls function from a parent node
	super.enter()
	
	#allows physics process
	owner.set_physics_process(true)
	
	#plays idle animation
	animation_player.play("idle")
	
#function to exit the state
func exit():
	
	#call exit state through parent node
	super.exit()
	
	#disables physics
	owner.set_physics_process(false)

#function for the change between states
func transition():
	
	#checks distance of enemy 
	if owner.direction.length() < 40:
		
		#changes state if conditions are met
		get_parent().change_state("Attack")
