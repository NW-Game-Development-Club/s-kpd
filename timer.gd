extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../BootScreen".sleep_timer_start.connect(_sleep_timer_start)
	$"../BootScreen".sleep_timer_reset.connect(_sleep_timer_reset)

func _sleep_timer_start() -> void:
	self.start()

func _sleep_timer_reset() -> void:
	self.stop()
