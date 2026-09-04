extends CharacterBody2D

class_name Player

@onready var CoyoteTimer = $CoyoteTimer
@onready var JumpBufferTimer = $JumpBufferTimer
var coyote_activate:bool = false

signal health_changed 

const jump_height:float = -330.0
var gravity: float = 12.0
var dashing = false
var dash_buffer = true
var dir: float = 1
var dash_count = 1
var can_slash: bool = true
var knockback_speed = 500
var knockback_power = 25
var is_hurt:bool = false
var enemy_collisions = []
@export var slash_time:float = 0.1
@export var sword_return_time:float = 0.4
@export var weapon_damage:float = 1
@export var max_health = 0
@onready var current_health:int = max_health
@onready var effects = $Effect
@onready var hurt_timer = $HurtTimer 

func ready():
	effects.play("RESET")
	$AnimatedSprite2D/Sword.show_behind_parent = false
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
@onready var death_sprite = $AnimatedSprite2D2

func _physics_process(delta):
	set_physics_process(true)
	var x_input := Input.get_axis("left", "right")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	
	if dashing:
		velocity.x = lerp(velocity.x, dir * dashspeed, velocity_weight)
	else:
		velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if x_input > 0:
		$AnimatedSprite2D/Sword.show_behind_parent = false
		dir = 1
		$AnimatedSprite2D/flip_anim.play("look_left")
		flip.flip_h = false

	elif x_input < 0:
		$AnimatedSprite2D/Sword.show_behind_parent = true
		dir = -1
		$AnimatedSprite2D/flip_anim.play("look_right")
		flip.flip_h = true
		
	if $Attack_Cooldown.is_stopped():
		can_slash = true	
	
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
	
	if Input.is_action_just_pressed("attack") and can_slash and dir < 0:
		$AnimatedSprite2D/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Sword/AnimationPlayer.get_animation("Sword_Swing").length / slash_time
		$AnimatedSprite2D/Sword/AnimationPlayer.play("Sword_Swing") 
		$Attack_Cooldown.start()
		can_slash = false	
	elif Input.is_action_just_pressed("attack") and can_slash and dir > 0:
		$AnimatedSprite2D/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Sword/AnimationPlayer.get_animation("Flip_Sword_Swing").length / slash_time
		$AnimatedSprite2D/Sword/AnimationPlayer.play("Flip_Sword_Swing") 
		$Attack_Cooldown.start()
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
		$Attack_Cooldown.start()
	else:
		can_slash = true
	if anim_name == "Flip_Sword_Swing":
		$AnimatedSprite2D/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Sword/AnimationPlayer.get_animation("Flip_Sword_Return").length / sword_return_time
		$AnimatedSprite2D/Sword/AnimationPlayer.play("Flip_Sword_Return")
		$Attack_Cooldown.start()
	else:
		can_slash = true
	
func _on_hurtbox_area_entered(area):
	if is_hurt:
		return
	if area.name == "hurtbox":
		enemy_collisions.append(area)
		current_health -= 1
		if current_health <= 0:
			set_physics_process(false)
			death_sprite.play("explode")
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://MenuAssets/death_menu.tscn")
			current_health = 3
		health_changed.emit(current_health)
		is_hurt = true
			
		knockback()
		effects.play("hurt_blink")
		hurt_timer.start()
		await hurt_timer.timeout
		effects.play("RESET")
		is_hurt = false
		
func knockback():
	velocity.x = knockback_speed
	var knockback_direction = velocity.x * -dir
	velocity.x = knockback_direction
	move_and_slide()


func _on_hurtbox_area_exited(area):
	enemy_collisions.erase(area)
	


func _on_attack_cooldown_timeout():
	can_slash = true
