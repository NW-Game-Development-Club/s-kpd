extends Node3D

@export var pieces: Array[PackedScene]
@export var amtOfPiecesToSpawn:int = 10

static var piecePlacement:Dictionary

static var pieceValues:Array[Tile]

func generateLevel(currentPos: Vector3, rot: Vector3):
	await get_tree().create_timer(randf_range(0.001,0.005)).timeout
	if piecePlacement.size()-pieceValues.size() >= amtOfPiecesToSpawn:
		#print("Path Finished at " + str(spawnAtNode.global_position))
		return 0
	
	
	var placementString = createDictionaryString(currentPos)
	if piecePlacement.has(placementString):
		print("Overlapped")
		return -1
	
	var randPieceNum = randi_range(0,pieces.size()-1)
	piecePlacement[placementString] = {
		"pieceNum": randPieceNum,
		"pieceRot": rot
	}
	
	#print(("default: "+str(self.position)) if (spawnAtNode == null) else "SpawnNodePos: "+str(spawnAtNode.global_position))
	var setRot = pieceValues[randPieceNum].spawnNodes[0].global_position
	pieceValues[randPieceNum].rotation = rot
	for spawnNode:Node3D in pieceValues[randPieceNum].spawnNodes:
		var getRot = pieceValues[randPieceNum].global_position
		var placePos = currentPos + spawnNode.global_position
		generateLevel(currentPos + spawnNode.global_position, spawnNode.global_rotation)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			removeAllTiles()
			print("removed all children.")
			
			# Instantiate one of each of our pieces so that we can get the values stored on them
			generateTemplatePieces()
			print("instantiated the template pieces.")
			
			generateLevel(Vector3.ZERO, Vector3.ZERO)
			
			# Wait till we're done then do the printing of level generated and piece placement count
			var previousCount = 0
			while (piecePlacement.size()-pieceValues.size() < amtOfPiecesToSpawn || previousCount == piecePlacement.size()):
				previousCount = piecePlacement.size()
				await get_tree().create_timer(0.5).timeout
			placeGeneratedPieces()
			print("Level generated")
			print("Placed "+str(piecePlacement.size())+" Pieces")
			#print(piecePlacement)
			
			# Remove the template pieces we placed
			removeTemplatePieces()

func createDictionaryString(pos):
	return str(snapped(pos.x,0.01)) + "," + str(snapped(pos.y,0.01)) + "," + str(snapped(pos.z,0.01))
func splitDictionaryString(string):
	var positions = string.split(',')
	return Vector3(int(positions[0]), int(positions[1]), int(positions[2]))

func generateTemplatePieces():
	for tileScene:PackedScene in pieces:
		var tile = tileScene.instantiate()
		pieceValues.append(tile)
		add_child(tile)
func removeTemplatePieces():
	for piece:Tile in pieceValues:
		piece.queue_free() 
	
	pieceValues = []


func placeGeneratedPieces():
	for key in piecePlacement.keys():
		var piece = piecePlacement[key]
		placePiece(piece.pieceNum, splitDictionaryString(key), piece.pieceRot)
func placePiece(pieceNum, pos, rot):
	var placedPiece:Tile = pieces[pieceNum].instantiate()
	placedPiece.position = pos
	placedPiece.rotation = rot
	
	add_child(placedPiece)

func removeAllTiles():
	# Remove all physical tiles
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
		
	# Remove our stored tile placement dictionary data
	piecePlacement = {}
