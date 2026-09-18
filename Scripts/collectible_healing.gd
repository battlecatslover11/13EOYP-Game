#extends area for healing
extends Area2D

#function for checkig area entered
func _on_body_entered(_body):
	
	#doesn't work at the moment
	print("heal")
	queue_free()
