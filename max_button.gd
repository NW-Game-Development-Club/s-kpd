extends Button

var savedPos = Vector2(0,0)
var savedSize = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _gui_input(event) -> void:
	var panel = $"../.." 
	if event.is_pressed():
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.1
		timer.one_shot = true
		timer.start()
		await timer.timeout
		timer.queue_free()
		if panel .anchor_left == 0 && panel .anchor_top == 0 && panel.anchor_right == 1 && panel.anchor_bottom == 1 && panel.offset_left == -10 && panel.offset_top == -6 && panel.offset_right == 0 && panel.offset_bottom == 0:
			$"../..".position = savedPos
			$"../..".size = savedSize
		else:
			savedPos = $"../..".position
			savedSize = $"../..".size
			panel.anchor_left = 0
			panel.anchor_top = 0
			panel.anchor_right = 1
			panel.anchor_bottom = 1

			panel.offset_left = -10
			panel.offset_top = -6
			panel.offset_right = 0
			panel.offset_bottom = 0
			print(((get_viewport().get_visible_rect().size) / 2) - (Vector2(1675.928, 1104.007) / 2))
