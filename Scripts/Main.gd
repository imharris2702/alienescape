extends Node2D

onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemies = $Enemies #Connected to group node to maybe get all enemy shooting calls
onready var gui = $GUI # grabs gui
onready var starting_area = $StartingArea
onready var camera = $Player/Camera2D
onready var ground = $Ground
onready var pathfinding = $Pathfinding
onready var music_loop = $CombatLoop
onready var intro_music = $Intro
onready var game_over = $GameOver

# Called when the node enters the scene tree for the first time.
func _ready():
	# Randomizes random number seed so that patrol states are randomized
	randomize()
	
	# Code for bullet managers needs to be copied every level
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	
	# Connects gui to player
	gui.set_player(player)
	
	for enemy in enemies.get_children():
		enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
		enemy.ai.pathfinding = pathfinding
		
	starting_area.connect("shake_camera", camera, "shake")
	player.connect("shake_camera", camera, "shake")
	
	# Connects ground tilemap to pathfinding algorithm
	pathfinding.create_navigation_map(ground)
	
	intro_music.play()
	
	# FOR OPENING LEVEL ONLY
	player.has_blaster = false
	player.set_blaster_sprite(false)


func _on_Exit_area_area_entered(area):
	if area.is_in_group("player"):
		music_loop.stop()
		


func _on_Intro_finished():
	if !player.isDead:
		music_loop.play()


func _on_Player_player_died():
	intro_music.stop()
	music_loop.stop()
	if !game_over.is_playing():
		game_over.play()
