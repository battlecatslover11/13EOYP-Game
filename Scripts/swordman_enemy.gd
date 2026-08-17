extends Area2D

const SPEED = 100.0
var direction = -1.0

func _process(delta):
	position.x += direction * SPEED * delta

func _on_timer_timeout():
	direction *= -1

	
