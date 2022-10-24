extends Node2D

signal beam_player_up()

var shouldDrop: bool = false
var isDropped: bool = false

onready var ufo_beam = $"Alienship/UfoBeam-Sheet"
onready var cow_animation_player = $"Cow-Sheet/AnimationTree"["parameters/playback"]
onready var ufo_animation_player = $Alienship/UFOAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ufo_beam.set_deferred("visible", true)
	
func dropCow():
	ufo_beam.set_deferred("visible", false)
	cow_animation_player.travel("Death")
	
func moveUFO():
	ufo_animation_player.play("MoveUFO")


func _on_UFOAnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "MoveUFO":
		ufo_beam.set_deferred("visible", true)
		emit_signal("beam_player_up")
	if anim_name == "MoveUFOUp":
		get_tree().change_scene("res://Scenes/ExitScene.tscn")
		
func moveUFOUp():
	ufo_animation_player.play("MoveUFOUp")
	ufo_beam.set_deferred("visible", false)
	
