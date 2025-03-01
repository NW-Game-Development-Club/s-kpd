extends Node3D

@export var grabRange: int = 5 # The maximum range that the player can grab objects

@export var inventory: Array[Item] = []
@export var weaponSets: Array[Item] = []

@export var toolShell: ToolShell
@export var itemList: ItemList

@onready var camera = get_viewport().get_camera_3d()
@onready var itemNameBox:Label = itemList.get_parent().get_node("SelectedItemName")
@onready var itemDescBox:Label = itemList.get_parent().get_node("SelectedItemDesc") 
@onready var weaponSet1Box:Label = itemList.get_parent().get_node("WeaponSet1Value")
@onready var weaponSet2Box:Label = itemList.get_parent().get_node("WeaponSet2Value") 

var currentWeaponSet: int = 0

func loadInventory():
	if itemList.get_parent().visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks the mouse to the screen
		itemList.get_parent().visible = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Locks the mouse to the screen
		itemList.clear()
		for item:Item in inventory:
			itemList.add_item(item.itemName)
		itemList.get_parent().visible = true

func getInventoryItemFromName(nameString):
	for item:Item in inventory:
		if item.itemName == nameString:
			return item
	return null

func onInventoryItemSelect(selectedItemIndex):
	# If the item we clicked is not already selected, select it and update the inspection box
	print(str(itemNameBox.text))
	if itemNameBox.text == "Name: ": 
		print("Selected item #"+str(selectedItemIndex))
		
		var selectedItemName = itemList.get_item_text(selectedItemIndex)
		
		var selectedItem = getInventoryItemFromName(selectedItemName)
		
		itemNameBox.text = "Name: "+ selectedItem.itemName
		itemDescBox.text = "Desciption: "+ selectedItem.desciption
	# If the item we clicked is selected, deselect it
	else:
		itemList.deselect(selectedItemIndex)
		itemNameBox.text = "Name: "
		itemDescBox.text = "Desciption: "
		print("Deselected item #"+str(selectedItemIndex))

func onInventoryItemDeselectAll(pos: Vector2, mouseButtonIndex: int):
	itemList.deselect_all()
	itemNameBox.text = "Name: "
	itemDescBox.text = "Desciption: "
	print("Deselected all items")

func _input(event):
	if event.is_action_pressed("pick_up_item"):
		var space_state = get_world_3d().direct_space_state
		# use global coordinates, not local to node
		var fireDirection = -camera.global_transform.basis.z*grabRange
		var query = PhysicsRayQueryParameters3D.create(camera.global_position, camera.global_position + fireDirection)
		var result = space_state.intersect_ray(query)
		
		if result && result.collider.is_in_group("items"):
			var pickedTool:Item = result.collider.item
			inventory.append(pickedTool)
			print("Picked up "+pickedTool.itemName)
			pickedTool.isInInventory = true
			
			if weaponSets.size() == 0 and pickedTool is Tool:
				weaponSets.append(pickedTool)
				weaponSet1Box.text = weaponSets[0].itemName
				print("Added to weapon set: "+ str(pickedTool.itemName))
				
			# Call the world item to do its pick up stuff such as hiding itself
			result.collider.onPickup(self)
			

	if event.is_action_pressed("equip_weapon"):
		if toolShell.equippedTool == null:
			toolShell.equip(weaponSets[currentWeaponSet])
		else:
			toolShell.unequip()
			
	if event.is_action_pressed("open_inventory"):
		loadInventory()
