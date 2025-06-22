extends PanelContainer

enum ResizeDir {
	NONE, LEFT, RIGHT, TOP, BOTTOM,
	TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT
}

var resizing := false
var resize_dir = ResizeDir.NONE
var drag_start_pos := Vector2.ZERO
var drag_start_rect := Rect2()
var min_size := Vector2(500, 300)
	

func _ready():
	var handles = {
		$ResizeHandle_TopLeft: ResizeDir.TOP_LEFT,
		$ResizeHandle_TopRight: ResizeDir.TOP_RIGHT,
		$ResizeHandle_BottomLeft: ResizeDir.BOTTOM_LEFT,
		$ResizeHandle_BottomRight: ResizeDir.BOTTOM_RIGHT,
		$ResizeHandle_Left: ResizeDir.LEFT,
		$ResizeHandle_Right: ResizeDir.RIGHT,
		$ResizeHandle_Top: ResizeDir.TOP,
		$ResizeHandle_Bottom: ResizeDir.BOTTOM	
		}

	for handle in handles.keys():
		handle.mouse_filter = Control.MOUSE_FILTER_PASS
		handle.gui_input.connect(_on_resize_handle_input.bind(handles[handle]))

func _on_resize_handle_input(event, direction):
	print($".".size)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				resizing = true
				resize_dir = direction
				drag_start_pos = get_global_mouse_position()
				drag_start_rect = Rect2(global_position, size)
			else:
				resizing = false
				resize_dir = ResizeDir.NONE
	elif event is InputEventMouseMotion and resizing:
		var mouse_delta = get_global_mouse_position() - drag_start_pos
		var new_pos = drag_start_rect.position
		var new_size = drag_start_rect.size

		match resize_dir:
			ResizeDir.LEFT:
				new_pos.x += mouse_delta.x
				new_size.x -= mouse_delta.x
			ResizeDir.RIGHT:
				new_size.x += mouse_delta.x
			ResizeDir.TOP:
				new_pos.y += mouse_delta.y
				new_size.y -= mouse_delta.y
			ResizeDir.BOTTOM:
				new_size.y += mouse_delta.y
			ResizeDir.TOP_LEFT:
				new_pos += mouse_delta
				new_size -= mouse_delta
			ResizeDir.TOP_RIGHT:
				new_pos.y += mouse_delta.y
				new_size.y -= mouse_delta.y
				new_size.x += mouse_delta.x
			ResizeDir.BOTTOM_LEFT:
				new_pos.x += mouse_delta.x
				new_size.x -= mouse_delta.x
				new_size.y += mouse_delta.y
			ResizeDir.BOTTOM_RIGHT:
				new_size += mouse_delta

		# Enforce minimum size
		if new_size.x < min_size.x:
			new_size.x = min_size.x
			if resize_dir in [ResizeDir.LEFT, ResizeDir.TOP_LEFT, ResizeDir.BOTTOM_LEFT]:
				new_pos.x = drag_start_rect.end.x - min_size.x
		if new_size.y < min_size.y:
			new_size.y = min_size.y
			if resize_dir in [ResizeDir.TOP, ResizeDir.TOP_LEFT, ResizeDir.TOP_RIGHT]:
				new_pos.y = drag_start_rect.end.y - min_size.y

		global_position = new_pos
		size = new_size
		
var dragging := false
var drag_offset := Vector2.ZERO

func _gui_input(event):
	if event is InputEventMouseButton && resizing == false:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_offset = get_global_mouse_position() - global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - drag_offset
