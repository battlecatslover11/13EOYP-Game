extends Node2D

const SPEED = 100.0
var direction = 1.0
var health = 3
@onready var Left_Ray = $RayCastLeft
@onready var Right_Ray = $RayCastRight

func _process(delta):
	if Right_Ray.is_colliding():
		direction = -1
	if Left_Ray.is_colliding():
		direction = 1
		
	position.x += direction * SPEED * delta

func _on_hurtbox_area_entered(area):
	if area == $hitbox: 
		return
	print("hit")
