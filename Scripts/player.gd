#extend character body to player script
extends CharacterBody2D

#states the class name
class_name Player

#variables for timers
@onready var CoyoteTimer = $CoyoteTimer
@onready var JumpBufferTimer = $JumpBufferTimer
var coyote_activate:bool = false

#signaling a change in health
signal health_changed 

#setting all the physics and other related variables and constants
const JUMP_HEIGHT:float = -330.0
var gravity: float = 12.0
var dashing = false
var dash_buffer = true
var dir: float = 1
var dash_count = 1
var can_slash: bool = true
var knockback_speed = 750
var knockback_power = 25
var is_hurt:bool = false
var enemy_collisions = []
@export var slash_time:float = 0.1
@export var sword_return_time:float = 0.4
@export var weapon_damage:float = 1
@export var max_health = 3
@onready var current_health:int = max_health
@onready var effects = $Effect
@onready var hurt_timer = $HurtTimer 

#first function called
func _ready():
	
	#resets animation 
	effects.play("RESET")
	$AnimatedSprite2D/Attack/Sword.show_behind_parent = false
	
#more physics related constand and variables
var wallcontact_coyote: float = 0.0
const WALL_CONTACT_COYOTETIME: float = 0.2

const MAX_GRAVITY:float = 14.5
const MAX_SPEED:float = 160
const ACCELERATION:float = 16
const FRICTION:float = 8
const DASH_SPEED = 420
@onready var flip = $AnimatedSprite2D
@onready var death_sprite = $AnimatedSprite2D2

#function for physics process
func _physics_process(delta):
	
	#allows physics process
	set_physics_process(true)
	
	#gets player input
	var x_input := Input.get_axis("left", "right")
	var velocity_weight: float = delta * (ACCELERATION if x_input else FRICTION)
	
	#checks whether player is dashing or not
	if dashing:
		velocity.x = lerp(velocity.x, dir * DASH_SPEED, velocity_weight)
	else:
		velocity.x = lerp(velocity.x, x_input * MAX_SPEED, velocity_weight)
	
	#visual effect for direction
	if x_input > 0:
		$AnimatedSprite2D/Attack/Sword.show_behind_parent = false
		dir = 1
		$AnimatedSprite2D/flip_anim.play("look_left")
		flip.flip_h = false
	
	#flips sprite
	elif x_input < 0:
		$AnimatedSprite2D/Attack/Sword.show_behind_parent = true
		dir = -1
		$AnimatedSprite2D/flip_anim.play("look_right")
		flip.flip_h = true
		
	#checks whether player can attack yet
	if $Attack_Cooldown.is_stopped():
		can_slash = true	
	
	#called if player is on floor
	if is_on_floor():
		
		#disable coyote timer and sets gravity and dash count back to normal
		coyote_activate = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
		dash_count = 1
		
		gravity = lerp(gravity, MAX_GRAVITY, 12.0 * delta)
		
		#prevent player from being affected by gravity when dashing
		if dashing:	
			velocity.y = 0
	
	#else states if previous conditions are unmet
	else:
		
		#sets the coyote timer
		if CoyoteTimer.is_stopped() and !coyote_activate:
			CoyoteTimer.start()
			coyote_activate = true
			
	#checks player jump input
	if Input.is_action_just_released("jump") or is_on_ceiling():
			velocity.y *= 0.5
				
	#sets jump buffer	
	if Input.is_action_just_pressed("jump"):
		if JumpBufferTimer.is_stopped():
			JumpBufferTimer.start()
	
	#checks certain conditions and decides whether player is allowed to attack
	if Input.is_action_just_pressed("attack") and can_slash and dir < 0:
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Attack/Sword/AnimationPlayer.get_animation("Sword_Swing").length / slash_time
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.play("Sword_Swing") 
		$Attack_Cooldown.start()
		can_slash = false	
	
		#checks certain conditions and decides whether player is allowed to attack but flipped
	elif Input.is_action_just_pressed("attack") and can_slash and dir > 0:
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Attack/Sword/AnimationPlayer.get_animation("Flip_Sword_Swing").length / slash_time
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.play("Flip_Sword_Swing") 
		$Attack_Cooldown.start()
		can_slash = false	
	
	#sets dash buffer after dashing to prevent it being spammed
	if Input.is_action_just_pressed("dash") and dash_buffer and dash_count == 1:
		dashing = true
		dash_buffer = false 
		dash_count = 0
		$DashTimer.start()
		$DashTimer2.start()
		
	#checks all the buffers and whether they are finished and stops the timers
	if !JumpBufferTimer.is_stopped() and (!CoyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = JUMP_HEIGHT
		JumpBufferTimer.stop()
		CoyoteTimer.stop()
		coyote_activate = true
		
	#checks whether enemy is colliding but player isn't hurt and then hurts the player
	if enemy_collisions.size() > 0 and not is_hurt:
		take_damage(enemy_collisions[0])
			
	#sets gravity	
	velocity.y += gravity
	
	#starts physics process
	move_and_slide()

#function for dash timeout
func _on_dash_timer_timeout():
	dashing = false

#function for second dash timeout
func _on_dash_timer_2_timeout():
	dash_buffer = true
	
#function for checking animation states
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	#checks the animation name and play its and the reversed version
	if anim_name == "Sword_Swing":
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Attack/Sword/AnimationPlayer.get_animation("Sword_Return").length / sword_return_time
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.play("Sword_Return")
	else:
		
		#allows player to attack
		can_slash = true
		
	#checks the animation name and play its and the reversed version
	if anim_name == "Flip_Sword_Swing":
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.speed_scale = $AnimatedSprite2D/Attack/Sword/AnimationPlayer.get_animation("Flip_Sword_Return").length / sword_return_time
		$AnimatedSprite2D/Attack/Sword/AnimationPlayer.play("Flip_Sword_Return")
	else:
		
		#allows player to attack
		can_slash = true
		
	#prevents player from attacking
	can_slash = false
	
	#starts attack cooldown and waits for timer to finish
	$Attack_Cooldown.start()
	await $Attack_Cooldown.timeout
	
#checks whether player is hurt by enemy and deals with null cases just in case
func take_damage(_enemy = null):
	
	#reduces current health
	current_health -= 1
	
	#if players health is less or equal to zero
	if current_health <= 0:
		
		#prevents player from moving
		set_physics_process(false)
		
		#death animation
		death_sprite.play("explode")
		
		#creates a timer to wait for and then changes to death menu
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
		
		#resets health back to 3
		current_health = 3
	
	#sends signals that health has changed
	health_changed.emit(current_health)
	
	#damage invulerbility
	if is_hurt:
		return
	is_hurt = true
			
	#knockback function
	knockback()
	
	#player flashes red indicating damage
	effects.play("hurt_blink")
	
	#damage invulerbility timer
	hurt_timer.start()
	await hurt_timer.timeout
	
	#resets
	effects.play("RESET")
	
	#hurt state is set to false
	is_hurt = false

#function for entering players hurtbox
func _on_hurtbox_area_entered(area):
	
	#checks area name
	if area.name == "hurtbox":
		
		#removes the collision temporarily
		enemy_collisions.append(area)


#function for knockback
func knockback():
	
	#knock player away from enemy
	velocity.x = knockback_speed
	
	#variable for direction opposite of enemy
	var knockback_direction = velocity.x * -dir
	
	#player x velocity is applied as knockback
	velocity.x = knockback_direction
	move_and_slide()
	
#function on exiting hurtbox
func _on_hurtbox_area_exited(area):
	
	#removes enemy collisions
	enemy_collisions.erase(area)

#function for attack cooldown timeout
func _on_attack_cooldown_timeout():
	
	#allows player to attack
	can_slash = true
	
	
