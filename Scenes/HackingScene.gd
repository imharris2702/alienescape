extends Node2D

export var t1: int = 4
export var t2: int = 5
export var t3: int = 8

var transition_times
var t_i = 0
var anims = ["Idle", "ButtonPress", "Hacking"]
var START_TIME

onready var animation_playback = $AnimationTree["parameters/playback"] # get the AnimationTree node


func _ready() -> void:
	transition_times = [t1, t2, t3, 20]
	START_TIME = Time.get_ticks_msec() * .001


func _process(delta: float) -> void:
	var cT = transition_times[t_i]
	if Time.get_ticks_msec() * .001 - START_TIME > cT:
		t_i+=1
		if transition_times[t_i] == 20:
			get_tree().change_scene("res://Scenes/Main.tscn")
		else:
			animation_playback.travel(anims[t_i])
