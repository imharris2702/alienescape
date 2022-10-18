extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)

export (PackedScene) var Bullet # Allows for bullet to be attached

# physics vars
var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var movespeed : int = 8
var isDead : bool = false

# animation vars
const player_proximity_distance = 120

onready var animation_playback = $AnimationTree["parameters/playback"] # get the AnimationTree node
onready var sprite = $Sprite # get the Sprite node
onready var end_of_gun = $EndOfGun # get EndOfGun
onready var attack_cooldown = $AttackCooldown

func _ready():
	return
	

func _physics_process(_delta):
	if isDead: return
	handle_movement_ai()
	handle_animation()
	
func handle_movement_ai():
	var player_pos = get_tree().current_scene.get_node("Player").position
	direction  = player_pos - position
	var distance = direction.length()
	if distance <= player_proximity_distance:
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
		sprite.scale.x = abs(sprite.scale.x) # keep scale positive if moving right
		sprite.position.x = abs(sprite.position.x)
	elif velocity.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1 # make scale negative if moving left
		sprite.position.x = abs(sprite.position.x) * -1
	if velocity.x == 0 and velocity.y == 0:
		animation_playback.travel("Idle") # set AnimationTree state to "Idle"
	else:
		animation_playback.travel("Run") # set AnimationTree state to "Run"
	return

func take_bullet_damage():
	pass
	
func die():
	animation_playback.travel("Death")
	$Collider2D.set_deferred("disabled", true)
	$HitBoxArea/HitBox.set_deferred("disabled", true)
	z_index -= 1
	isDead = true
	
func shoot():
	if attack_cooldown.is_stopped():
		animation_playback.travel("Shoot")
		var bullet_instance = Bullet.instance()
		bullet_instance.scale.x = .1
		bullet_instance.scale.y = .1
		var target = get_tree().current_scene.get_node("Player").position
		# Bullet fires in the direction of the mouse
		var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
		emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)
		attack_cooldown.start()
