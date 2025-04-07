extends Node3D

@onready var dirSphere = $"RadarDirSphere"

@export var radarRange: float = 100
@export var radarResolution: int = 50
@export var radarLoadMDelay: float = 1
@export var radarPanelMaterial:Material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dirSphere.mesh.radial_segments = radarResolution
	dirSphere.mesh.rings = radarResolution


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getRaycast(rayDir, space_state):
	var query = PhysicsRayQueryParameters3D.create(self.global_position, self.global_position + rayDir * radarRange)
	return space_state.intersect_ray(query)
	

func removePoints():
	print("Removed "+ str(get_tree().get_nodes_in_group("radarPoints").size()) +" Points")
	for point in get_tree().get_nodes_in_group("radarPoints"):
		point.queue_free()

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform


func renderRadarPoint(pos:Vector3, dir:Vector3):
	var pointMesh = PlaneMesh.new()
	var meshInstance = MeshInstance3D.new()
	meshInstance.mesh = pointMesh
	meshInstance.visible = false
	#print(meshInstance)
	get_tree().root.add_child(meshInstance)
	meshInstance.position = pos
	
	meshInstance.set_surface_override_material(0,radarPanelMaterial)
	meshInstance.global_transform = align_with_y(meshInstance.global_transform, dir)
	#meshInstance.look_at(meshInstance.global_position + Vector3.UP, dir)
	meshInstance.add_to_group("radarPoints")
	meshInstance.visible = true

func attemptRenderMesh(radarPoints):
	var st = SurfaceTool.new()
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_POINTS)
	for p in radarPoints: #list of Vector3s
		st.set_color(lerp(Color.BROWN, Color.CHARTREUSE, self.global_position.distance_to(p.position) / 50 ))
		st.add_vertex(p.position)
		
	$MeshInstance3D.mesh = st.commit()

func pingRadar():
	var radarPoints = []
	var mdt = MeshDataTool.new()
	# convert primitve to ArrayMesh
	var arrMesh: ArrayMesh = ArrayMesh.new()
	arrMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, dirSphere.mesh.get_mesh_arrays())
	
	mdt.create_from_surface(arrMesh, 0)
	var space_state = get_world_3d().direct_space_state
	
	var pointsPlaced := 0
	for i in range(mdt.get_face_count()):
		var rayDir := mdt.get_face_normal(i)
		var hit = getRaycast(rayDir, space_state)
		if hit:
			radarPoints.append(hit)
			var m = Material.new()
			
			renderRadarPoint(hit.position, hit.normal)
			pointsPlaced += 1
			await get_tree().create_timer(radarLoadMDelay / 1000).timeout
		#await get_tree().create_timer(0.01).timeout
		
	print("Rendered "+ str(pointsPlaced) + " Points")
	#attemptRenderMesh(radarPoints)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			removePoints()
			pingRadar()
