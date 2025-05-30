extends Node3D

@onready var dirSphere = $"RadarDirSphere"

@export var radarRange: float = 10000
@export var radarLoadMDelay: float = 1
@export var radarPanelMaterial:Material
@export var radarResolution: int = 5
var radarResolutionTwo: int = 100 / (radarResolution/5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dirSphere.mesh.radial_segments = radarResolutionTwo
	dirSphere.mesh.rings = radarResolutionTwo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getRaycast(rayDir, space_state):
	var query = PhysicsRayQueryParameters3D.create((self.global_position + (rayDir * 5)), (self.global_position + (rayDir * 5)) + rayDir * radarRange)
	query.exclude = [$"..", $BetterCharacter]
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
	var pointMesh = BoxMesh.new()
	var meshInstance = MeshInstance3D.new()
	meshInstance.mesh = pointMesh
	meshInstance.scale = Vector3(radarResolution, radarResolution, radarResolution)
	meshInstance.visible = false
	#print(meshInstance)
	get_tree().root.add_child(meshInstance)
	meshInstance.position = (((pos - dir*(radarResolution / 1)) / radarResolution).round()) * radarResolution
	
	meshInstance.set_surface_override_material(0,radarPanelMaterial)
	#meshInstance.look_at(meshInstance.global_position + Vector3.UP, dir)
	meshInstance.add_to_group("radarPoints")
	meshInstance.set_layer_mask_value(2, true)
	meshInstance.set_layer_mask_value(1, false)
	meshInstance.visible = true

func attemptRenderMesh(radarPoints):
	var st = SurfaceTool.new()
	
	st.clear()
	st.begin(Mesh.PRIMITIVE_POINTS)
	for p in radarPoints: #list of Vector3s
		st.set_color(lerp(Color.BROWN, Color.CHARTREUSE, self.global_position.distance_to(p.position) / 50 ))
		st.add_vertex(p.position)
		
	$MeshInstance3D.mesh = st.commit()

func find_closest_node_to_point(array, point):
	var closest_node = null
	var closest_node_distance = 0.0
	for i in array:
		var current_node_distance = point.distance_to(i.position)
		if closest_node == null or current_node_distance < closest_node_distance:
			closest_node = i
			closest_node_distance = current_node_distance
	return closest_node

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
		if hit && radarPoints == []:
			radarPoints.append(hit)
			var m = Material.new()
		elif hit && find_closest_node_to_point(radarPoints, hit.position).position.distance_to(hit.position) > 0.5:
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
		if event.pressed and event.keycode == KEY_P && GlobalVariables.inRadar == true:
			removePoints()
			pingRadar()
