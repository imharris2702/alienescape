extends Area2D

func _on_HitBoxArea_area_entered(area):
	if area.is_in_group("player_bullet"):
		get_parent().take_bullet_damage()
