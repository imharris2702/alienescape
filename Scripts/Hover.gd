extends Node

export var hover_speed: float
export var hover_height: float

var og_height: float

func _ready() -> void:
	og_height = self.position.y

func _process(delta: float) -> void:
	var offset = sin(Time.get_ticks_msec() * .001 * hover_speed) * hover_height
	self.position.y = og_height + offset
