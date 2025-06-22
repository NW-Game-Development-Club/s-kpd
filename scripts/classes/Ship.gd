extends RigidBody3D

class_name Ship

@export_group("Movement")
@export var speed: float
@export var dampening: float

var pilot: CharacterBody3D

@onready var camera = $RadarScreen/Camera3D
@onready var ui_plane = $RadarScreen/Radar_Screen  # replace with your actual mesh node
var windowSize = Vector2i(0,0)


func _on_window_resized():
	GlobalVariables.ui_screen_rect = get_ui_screen_rect()

func get_ui_screen_rect():
	var aabb = ui_plane.get_aabb()
	var top_left = camera.unproject_position(ui_plane.to_global(aabb.position))
	var bottom_right = camera.unproject_position(ui_plane.to_global(aabb.position + aabb.size))

	var rect_pos = Vector2(top_left.x, top_left.y)
	var rect_size = bottom_right - top_left
	return Rect2(rect_pos, rect_size)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.linear_damp = 0
	self.angular_damp = 0
	GlobalVariables.ui_screen_rect = get_ui_screen_rect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Area3D.gravity_direction = -transform.basis.y
	get_ui_screen_rect()
	if get_window().size != windowSize:
		windowSize = get_window().size
		_on_window_resized()

func setPilot(player):
	pilot = player
	

func unPilot():
	pilot = null
