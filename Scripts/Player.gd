extends KinematicBody2D
class_name Player

signal player_fired_bullet(bullet, position, direction)
signal player_health_changed(new_health)
signal shake_camera(shake_time, shake_amount)
signal player_died()

export (PackedScene) var Bullet # Allows for bullet to be attached

# physics vars
var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var movespeed : int = 150

# general
var has_blaster : bool = true
var isDead : bool = false

# animation vars
var idle_counter = 20
var isIdle : bool = true


onready var end_of_gun = $EndOfGun # get EndOfGun
onready var animation_playback = $AnimationTree["parameters/playback"] # get the AnimationTree node
onready var sprite = $Sprite # get the Sprite node
onready var attack_cooldown = $AttackCooldown
onready var blaster_sprite = get_node("Sprite/BlasterSprite")
onready var health = $Health # Get health node
onready var health_regen = $HealthRegenCooldown
onready var reticule = $Reticule

func _ready():
	#blaster_sprite.visible = has_blaster
	pass


func _physics_process(delta):
	if isDead: return
	# Read input every frame
	read_input()
	handle_animation()
	

func read_input():
	# Handles movement
	velocity = Vector2()
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
		
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
		
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = Vector2(-1, 0)
		
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
		
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * movespeed)

	if Input.is_action_pressed("shoot"):
		shoot()
	
func handle_animation():
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x) # keep scale positive if moving right
		$EndOfGun.position.x = abs($EndOfGun.position.x)
	elif velocity.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1 # make scale negative if moving left
		$EndOfGun.position.x = abs($EndOfGun.position.x) * -1
	if velocity.x == 0 and velocity.y == 0:
		if idle_counter % 250 == 0 and !has_blaster:
			animation_playback.travel("Idle1") # set AnimationTree state to "Idle1"
		elif isIdle == false:
			animation_playback.travel("IdleWGun") if has_blaster else animation_playback.travel("Idle")# set AnimationTree state to "Idle"
			isIdle = true
		idle_counter += 1
	else:
		animation_playback.travel("RunWGun") if has_blaster else animation_playback.travel("Run") # set AnimationTree state to "Run"
		isIdle = false
	return

func _unhandled_input(event):
	pass
	# Handles shooting

# Shooting code, should allow to disconnect before gun is picked up
func shoot():
	if attack_cooldown.is_stopped() and has_blaster:
		emit_signal("shake_camera", .05, 1)
		var bullet_instance = Bullet.instance()
		var target = get_global_mouse_position()
		# Bullet fires in the direction of the mouse
		var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)
		attack_cooldown.start()
		$ShootSound.play()

func take_bullet_damage():
	health.health -= 10
	emit_signal("player_health_changed", health.health)
	emit_signal("shake_camera", .1, 2)
	if health.health == 0:
		die()
	else:
		health_regen.start()
	

func die():
	animation_playback.travel("Death")
	isDead = true
	blaster_sprite.visible = false
	emit_signal("player_died")
	reticule.show_mouse()

func pickup_blaster():
	has_blaster = true
	blaster_sprite.visible = true

func set_blaster_sprite(input: bool):
	if input:
		blaster_sprite.visible = true
	else:
		blaster_sprite.visible = false


func _on_HealthRegenCooldown_timeout():
	health.health += 10
	emit_signal("player_health_changed", health.health)
	if health.health != 100:
		health_regen.start()
