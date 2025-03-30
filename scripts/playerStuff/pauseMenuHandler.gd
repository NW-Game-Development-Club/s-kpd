extends Node3D

@export var grabRange: int = 5 # The maximum range that the player can grab objects

@export var inventory: Array[Item] = [] # All the items that the player is carrying
@export var weaponSets: Array[Item] = [] # The weapon sets the player can cycle between

@export var toolShell: ToolShell # The item that handles all the weapons/tool stuff

@export var worldItemPrefab: PackedScene

@onready var camera = get_viewport().get_camera_3d()

@export_group("Display")
@export var itemList: ItemList # The UI element that handles the items displayed in a list
@export var selectedItemNameBox: Label # The label to display the selected item's name
@export var selectedItemDescBox: Label # The label to display the selected item's description
@export var weaponSet1Box: Label # The label to display the weapon-set-one's name
@export var weaponSet2Box: Label # The label to display the weapon-set-two's name

@export_group("Buttons")
@export var dropButton: Button

var currentWeaponSet: int = 0
var selectedItem: Item

@onready var parent = self.get_parent()

func loadPauseMenu():
	itemList.clear()
	for item: Item in inventory:
		itemList.add_item(item.itemName)
	itemList.get_parent().visible = true

func togglePauseMenu():
	if itemList.get_parent().visible:
		GlobalVariables.mouseUnlocked = false # Locks the mouse to the screen
		itemList.get_parent().visible = false
	else:
		GlobalVariables.mouseUnlocked = true # Unlocks the mouse from the screen
		loadPauseMenu()

func getInventoryItemFromName(nameString) -> Item:
	for item: Item in inventory:
		if item.itemName == nameString:
			return item
	return null

func changeSelectionDisplays():
	selectedItem = null
	selectedItemNameBox.text = ""
	selectedItemDescBox.text = ""
	dropButton.disabled = true

# When the player clicks on any item, it could select a new item, or deselect an item we have already clicked on
func onInventoryItemSelect(selectedItemIndex):
	# If no item is selected or we click a different item, select it and update the inspection box
	print(str(selectedItemNameBox.text))
	var selectedItemName = itemList.get_item_text(selectedItemIndex)
	if selectedItem == null || getInventoryItemFromName(selectedItemName) != selectedItem:
		print("Selected item #" + str(selectedItemIndex))
		
		selectedItem = getInventoryItemFromName(selectedItemName)
		
		selectedItemNameBox.text = selectedItem.itemName
		selectedItemDescBox.text = selectedItem.desciption
		dropButton.disabled = false
	
	# If the item we clicked is selected, deselect it
	else:
		itemList.deselect(selectedItemIndex)
		
		changeSelectionDisplays()
		
		print("Deselected item #" + str(selectedItemIndex))

# When the player clicks on the itemlist where no items are, this deselects all selected items
func onInventoryItemDeselectAll(pos: Vector2, mouseButtonIndex: int):
	itemList.deselect_all()
	
	changeSelectionDisplays()
	
	print("Deselected all items")

# Sets the passed item so it is in the weapon set based on the provided number
func onWeaponSetSet(toolToSet: Item, weaponSetNumber: int):
	weaponSetNumber -= 1 # Subtract one to make it zero indexed
	if selectedItem && selectedItem is Tool:
		weaponSets.append(selectedItem)
		weaponSet1Box.text = weaponSets[weaponSetNumber].itemName
		print("Added to weapon set: " + str(selectedItem.itemName))

func _input(event):
	print("test")
	if event.is_action_pressed("pick_up_item"):
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var fireDirection = - camera.global_transform.basis.z * grabRange
		var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position + fireDirection)
		var result = space_state.intersect_ray(query)
		
		if result:
			if parent.currentVehicle == null:
				if result.collider.is_in_group("items"):
					var pickedTool: Item = result.collider.item
					inventory.append(pickedTool)
					print("Picked up " + pickedTool.itemName)
					pickedTool.isInInventory = true
					
					if weaponSets.size() == 0 and pickedTool is Tool:
						weaponSets.append(pickedTool)
						weaponSet1Box.text = weaponSets[0].itemName
						print("Added to weapon set: " + str(pickedTool.itemName))
						
					# Call the world item to do its pick up stuff such as hiding itself
					result.collider.onPickup(self)
				elif result.collider is Ship:
					result.collider.setPilot(parent)
					parent.pilotVehicle(result.collider)
			else:
				parent.currentVehicle.unPilot()
				parent.currentVehicle = null
		
	if event.is_action_pressed("equip_weapon"):
		if weaponSets && weaponSets.size() > 0:
			if toolShell.equippedTool == null:
				toolShell.equip(weaponSets[currentWeaponSet])
			else:
				toolShell.unequip()
		else:
			print("No weapons equipped")
			
	if event.is_action_just_pressed("pause_menu"):
		togglePauseMenu()

func dropItem(item: Item):
	var droppedItem: worldItem = worldItemPrefab.instantiate()
	droppedItem.item = selectedItem
	get_tree().root.add_child(droppedItem)
	droppedItem.global_position = camera.global_position - camera.global_transform.basis.z
	
	inventory.remove_at(inventory.find(selectedItem))
	
	var weaponSetIndex = weaponSets.find(selectedItem)
	# Remove dropped item from weapon set if it is in it
	if weaponSetIndex != -1:
		weaponSets.remove_at(weaponSetIndex)
	
	loadPauseMenu()
	changeSelectionDisplays()

func _on_drop_button_pressed() -> void:
	dropItem(selectedItem)
