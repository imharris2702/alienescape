extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)

export (PackedScene) var Bullet # Allows for bullet to be attached

# physics vars
var velocity : Vector2 = Vector2()
var movespeed : int = 16
var isDead : bool = false

onready var animation_playback = $AnimationTree["parameters/playback"] # get the AnimationTree node
onready var sprite = $Sprite # get the Sprite node
onready var end_of_gun_left = $EndOfGunL # get EndOfGunL
onready var end_of_gun_right = $EndOfGunR # get EndOfGunR
onready var attack_cooldown = $AttackCooldown
onready var health = $Health
onready var ai = $AI
onready var death_sound = $DeathSound

func _ready():
	ai.initialize(self)


func _physics_process(_delta):
	if isDead: return
	handle_animation()

func handle_animation():
	if isDead: return
	if Input.is_physical_key_pressed(16777220):
		die()
		return
	if velocity.x > 0:
		sprite.flip_h = true # flips sprite to right
		sprite.position.x = abs(sprite.position.x)
	elif velocity.x < 0:
		sprite.flip_h = false # Keeps sprite looking left
		sprite.position.x = abs(sprite.position.x) * -1
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
	death_sound.play()
	isDead = true

func shoot(target: Node):
	if attack_cooldown.is_stopped():
		animation_playback.travel("Shoot")
		var bullet_instance = Bullet.instance()
		# Bullet fires in the direction of the target
		if target.position.x > self.position.x:
			sprite.flip_h = true
			var direction_to_target = end_of_gun_right.global_position.direction_to(target.global_position).normalized()
			emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun_right.global_position, direction_to_target)
		else:
			sprite.flip_h = false
			var direction_to_target = end_of_gun_left.global_position.direction_to(target.global_position).normalized()
			emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun_left.global_position, direction_to_target)
		attack_cooldown.start()
