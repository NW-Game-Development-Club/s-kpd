extends Resource

# This is the default item class. Extra features like equipping/use will be handled in the tool class which is a subclass of this.
class_name Item

@export var itemName:String # Name of item
@export_multiline var desciption:String # Description of item

@export var model:Mesh

@export var isInInventory: bool

func onPickup():
	isInInventory = true

func onDrop():
	isInInventory = false
