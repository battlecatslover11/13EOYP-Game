extends CharacterBody2D

@onready var CoyoteTimer = $CoyoteTimer
@onready var JumpBufferTimer = $JumpBufferTimer
var coyote_activate:bool = false

const jump_height:float = -330.0
var gravity: float = 12.0
var dashing = false
var dash_buffer = true
var dir: float = 0
var dash_count = 1
var player_health = 3
var can_slash: bool = true
@export var slash_time:float = 0.1
@export var sword_return_time:float = 0.4
@export var weapon_damage:float = 1

var wallcontact_coyote: float = 0.0
const wallcontact_coyotetime: float = 0.2

const max_gravity:float = 14.5
const max_speed:float = 160
const wall_gravity: float = 8.5
const walljump_force: float = 100.0
const acceleration:float = 16
const friction:float = 8
const wall_friction:float = 22.5
const dashspeed = 420
@onready var flip = $AnimatedSprite2D

func _physics_process(delta):
	var x_input := Input.get_axis("left", "right")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	
	if dashing:
		velocity.x = lerp(velocity.x, dir * dashspeed, velocity_weight)
	else:
		velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if x_input > 0:
		dir = 1
		flip.flip_h = false

	elif x_input < 0:
		dir = -1
		flip.flip_h = true
	
		
	if is_on_floor():
		coyote_activate = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
		dash_count = 1
		
		gravity = lerp(gravity, max_gravity, 12.0 * delta)
		
		if dashing:	
			velocity.y = 0
	else:
		if CoyoteTimer.is_stopped() and !coyote_activate:
			CoyoteTimer.start()
			coyote_activate = true
			
	if Input.is_action_just_released("jump") or is_on_ceiling():
			velocity.y *= 0.5
					
	if Input.is_action_just_pressed("jump"):
		if JumpBufferTimer.is_stopped():
			JumpBufferTimer.start()
	
	if Input.is_action_just_pressed("attack") and can_slash:
		$AnimatedSprite2D/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Sword/AnimationPlayer.get_animation("Sword_Swing").length / slash_time
		$AnimatedSprite2D/Sword/AnimationPlayer.play("Sword_Swing") 
		can_slash = false	
	
	if Input.is_action_just_pressed("dash") and dash_buffer and dash_count == 1:
		dashing = true
		dash_buffer = false 
		dash_count = 0
		$DashTimer.start()
		$DashTimer2.start()
		
	if !JumpBufferTimer.is_stopped() and (!CoyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = jump_height
		JumpBufferTimer.stop()
		CoyoteTimer.stop()
		coyote_activate = true
				
	velocity.y += gravity
	move_and_slide()

func _on_dash_timer_timeout():
	dashing = false

func _on_dash_timer_2_timeout():
	dash_buffer = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Sword_Swing":
		$AnimatedSprite2D/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Sword/AnimationPlayer.get_animation("Sword_Return").length / sword_return_time
		$AnimatedSprite2D/Sword/AnimationPlayer.play("Sword_Return")
	else:
		can_slash = true
