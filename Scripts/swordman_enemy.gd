#extends body to enemy script
extends CharacterBody2D

#setting up all the constants and variable required for swordsman
const SPEED = 100.0
var dir = 1
var direction : Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const max_gravity:float = 14.5
@onready var sprite = $AnimatedSprite2D
@onready var progress_bar = $UI/ProgressBar
@onready var player = get_parent().find_child("player")
@onready var Left_Ray = $RayCastLeft
@onready var Right_Ray = $RayCastRight

#variable for maximum amount of health and changing the value depending
#on the conditions
var max_health: int = 10:
	set(value):
		max_health = value
		progress_bar.value = value
		if $HP:
			$HP.max_value = value
			
#current health and if health is below or equal to zero then changes state to death
var health: int = 10:
	set(value):
		health = value
		progress_bar.value = value
		if $HP:
			$HP.value = value
		if value <= 0:
			if $HP:
				$HP.visible = false
			find_child("FiniteStateMachine").change_state("Death")

#function for setting max health
func set_max_health(value: int):
	
	#setting the max health
	max_health = value
	$HP.max_value = value

#first called function
func _ready():
	
	#disable physics process
	set_physics_process(false)
	
	#defines player
	player = get_tree().get_first_node_in_group("player")

#function for taking damage
func take_damage(amount: int = 1):
	
	#reduces health by a certain amount
	health -= amount	 	

#function for process
func _process(_delta):
	
	#finds player location
	direction = player.global_position - global_position
	
	#flips sprite depending on direction
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
#function for hurtbox
func _on_hurtbox_area_entered(area):
	if area == $hitbox: 
		return

#function for physics process
func _physics_process(delta):
	
	#statements for direction and calculting the speed
	if direction != Vector2.ZERO:
		velocity.x = sign(direction.x) * SPEED
	else:
		velocity.x = 0
		
	#applies gravity to enemy
	if is_on_floor():
		gravity = lerp(gravity, max_gravity, 12.0 * delta)
	velocity.y += gravity
	
	#finishes physics process
	move_and_slide()
