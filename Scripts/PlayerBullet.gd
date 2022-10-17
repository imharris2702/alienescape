extends Area2D
class_name PlayerBullet

export (int) var speed = 10

onready var kill_timer = $KillTimer

var direction := Vector2.ZERO

# Starts timer on bullet spawn
func _ready():
	kill_timer.start()
	
func _init():
	pass
	#rotation = RandomNumberGenerator.new().randi_range(0, 20) #doesnt work for some reason

# Sets bullet velocity and direction
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity
		rotation += 15

func set_direction(direction: Vector2):
	self.direction = direction
	# TODO: Set rotation with reticule when that is set up

# Removes bullet from memory on timeout (can adjust time)
func _on_KillTimer_timeout():
	queue_free()
