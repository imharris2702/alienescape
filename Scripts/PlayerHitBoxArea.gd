extends Area2D

func _on_HitBoxArea_area_entered(area):
	if area.is_in_group("bullet"):
		get_parent().take_bullet_damage()
	elif area.is_in_group("blaster"):
		get_parent().pickup_blaster()
