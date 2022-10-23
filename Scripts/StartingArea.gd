extends Node2D

signal shake_camera(shake_time, shake_amount)

export var timeClosed = 2
var cellOpen = false
var START_TIME

onready var animation_player = $AnimationPlayer
onready var lasers = $Cell/StaticBody2D/lasers


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	START_TIME = Time.get_ticks_msec() * .001


func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000 - START_TIME
	if current_time > timeClosed and cellOpen == false:
		emit_signal("shake_camera", .5, 3)
	if current_time > timeClosed and cellOpen == false:
		animation_player.play("Off")
		lasers.set_deferred("disabled", true)
		$Cell/laser1.z_index = -1
		$Cell/laser2.z_index = -1
		cellOpen = true
