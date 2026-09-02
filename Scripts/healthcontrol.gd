extends Node2D

var health:int 
var max_health:int 

func take_damage(amount: int):
	health -= amount
