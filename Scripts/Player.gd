extends KinematicBody2D

export (PackedScene) var Bullet # Allows for bullet to be attached

var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var movespeed : int = 200

onready var end_of_gun = $EndOfGun # get EndOfGun
#onready var animation_tree = $AnimationTree # get the AnimationTree node
#onready var sprite = $Sprite # get the Sprite node

func _ready():
	return
	

func _physics_process(delta):
	# Read input every frame
	read_movement_input()
	#handle_animation(velocity)

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
	
	#Will add animation for player later, may or may not end up using this
"""func handle_animation(velocity: Vector2):
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x) # keep scale positive if moving right
	elif velocity.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1 # make scale negative if moving left
	if velocity.x == 0 and velocity.y == 0:
		animation_tree["parameters/playback"].travel("Idle") # set AnimationTree state to "Idle"
	else:
		animation_tree["parameters/playback"].travel("Run") # set AnimationTree state to "Idle"
	return
	"""
	

func _unhandled_input(event):
	# Handles shooting
	if event.is_action_pressed("shoot"):
		shoot()

# Shooting code, should allow to disconnect before gun is picked up
func shoot():
	var bullet_instance = Bullet.instance()
	add_child(bullet_instance)
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
