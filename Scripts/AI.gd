extends Node2D

signal state_changed(new_state)

onready var player_detection_zone = $PlayerDetectionZone

export (int) var player_idle_distance = 120
export (int) var player_shoot_distance = 120

enum State {
	PATROL,
	ENGAGE
}

var current_state: int = State.PATROL setget set_state
var player = null
var actor = null

func _process(delta):
	if actor == null:
		print("Error: no enemy")
	if actor.isDead:
		return
	match current_state:
		State.PATROL:
			pass
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

func set_state(new_state: int):
	if new_state == current_state:
		return
	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PlayerDetectionZone_body_entered(body: Node):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
