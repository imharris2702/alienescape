extends Node2D

var shouldDrop: bool = false
var isDropped: bool = false
var ufoMoved: bool = false

onready var ufowcow = $UFOwCow
onready var timer = $Timer
onready var player = $Player
onready var timer2 = $Timer2
onready var player_anim = $PlayerAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.has_blaster = false
	player.blaster_sprite.visible = false
	player.isDead = true
	ufowcow.connect("beam_player_up", self, "beamPlayerUp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer2.is_stopped() and !ufoMoved:
		ufowcow.moveUFO()
		ufoMoved = true
	if isDropped:
		return
	if timer.is_stopped() and !isDropped:
		shouldDrop = true
	if shouldDrop:
		ufowcow.dropCow()
		isDropped = true
		shouldDrop = false
		
func beamPlayerUp():
	player_anim.play("BeamUp")

func _on_PlayerAnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "BeamUp":
		player.visible = false
		ufowcow.moveUFOUp()
		
