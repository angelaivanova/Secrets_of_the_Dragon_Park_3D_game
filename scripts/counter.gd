extends Label

var coins=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_coin_collected():
	coins=coins+1
	_ready()
	if coins == 10:
		$Timer.start()

#tuka treba da se dovrseee koga ke napravam win prozorec
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/Win.tscn")
