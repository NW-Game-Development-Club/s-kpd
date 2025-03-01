extends Node3D

@export var grabRange: int = 5 # The maximum range that the player can grab objects

@export var inventory: Array[Item] = []
@export var weaponSets: Array[Item] = []

@export var toolShell: ToolShell

@onready var camera = get_viewport().get_camera_3d()

var currentWeaponSet: int = 0

func _input(event):
	if event.is_action_pressed("pick_up_item"):
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var fireDirection = -camera.global_transform.basis.z*grabRange
		var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position + fireDirection)
		var result = space_state.intersect_ray(query)
		
		if result && result.collider.is_in_group("items"):
			result.collider.onPickup(self)

	if event.is_action_pressed("equip_weapon"):
		if toolShell.equippedTool == null:
			toolShell.equip(weaponSets[currentWeaponSet])
		else:
			toolShell.unequip()
