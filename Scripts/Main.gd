extends Node2D

onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemies = $Enemies #Connected to group node to maybe get all enemy shooting calls
onready var gui = $GUI # grabs gui

# Called when the node enters the scene tree for the first time.
func _ready():
	# Code for bullet managers needs to be copied every level
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	
	for enemy in enemies.get_children():
		enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	
	# FOR OPENING LEVEL ONLY
	player.has_blaster = false
