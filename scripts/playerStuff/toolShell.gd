extends Node3D

class_name ToolShell

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Tool") var equippedTool:Tool

# GUN item type only variables
@export_group("Gun Only Variables")
@export var firePoint:Node3D

@onready var meshInstance:MeshInstance3D = get_node("MeshInstance3D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if equippedTool is Gun:
		equippedTool.onReload()

func _input(event):
	if equippedTool && equippedTool.isEquipped:
		if equippedTool is Gun:
			if event.is_action_pressed("activate_item"):
				if (Time.get_ticks_msec() - equippedTool.lastFiredTime) >= equippedTool.fireRate:
					equippedTool.onActivate()
					equippedTool.lastFiredTime = Time.get_ticks_msec()
				else: # If this activates then we are on cooldown still
					var cooldownTime = equippedTool.fireRate - (Time.get_ticks_msec() - equippedTool.lastFiredTime)
					print("Item on cooldown for " + str(cooldownTime) + "ms")
			if event.is_action_pressed("reload"):
				equippedTool.onReload()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func equip(tool:Tool):
	equippedTool = tool
	meshInstance.mesh = equippedTool.model
	equippedTool.onEquip()
	if equippedTool is Gun:
		equippedTool.prep(firePoint, get_viewport().get_camera_3d())
	print("Equipped "+ str(tool.itemName))

func unequip():
	meshInstance.mesh = null
	equippedTool.onUnequip()
	print("Unequipped "+ str(equippedTool.itemName))
	equippedTool = null
	
