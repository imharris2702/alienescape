extends RichTextLabel


var words = "\"Hey! Stop messing with that cow and get me out of here!\""
var words_i = 0
var tick = 0
var START_TIME

export var t_start: float
export var t_end: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	START_TIME = Time.get_ticks_msec() * .001


func _process(delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000 - START_TIME
	if current_time > t_start and current_time < t_end and words_i != len(words) and tick % 4 == 0:
		self.text += (words[words_i])
		words_i+=1
	elif current_time > t_end: 
		self.text = ""
	tick+=1
