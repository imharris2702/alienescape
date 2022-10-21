extends Node2D

signal state_changed(new_state)

onready var player_detection_zone = $PlayerDetectionZone

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
	match current_state:
		State.PATROL:
			if player != null:
				pass
			else:
				print("In engage state but no player")
		State.ENGAGE:
			pass
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
