extends CanvasLayer

onready var health_bar = $MarginContainer/Rows/TopRow/HealthSection/HealthBar
onready var health_tween = $MarginContainer/Rows/TopRow/HealthSection/HealthTween

var player

func set_player(player):
	self.player = player
	set_new_health_value(player.health.health)
	player.connect("player_health_changed", self, "set_new_health_value")

func set_new_health_value(new_health: int):
	var original_color = Color("#0bbe03")
	var highlight_color = Color("#a2d79e")
	var bar_style = health_bar.get("custom_styles/fg")
	health_tween.interpolate_property(health_bar, "value", health_bar.value, new_health, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	health_tween.interpolate_property(bar_style, "bg_color", original_color, highlight_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", highlight_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	health_tween.start()