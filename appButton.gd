extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called when pressed.
func _gui_input(event) -> void:
	if $"../RadarWindow".visible == false:
		$"../RadarWindow".size = Vector2(800,500)
		$"../RadarWindow".position = ((get_viewport().get_visible_rect().size) / 2) - ($"../RadarWindow".size / 2)
		$"../RadarWindow".show()
