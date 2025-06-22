extends TextureRect

var mouse_held = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_held = event.pressed  # true on press, false on release

func _process(delta):
	if mouse_held:
		$SubViewport/Camera3D.position = $"../../../../../../../CameraOrbit/CameraPivot/CameraNode".global_position
