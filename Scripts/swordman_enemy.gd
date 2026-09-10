extends CharacterBody2D

const SPEED = 100.0
var direction = 1.0
var health:int = 3
var max_health:int: set = set_max_health
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const max_gravity:float = 14.5
@onready var Left_Ray = $RayCastLeft
@onready var Right_Ray = $RayCastRight

func set_max_health(value: int):
	max_health = value
	$HP.max_value = value

func ready():
	max_health = 50
	$hurtbox/CollisionShape2D.disabled = true
	$hitbox/CollisionShape2D.disabled = true

func take_damage(amount: int):
	health -= amount
	print(health)

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
	
func _physics_process(delta: float) -> void:
	if is_on_floor():
		gravity = lerp(gravity, max_gravity, 12.0 * delta)
	velocity.y += gravity
	move_and_slide()
