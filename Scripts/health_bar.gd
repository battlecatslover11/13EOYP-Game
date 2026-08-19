extends ProgressBar

@export var player: Player

func ready():
	update()

func update():
	value = player.current_health * 10 / player.max_health
	
