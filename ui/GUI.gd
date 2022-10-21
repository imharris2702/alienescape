extends CanvasLayer

onready var health_bar = $MarginContainer/Rows/TopRow/HealthSection/HealthBar
onready var health_tween = $MarginContainer/Rows/TopRow/HealthSection/HealthTween
onready var death_vignette = $DeathVignette.material
onready var death_tween = $DeathVignette/DeathTween

var original_color = Color("#0bbe03")
var highlight_color = Color("#a2d79e")
var vignette_color = Color('#961919')
var player

func set_player(player):
	self.player = player
	set_new_health_value(player.health.health)
	player.connect("player_health_changed", self, "set_new_health_value")
	

func set_new_health_value(new_health: int):
	var bar_style = health_bar.get("custom_styles/fg")
	health_tween.interpolate_property(health_bar, "value", health_bar.value, new_health, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	health_tween.interpolate_property(bar_style, "bg_color", original_color, highlight_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", highlight_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	health_tween.start()
#	if new_health <= 0:
#		print('death tween start')
#		death_tween.targeting_method()
		
func _physics_process(delta):
	if player.isDead and death_vignette.get_shader_param("multiplier") > -.3:
		death_vignette.set_shader_param("multiplier", death_vignette.get_shader_param("multiplier") - .01)
		death_vignette.set_shader_param("softness", death_vignette.get_shader_param("softness") - .001)


#func _on_DeathTween_tween_step(object: Object, key: NodePath, elapsed: float, value: Object) -> void:
#	print("death tween step called")
#	death_vignette.material.set_shader_param("multiplier", death_vignette.get_material().get_shader_param("multiplier") - .01)
