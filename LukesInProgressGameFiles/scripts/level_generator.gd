extends Node3D

@export var pieces: Array[PackedScene]
@export var amtOfPiecesToSpawn:int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#generateLevel(0, null)
	pass

func pickBiasedRandomPiece():
	var random_float = randf()
	if random_float < 0.4:
		return pieces[0]
	elif random_float >= 0.4 && random_float < 0.6:
		return pieces[1]
	elif random_float >= 0.6 && random_float < 0.8:
		return pieces[2]
	else:
		return pieces[3]

# Recursively generates the amount of tiles specified in the base case if statement 
func generateLevel(spawnAtNode: Node3D):
	await get_tree().create_timer(randf_range(0.001,0.005)).timeout
	if self.get_children().size() >= amtOfPiecesToSpawn:
		print("Path Finished at " + str(spawnAtNode.global_position))
		return 0
	
	if spawnAtNode != null:
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var query = PhysicsRayQueryParameters3D.create(spawnAtNode.global_position, Vector3(spawnAtNode.global_position.x, -100, spawnAtNode.global_position.z))
		var result = space_state.intersect_ray(query)
		if result:
			print("Overlapped")
			return -1
	
	var randPiece = pickBiasedRandomPiece()
	var placedPiece:Tile = randPiece.instantiate()
	placedPiece.position = self.position if (spawnAtNode == null) else spawnAtNode.global_position
	placedPiece.rotation = self.rotation if (spawnAtNode == null) else spawnAtNode.global_rotation
	
	add_child(placedPiece)
	#print(("default: "+str(self.position)) if (spawnAtNode == null) else "SpawnNodePos: "+str(spawnAtNode.global_position))
	for node:Node3D in placedPiece.spawnNodes:
		#print("NodePos"+str(node.global_position))
		print("Pos: "+str(node.global_position))
		generateLevel(node)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			removeAllTiles()
			print("removed all children.")
			generateLevel(null)
			
			# Wait till we're done then do the printing of level generated and piece placement count
			while (self.get_children().size() < amtOfPiecesToSpawn):
				await get_tree().create_timer(0.5).timeout
			print("Level generated")
			print("Placed "+str(self.get_children().size())+" Pieces")


func removeAllTiles():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free() 
