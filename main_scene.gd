extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player

func _ready():
	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(1)
