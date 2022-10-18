extends Node2D

# Spawns and sets direction of bullet
func handle_bullet_spawned(bullet, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)
	# couldn't get enemy bullets to despawn so I just added this as a hacky solution
	if get_child_count() >= 100:
		get_children()[0].queue_free()
