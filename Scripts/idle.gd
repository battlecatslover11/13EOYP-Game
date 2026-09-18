#extends state for idle script
extends State

#variable for hitbox
@onready var collision = $"../../PlayerDetection/CollisionShape2D"

#variable for progress bar
@onready var progress_bar = owner.find_child("ProgressBar")

var player_entered: bool = false:
	set(value):
		player_entered = value
		collision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)
		
func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		self.player_entered = true
		
func enter():
	super.enter()
	
func transition():
	if player_entered:
		get_parent().change_state("Follow")
	
