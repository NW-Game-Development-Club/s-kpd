extends ColorRect

var selectPoint

func _ready() -> void:
	selectPoint = Vector2(0, 0)

#func _gui_input(event):
	#if event is InputEventMouseButton == false:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#selectPoint = get_global_mouse_position()
				
# Called when the node enters the scene tree for the first time.
#func _process(delta: float) -> void:
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#self.show()
		# Assume these are your two corner positions
		#var corner_a = get_global_mouse_position()
		#var corner_b = selectPoint

		# Calculate top-left position and size
		#var top_left = Vector2(min(corner_a.x, corner_b.x), min(corner_a.y, corner_b.y))
		#var size = Vector2(abs(corner_b.x - corner_a.x), abs(corner_b.y - corner_a.y))

		# Apply to the ColorRect
		#self.position = top_left
		#self.size = size
	#else:
		#self.hide()
