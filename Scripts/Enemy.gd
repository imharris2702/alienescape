extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)

export (PackedScene) var Bullet # Allows for bullet to be attached

# physics vars
var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var movespeed : int = 20
var isDead : bool = false

# AI vars
const PLAYER_IDLE_DISTANCE = 120
const PLAYER_SHOOT_DISTANCE = 120

onready var animation_playback = $AnimationTree["parameters/playback"] # get the AnimationTree node
onready var sprite = $Sprite # get the Sprite node
onready var end_of_gun_left = $EndOfGunL # get EndOfGunL
onready var end_of_gun_right = $EndOfGunR # get EndOfGunR
onready var attack_cooldown = $AttackCooldown
onready var health = $Health

func _ready():
	return
	

func _physics_process(_delta):
	if isDead: return
	handle_movement_ai()
	handle_animation()
	if can_shoot():
		shoot()
	
func distance_to_player():
	var player_pos = get_tree().current_scene.get_node("Player").position
	direction  = player_pos - position
	return direction.length()
	
func handle_movement_ai():
	if distance_to_player() <= PLAYER_IDLE_DISTANCE:
		velocity = Vector2.ZERO
		return
	velocity = direction.normalized() * movespeed
	move_and_slide(velocity)
	
func handle_animation():
	if isDead: return
	if Input.is_physical_key_pressed(16777220):
		die()
		return
	if velocity.x > 0:
		sprite.flip_h = true # flip sprite to right
	elif velocity.x < 0:
		sprite.flip_h = false # Keep sprite looking left
	if velocity.x == 0 and velocity.y == 0:
		animation_playback.travel("Idle") # set AnimationTree state to "Idle"
	else:
		animation_playback.travel("Run") # set AnimationTree state to "Run"
	return

func take_bullet_damage():
	health.health -= 1
	if health.health == 0:
		die()

func die():
	animation_playback.travel("Death")
	$Collider2D.set_deferred("disabled", true)
	$HitBoxArea/HitBox.set_deferred("disabled", true)
	z_index -= 1
	isDead = true
	
func can_shoot():
	return attack_cooldown.is_stopped() and distance_to_player() < PLAYER_SHOOT_DISTANCE

func shoot():
	animation_playback.travel("Shoot")
	var bullet_instance = Bullet.instance()
	var target = get_tree().current_scene.get_node("Player").position
	# Bullet fires in the direction of the mouse
	if target.x > self.position.x:
		sprite.flip_h = true
		var direction_to_mouse = end_of_gun_right.global_position.direction_to(target).normalized()
		emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun_right.global_position, direction_to_mouse)
	else:
		sprite.flip_h = false
		var direction_to_mouse = end_of_gun_left.global_position.direction_to(target).normalized()
		emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun_left.global_position, direction_to_mouse)
	attack_cooldown.start()
	
