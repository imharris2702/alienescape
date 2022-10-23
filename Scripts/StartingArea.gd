extends Node2D

export var timeClosed = 3

onready var animation_player = $AnimationPlayer
onready var lasers = $Cell/StaticBody2D/lasers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Time.get_ticks_msec() / 1000 > timeClosed:
		animation_player.play("Off")
		lasers.set_deferred("disabled", true)
		$Cell/laser1.z_index = -1
		$Cell/laser2.z_index = -1
