#extends panel for heart gui script
extends Panel

#sets sprite as a variable
@onready var sprite = $Sprite2D

#function that updates the heart conditiom
func update(whole: bool):
	if whole: 
		
		#changes sprite to be damaged hearts
		sprite.frame = 0
	else: 
		
		#changes sprite to be normal hearts
		sprite.frame = 1
