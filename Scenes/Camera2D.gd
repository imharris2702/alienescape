extends Camera2D


var shake_amount = 0
var shake_time = 0

var noise = OpenSimplexNoise.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_time > 0:
		self.set_offset(Vector2( \
		rand_range(-1.0, 1.0) * shake_amount, \
		rand_range(-1.0, 1.0) * shake_amount \
		))
		shake_time -= delta
	else:
		self.set_offset(Vector2.ZERO)

func shake(shake_time, shake_amount):
	self.shake_time = shake_time
	self.shake_amount = shake_amount
