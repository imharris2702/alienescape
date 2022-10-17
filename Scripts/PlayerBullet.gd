extends Area2D
class_name PlayerBullet

export (int) var speed = 5

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

func set_direction(direction: Vector2):
	self.direction = direction
	self.rotation = direction.angle()
	# TODO: Set rotation with reticule when that is set up

# Removes bullet from memory on timeout (can adjust time)
func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_area_entered(area):
	if !area.is_in_group("player"):
		$AnimationPlayer.play("Explode")
		$Collider.set_deferred("disabled", true)
		direction *= .03 # keep momentum slightly


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()
