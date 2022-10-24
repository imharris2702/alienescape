extends RichTextLabel


var words = "..and that is how Blarg the alien escaped Area 51. The End."
var words_i = 0
var tick = 0
var START_TIME

export var t_start: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	START_TIME = Time.get_ticks_msec() * .001


func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000 - START_TIME
	if current_time > t_start and words_i != len(words) and tick % 4 == 0:
		self.text += (words[words_i])
		words_i+=1
	tick+=1
