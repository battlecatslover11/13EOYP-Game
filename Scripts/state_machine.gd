#extends node2d to state machine script
extends Node2D

#sets the current state for current and previous states
var current_state: State
var previous_state: State

#ready function
func _ready():
	
	#calls first state before change previous state to current state
	current_state = get_child(0) as State
	previous_state = current_state
	
	#enters the current state
	current_state.enter()

#function to change state
func change_state(state):
	
	#changes state depending on child state
	current_state = find_child(state) as State
	current_state.enter()
	
	#exits previous state and changes it to current state
	previous_state.exit()
	previous_state = current_state
