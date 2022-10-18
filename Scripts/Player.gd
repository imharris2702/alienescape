extends KinematicBody2D

signal player_fired_bullet(bullet, position, direction)

export (PackedScene) var Bullet # Allows for bullet to be attached

# physics vars
var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var movespeed : int = 150
var bullet_speed : int = 2000

# animation vars
var idle_counter = 20
var isIdle : bool = true


onready var end_of_gun = $EndOfGun # get EndOfGun
onready var animation_playback = $AnimationTree["parameters/playback"] # get the AnimationTree node
onready var sprite = $Sprite # get the Sprite node
onready var attack_cooldown = $AttackCooldown

func _ready():
	return
	

func _physics_process(delta):
	# Read input every frame
	read_movement_input()
	handle_animation()

func read_movement_input():
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
	
func handle_animation():
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x) # keep scale positive if moving right
		$EndOfGun.position.x = abs($EndOfGun.position.x)
	elif velocity.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1 # make scale negative if moving left
		$EndOfGun.position.x = abs($EndOfGun.position.x) * -1
	if velocity.x == 0 and velocity.y == 0:
		if idle_counter % 250 == 0:
			animation_playback.travel("Idle1") # set AnimationTree state to "Idle1"
		elif isIdle == false:
			animation_playback.travel("Idle") # set AnimationTree state to "Idle"
			isIdle = true
		idle_counter += 1
	else:
		animation_playback.travel("Run") # set AnimationTree state to "Run"
		isIdle = false
	return

func _unhandled_input(event):
	# Handles shooting
	if event.is_action_pressed("shoot"):
		shoot()

# Shooting code, should allow to disconnect before gun is picked up
func shoot():
	if attack_cooldown.is_stopped():
		var bullet_instance = Bullet.instance()
		var target = get_global_mouse_position()
		# Bullet fires in the direction of the mouse
		var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction_to_mouse)
		attack_cooldown.start()
