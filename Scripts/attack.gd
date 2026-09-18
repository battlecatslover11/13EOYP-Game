#extends state for attack state
extends State

#variable for whether attacking is true
var is_attack: bool = false

#function to enter state
func enter():
	
	#access function from parent node
	super.enter()
	
	#calls the attack function
	attack()

#attack function
func attack():
	
	#enemy is allowed to attack
	is_attack = true
	
	#animation speed
	animation_player.speed_scale = 5
	
	#play attack animation
	animation_player.play("attack1")
	
	#waits for animation to finish
	await animation_player.animation_finished 
	
	#disables attack
	is_attack = false
	
#function for transitions between states
func transition():
	
	#if enemy is still attack prevents transition
	if is_attack:
		return
		
	#if player leaves a certain radius state changes to follow
	if owner.direction.length() > 40:
		
		#change state to follow
		get_parent().change_state("Follow")
	else:
		
		#calls attack function
		attack()
