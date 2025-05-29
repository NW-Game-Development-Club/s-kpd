extends Sprite2D

@onready var cursor_sprite = $CursorSprite

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta):
	self.position = get_tree().root.get_mouse_position()
