extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.size = Vector2(320, 180)  # Example: 160x90 for pixel art
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _gui_input() -> void:
	print("HIT")
