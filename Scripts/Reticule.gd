extends Sprite
class_name Reticule

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta):
	global_position = get_global_mouse_position()

func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.visible = false
