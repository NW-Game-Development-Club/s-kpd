extends Item

class_name Tool

@export var isEquipped: bool

var toolShellPassIn: ToolShell
var viewportPassIn: Viewport

func onEquip():
	if isInInventory:
		isEquipped = true

func onUnequip():
	if isInInventory:
		isEquipped = false


func onActivate():
	print("Activated "+ itemName)

func prep(toolShell: ToolShell, viewport:Viewport):
	toolShellPassIn = toolShell
	viewportPassIn = viewport

func onDrop():
	super()
	isEquipped = false
