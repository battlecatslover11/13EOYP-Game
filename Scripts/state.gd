#extends node for state script
extends Node

#sets class name
class_name State

#variables for debug, player and animation player
@onready var debug = owner.find_child("debug")
@onready var player = owner.get_parent().find_child("player")
@onready var animation_player = owner.find_child("AnimationPlayer")

#first played function
func _ready():
	
	#disable physics process
	set_physics_process(false)

#function for entering
func enter():
	
	#disable physics process
	set_physics_process(true)
	
#function for exit
func exit():
	
	#disable physics process
	set_physics_process(false)

#function for change between states
func transition():
	pass
	
#function for physics process
func _physics_process(_delta):
	
	#transition called
	transition()
	
	#changes debug text
	debug.text = name
	
