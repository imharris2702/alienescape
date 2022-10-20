extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	get_tree().change_scene("res://Scenes/HackingScene.tscn")
	
	
func _input(event: InputEvent) -> void:
	event.is_action_pressed("skip")
