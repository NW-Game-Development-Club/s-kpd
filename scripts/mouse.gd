extends Sprite2D

@onready var cursor_sprite = $CursorSprite

func _ready():
	var default_texture = load("res://.godot/imported/windows-cursor-icon-10-removebg-preview.png-00745bd7911530c03832166aeea3f0c5.ctex")
	var loading_texture = load("res://.godot/imported/png-transparent-computer-mouse-hourglass-pointer-cursor-computer-mouse-electronics-rectangle-mouse-removebg-preview.png-1037d34e00062b05f65f99fddf47b7c4.ctex")
	texture = default_texture
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
