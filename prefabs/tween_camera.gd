extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.current = false
	GlobalVariables.tweenCamera = self
	
# Assuming you have CameraA, CameraB, and BlendCamera
var transition_time = 1.0  # seconds
var timer = 0.0
var is_transitioning = false
var CameraB2

func start_camera_transition(CameraA, CameraB):
	CameraB2 = CameraB
	self.global_transform = CameraA.global_transform
	self.current = true
	CameraA.current = false
	timer = 0.0
	is_transitioning = true
	print("test")

func _process(delta):
	if is_transitioning:
		timer += delta
		var t = clamp(timer / transition_time, 0, 1)
		self.global_transform.origin = self.global_transform.origin.lerp(
			CameraB2.global_transform.origin, t)
		self.global_transform.basis = self.global_transform.basis.slerp(
		CameraB2.global_transform.basis, t)
		if t >= 1.0:
			CameraB2.current = true
			self.current = false
			is_transitioning = false
