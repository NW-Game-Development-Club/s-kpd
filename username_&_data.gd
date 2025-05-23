extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVariables.playerName = "Max Linberg"
	var userName = $"../..".realistic_misspell(GlobalVariables.playerName)
	self.text = "Hello " + userName + "!\n" + "Cycle " + str(-12345678987)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
