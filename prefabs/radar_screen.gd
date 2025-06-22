extends StaticBody3D

@onready var subviewport = $Radar_Screen/SubViewportContainer/SubViewport
var ui_screen_rect = GlobalVariables.ui_screen_rect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func get_local_mouse_pos():
	var mouse_pos = get_viewport().get_mouse_position()
	if GlobalVariables.ui_screen_rect.has_point(mouse_pos):
		var relative_pos = mouse_pos - GlobalVariables.ui_screen_rect.position
		var uv = relative_pos / GlobalVariables.ui_screen_rect.size
		return uv * Vector2(subviewport.size)
	return null

func _process(delta):
	var local_mouse = get_local_mouse_pos()
	if local_mouse != null:
		$Radar_Screen/SubViewportContainer/SubViewport/WinDesktop/CanvasLayer/Mouse.position = local_mouse

		# Create and send a motion event
		var motion_event = InputEventMouseMotion.new()
		motion_event.position = local_mouse
		subviewport.push_input(motion_event)

		# Optionally send button events
		if Input.is_action_just_pressed("activate_item"):
			var click = InputEventMouseButton.new()
			click.position = local_mouse
			click.button_index = MOUSE_BUTTON_LEFT
			click.pressed = true
			subviewport.push_input(click)
		elif Input.is_action_just_released("activate_item"):
			var release = InputEventMouseButton.new()
			release.position = local_mouse
			release.button_index = MOUSE_BUTTON_LEFT
			release.pressed = false
			subviewport.push_input(release)
