extends "res://Scripts/Hover.gd"


func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		queue_free()
