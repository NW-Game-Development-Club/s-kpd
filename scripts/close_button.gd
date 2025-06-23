extends Button


# Called when the node enters the scene tree for the first time.
func _gui_input(event) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.2
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()
	$"../..".hide()
