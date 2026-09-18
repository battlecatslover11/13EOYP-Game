#extends hearts container for script
extends HBoxContainer

#loads the heart gui
@onready var HeartGuiClass = preload("res://Scenes/heart_gui.tscn")
	
#function to set the maximum amount of health
func setMaxHearts(max: int):
	
	#loops for amount of health
	for i in range(max):
		
		#creates a variable that store this information
		var heart = HeartGuiClass.instantiate()
		
		#creates one heart gui before repeating
		add_child(heart)

#function to update hearts if damaged
func updateHearts(current_health: int):
	
	#variable for amount of hearts
	var hearts = get_children()
	
	#repeats for the amount of current health
	for i in range(current_health):
		
		#updates hearts depending on current health
		hearts[i].update(true)
		
	#repeats for the amount of current health
	for i in range(current_health, hearts.size()):
		
		#prevents the hearts from changing
		hearts[i].update(false)
