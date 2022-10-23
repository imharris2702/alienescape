extends Node2D

var shouldDrop: bool = false
var isDropped: bool = false

onready var ufo_beam = $"Alienship/UfoBeam-Sheet"
onready var cow_animation_player = $"Cow-Sheet/AnimationTree"["parameters/playback"]
onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ufo_beam.set_deferred("visible", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isDropped:
		return
	if timer.is_stopped() and !isDropped:
		shouldDrop = true
	if shouldDrop:
		dropCow()
		isDropped = true
		shouldDrop = false
	
func dropCow():
	ufo_beam.set_deferred("visible", false)
	cow_animation_player.travel("Death")
	
