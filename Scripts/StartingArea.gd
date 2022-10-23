extends Node2D

signal shake_camera(shake_time, shake_amount)

export var timeClosed = 1
var cellOpen = false

onready var animation_player = $AnimationPlayer
onready var lasers = $Cell/StaticBody2D/lasers


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Time.get_ticks_msec() / 1000 - .5 > timeClosed and cellOpen == false:
		emit_signal("shake_camera", .5, 3)
	if Time.get_ticks_msec() / 1000 > timeClosed and cellOpen == false:
		animation_player.play("Off")
		lasers.set_deferred("disabled", true)
		$Cell/laser1.z_index = -1
		$Cell/laser2.z_index = -1
		cellOpen = true
