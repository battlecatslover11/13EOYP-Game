extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player

func _ready():
	heartsContainer.setMaxHearts(player.max_health)
	heartsContainer.updateHearts(player.current_health)
	player.health_changed.connect(heartsContainer.updateHearts)
