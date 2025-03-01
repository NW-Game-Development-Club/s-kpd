extends Item

class_name Tool

@export var isEquipped: bool

func onEquip():
	if isInInventory:
		isEquipped = true

func onUnequip():
	if isInInventory:
		isEquipped = false


func onActivate():
	print("Activated "+ itemName)


func onDrop():
	super()
	isEquipped = false
