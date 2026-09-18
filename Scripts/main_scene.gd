#extends
extends Node2D

#variables for heart gui and player
@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player

#calls the functions for settings the players health
func _ready():
	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(player.current_health)
	player.health_changed.connect(heartsContainer.updateHearts)
