extends Button


# Called when the node enters the scene tree for the first time.
func _gui_input(event) -> void:
	if event.is_pressed():
		$"../../PowerWindow".show()
