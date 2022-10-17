extends KinematicBody2D


# physics vars
var velocity : Vector2 = Vector2()
var direction : Vector2 = Vector2()
var movespeed : int = 20
var bullet_speed : int = 2000
var isDead : bool = false

# animation vars
const player_proximity_distance = 120

onready var animation_tree = $AnimationTree # get the AnimationTree node
onready var sprite = $Sprite # get the Sprite node

func _ready():
	return
	

func _physics_process(_delta):
	if isDead: return
	# Read input every frame
	if false:
		read_movement_input()
	else:
		handle_movement_ai()
	handle_animation()
	
func handle_movement_ai():
	var player_pos = get_parent().get_node("Player").position
	direction  = player_pos - position
	var distance = direction.length()
	if distance <= player_proximity_distance:
		velocity = Vector2.ZERO
		return
	velocity = direction.normalized() * movespeed
	move_and_slide(velocity)

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
	if isDead: return
	if Input.is_physical_key_pressed(16777220):
		print("death should occur")
		animation_tree["parameters/playback"].travel("Death")
		isDead = true
		return
	if velocity.x > 0:
		sprite.scale.x = abs(sprite.scale.x) # keep scale positive if moving right
	elif velocity.x < 0:
		sprite.scale.x = abs(sprite.scale.x) * -1 # make scale negative if moving left
	if velocity.x == 0 and velocity.y == 0:
		animation_tree["parameters/playback"].travel("Idle") # set AnimationTree state to "Idle"
	else:
		animation_tree["parameters/playback"].travel("Run") # set AnimationTree state to "Run"
	return

func take_bullet_damage():
	animation_tree["parameters/playback"].travel("Death")
	$Collider2D.disabled = true # not working
	$HitBoxArea.set_deferred("monitoring", false)
	isDead = true
