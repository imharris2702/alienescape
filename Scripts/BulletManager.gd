extends Node2D

# Spawns and sets direction of bullet
func handle_bullet_spawned(bullet, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
