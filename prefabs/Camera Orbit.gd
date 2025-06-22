extends Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vp_texture = ViewportTexture.new()
	vp_texture.viewport_path = $"..".get_path()
	GlobalVariables.radarCameraPort = vp_texture

 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = $"../../../CameraOrbit/CameraPivot/CameraNode".global_position
	var shipRotation = $"../../..".global_rotation
	look_at($"../../..".global_transform.origin, $"../../..".global_transform.basis.y)
