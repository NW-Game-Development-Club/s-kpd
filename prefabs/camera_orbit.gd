extends Node3D

@export var target: NodePath
@export var rotation_sensitivity := 0.01
@export var min_pitch := deg_to_rad(-80)
@export var max_pitch := deg_to_rad(80)
@export var default_distance := 50.0
@export var zoom_speed := 2
@export var min_distance := 15.0
@export var max_distance := 200.0

var yaw := 0.0
var pitch := 0.0
var distance := default_distance

@onready var camera_pivot := $CameraPivot
@onready var camera := $CameraPivot/CameraNode


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion and GlobalVariables.inRadar == true and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event:
			yaw -= event.relative.x * rotation_sensitivity
			pitch = clamp(pitch - event.relative.y * rotation_sensitivity, min_pitch, max_pitch)

	elif event is InputEventMouseButton && GlobalVariables.inRadar == true:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = max(distance - zoom_speed, min_distance)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = min(distance + zoom_speed, max_distance)

	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	# Rotate around target
	rotation.y = yaw
	camera_pivot.rotation.x = pitch

	# Zoom control
	camera.position = Vector3(0, 0, distance)
