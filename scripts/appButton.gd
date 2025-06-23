extends Button

var last_click_time := 0.0
var double_click_max_time := 0.6  # Seconds
var loading = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func wait_random_time(min_time: float, max_time: float) -> void:
	var random_time = randf_range(min_time, max_time)
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = random_time
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()

# Called when pressed.
func _gui_input(event) -> void:
	if $"../RadarWindow".visible == false && event.is_pressed() && loading == false:
		loading = true
		var current_time = Time.get_ticks_usec() / 1_000_000.0  # Convert to seconds
		if current_time - last_click_time <= double_click_max_time:
			await wait_random_time(1.2, 3.2)
			$"../RadarWindow".size = Vector2(800,500)
			$"../RadarWindow".position = ((get_viewport().get_visible_rect().size) / 2) - ($"../RadarWindow".size / 2)
			$"../RadarWindow".show()
		last_click_time = current_time
		loading = false

		
