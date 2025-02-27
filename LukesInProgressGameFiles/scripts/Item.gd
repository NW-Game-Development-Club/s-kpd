extends Node3D

# This is the default item class. Extra features like equipping/use will be handled in the tool class which is a subclass of this.
class_name Item

@export var itemName:String # Name of item
@export var desciption:String # Description of item

func onPickup():
	pass

func onDrop():
	pass
