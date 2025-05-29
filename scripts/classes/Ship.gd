extends RigidBody3D

class_name Ship

@export_group("Movement")
@export var speed: float
@export var dampening: float

var pilot: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.linear_damp = 0
	self.angular_damp = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Area3D.gravity_direction = -transform.basis.y

func setPilot(player):
	pilot = player
	

func unPilot():
	pilot = null
