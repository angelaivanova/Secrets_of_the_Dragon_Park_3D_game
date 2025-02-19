extends Label

@onready var timer = $TimerLbl
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()

func time_left_to_live():
	var time_left=timer.time_left
	var minute = floor(time_left/60)
	var second =  int(time_left)%60
	return [minute, second]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%02d:%02d" % time_left_to_live()
	if timer.time_left <= 0:
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
