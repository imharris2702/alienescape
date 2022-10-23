extends Area2D
class_name PlayerBullet

export (int) var speed = 5

onready var kill_timer = $KillTimer

var direction := Vector2.ZERO

# Starts timer on bullet spawn
func _ready():
	kill_timer.start()

# Sets bullet velocity and direction
func _physics_process(delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	self.rotation = direction.angle()

# Removes bullet from memory on timeout (can adjust time)
func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_area_entered(area):
	if area.is_in_group("enemy"):
		$AnimationPlayer.play("Explode")
		$Collider.set_deferred("disabled", true)
		direction *= .03 # keep momentum slightly


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()


func _on_Bullet_body_entered(body):
	if !body.is_in_group("player") and !body.is_in_group("enemy"):
		$AnimationPlayer.play("Explode")
		$Collider.set_deferred("disabled", true)
		direction *= .03 # keep momentum slightly
