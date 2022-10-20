extends CanvasLayer

onready var health_bar = $MarginContainer/Rows/TopRow/HealthBar

var player

func set_player(player):
	self.player = player
	set_new_health_value(player.health.health)
	player.connect("player_health_changed", self, "set_new_health_value")

func set_new_health_value(new_health: int):
	health_bar.value = new_health
