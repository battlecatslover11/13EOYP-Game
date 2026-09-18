#extend area for attack in the player scritp
extends Area2D

#setting damage variabkle
@export var damage: int = 1

#function checking when body is entered
func _on_area_entered(area):
	
	#if the group is a player it will return
	if area.is_in_group("player") or area.owner is Player:
		return
		
	#target variable
	var target = area.owner if area.owner else area.get_parent()
	
	#if conditions are met the enemy will take damage
	if target and target.has_method("take_damage"):
		
		#target takes damage
		target.take_damage(damage)
		
#function for if body is entered
func _on_body_entered(body):
	
	#if conditions are met the enemy will take damage
	if body != owner and body.has_method("take_damage"):
		body.take_damage(damage)
