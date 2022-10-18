extends Node2D

onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemy = $Enemies #Connected to group node to maybe get all enemy shooting calls

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
