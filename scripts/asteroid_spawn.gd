extends Node3D

@onready var meshInstance: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generateAsteroid():
	var sphereMesh = SphereMesh.new()
	sphereMesh.radius = 2
	sphereMesh.height = 2
	
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randf()
	
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, sphereMesh.get_mesh_arrays())
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	for i in range(mdt.get_vertex_count()):
		var vertex = mdt.get_vertex(i)
		# In this example we extend the mesh by one unit, which results in separated faces as it is flat shaded.
		vertex.y += noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * 10
		print(noise.get_noise_3d(vertex.x, vertex.y, vertex.z) * 10)
		# Save your change.
		mdt.set_vertex(i, vertex)
	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	
	meshInstance.mesh = mesh
	
	print("Finished Generation!")
	

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			print("Regenerated Asteroid")
			
			generateAsteroid()
