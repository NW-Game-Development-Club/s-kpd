extends RigidBody3D

class_name worldItem

@export var equippedTool:Item

@onready var mesh:MeshInstance3D = self.get_node("./MeshInstance3D")

func _ready() -> void:
	mesh.mesh = equippedTool.model

func onPickup(player):
	player.inventory.append(equippedTool)
	print("Picked up "+equippedTool.itemName)
	equippedTool.isInInventory = true
	
	if player.weaponSets.size() == 0 and equippedTool is Tool:
		player.weaponSets.append(equippedTool)
		print("Added to weapon set: "+ str(equippedTool.itemName))
	
	self.visible = false
	self.process_mode = 4
