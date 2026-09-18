#extend the state for death node
extends State

#changing the state
func enter():
	
	#calls function from a parent node
	super.enter()
	
	#plays death animation
	animation_player.play("death")
	
#function for playing a text
func boss_slained():
	
	#play boss_slained text
	animation_player.play("boss_slained")
