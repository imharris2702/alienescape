extends Node2D

signal state_changed(new_state)

onready var player_detection_zone = $PlayerDetectionZone
onready var patrol_timer = $PatrolTimer

export (int) var player_idle_distance = 120
export (int) var player_shoot_distance = 120

enum State {
	PATROL,
	ENGAGE
}

var current_state: int = State.PATROL setget set_state
var actor: KinematicBody2D = null

#Engage State vars
var player: Player = null

#Patrol state vars
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = true

func _physics_process(delta):
	if actor.isDead:
		return
	match current_state:
		State.PATROL:
			if !patrol_location_reached:
				actor.move_and_slide(actor.velocity)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor.velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if player != null:
				var direction: Vector2 = player.position - actor.position
				if direction.length() <= player_idle_distance:
					actor.velocity = Vector2.ZERO
				else:
					actor.velocity = direction.normalized() * actor.movespeed
					actor.move_and_slide(actor.velocity)
				if direction.length() < player_shoot_distance and !player.isDead:
					actor.shoot(player)
			else:
				print("In engage state but no player")
		_:
			print("Error: in state that shouldn't exist")

func initialize(actor):
	self.actor = actor;
	origin = actor.global_position
	patrol_timer.start()

func set_state(new_state: int):
	if new_state == current_state:
		return
	if new_state == State.PATROL:
		origin = actor.global_position
		patrol_timer.start()
	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PlayerDetectionZone_body_entered(body: Node):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body


func _on_PatrolTimer_timeout():
	var patrol_range = 50
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor.velocity = actor.global_position.direction_to(patrol_location) * actor.movespeed
