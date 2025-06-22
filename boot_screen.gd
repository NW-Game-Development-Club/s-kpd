extends AnimatedSprite2D

var running = false
var sleeping = false

signal sleep_timer_start
signal sleep_timer_reset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../../../../../../BetterCharacter/InventoryHandler".entered_computer.connect(_on_computer_entered)
	$"../../../../../../../BetterCharacter/InventoryHandler".exited_computer.connect(_on_computer_exited)
	#self.show()

func _on_computer_entered():
	emit_signal("sleep_timer_reset")
	if running == false:
		running = true
		if sleeping == false:
			await get_tree().create_timer(randf_range(1.7, 2.8)).timeout
			play("Start")
			await get_tree().create_timer(randf_range(2.1, 3.2)).timeout
			play("Off")
			await get_tree().create_timer(randf_range(0.05, 0.3)).timeout
			play("Booting")
			await get_tree().create_timer(randf_range(15, 25)).timeout
			play("Off")
		else:
			sleeping = false
		await get_tree().create_timer(randf_range(0.8, 1.4)).timeout
		self.hide()
		if GlobalVariables.inRadar == false:
			emit_signal("sleep_timer_start")
		await get_tree().create_timer(randf_range(0.5, 2)).timeout
		$"../CanvasLayer/Mouse".show()
		await get_tree().create_timer(randf_range(3, 6)).timeout
		$"../Panel".show()
		await get_tree().create_timer(randf_range(0.5, 2)).timeout
		$"../RadarApp".show()

func _on_computer_exited():
	if self.visible == false:
		emit_signal("sleep_timer_start")

func _on_sleep_timer_timeout() -> void:
	if running == true:
		play("Off")
		await get_tree().create_timer(randf_range(0.1, 0.2)).timeout
		self.show()
		running = false
		sleeping = true
		emit_signal("sleep_timer_start")
	else:
		sleeping = false
		_hide_computer_stuff()
	


func _on_sleep_button_button_down() -> void:
	await get_tree().create_timer(randf_range(0.1, 0.2)).timeout
	play("Off")
	self.show()
	running = false
	sleeping = true


func _on_shut_down_button_button_down() -> void:
	await get_tree().create_timer(randf_range(0.8, 1.4)).timeout
	play("Off")
	_hide_computer_stuff()
	await get_tree().create_timer(randf_range(0.8, 1.4)).timeout
	self.show()
	running = false


func _on_restart_button_button_down() -> void:
	await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
	play("Off")
	_hide_computer_stuff()
	await get_tree().create_timer(randf_range(0.05, 0.2)).timeout
	self.show()
	await get_tree().create_timer(randf_range(2.5, 4.1)).timeout
	running = true
	play("Start")
	await get_tree().create_timer(randf_range(2.1, 3.2)).timeout
	play("Off")
	await get_tree().create_timer(randf_range(0.05, 0.3)).timeout
	play("Booting")
	await get_tree().create_timer(randf_range(15, 25)).timeout
	play("Off")
	await get_tree().create_timer(randf_range(0.8, 1.4)).timeout
	self.hide()
	if GlobalVariables.inRadar == false:
		emit_signal("sleep_timer_start")
	await get_tree().create_timer(randf_range(0.5, 2)).timeout
	$"../CanvasLayer/Mouse".show()
	await get_tree().create_timer(randf_range(3, 6)).timeout
	$"../Panel".show()
	await get_tree().create_timer(randf_range(0.5, 2)).timeout
	$"../RadarApp".show()
	
func _hide_computer_stuff() -> void:
	$"../CanvasLayer/Mouse".hide()
	$"../Panel".hide()
	$"../RadarApp".hide()
	$"../RadarWindow".hide()
	$"../PowerWindow".hide()
