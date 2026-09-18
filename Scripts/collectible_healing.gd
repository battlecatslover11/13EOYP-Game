#extends area for healing
extends Area2D

#function for checkig area entered
func _on_body_entered(_body):
	
	#hides healing item
	queue_free()
