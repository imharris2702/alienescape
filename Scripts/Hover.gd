extends Node


func _physics_process(delta: float) -> void:
	self.position.y += sin(Time.get_ticks_msec() / 100) / 10
	return
