extends RigidBody3D

class_name worldItem

@export var item:Item

@onready var mesh:MeshInstance3D = self.get_node("./MeshInstance3D")

func _ready() -> void:
	mesh.mesh = item.model

func onPickup(player):
	self.visible = false
	self.process_mode = 4
