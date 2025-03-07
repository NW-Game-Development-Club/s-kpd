extends RigidBody3D

class_name Bullet

@export var mesh:Mesh

@export var damage: int
@export var bulletSpeed: float = 10
@export var knockbackForce: float
@export var bulletGravityScale: float = 0
@export var lifeTime:int = 10 # How long in seconds will the bullet exist before destroying itself

@onready var meshInstance: MeshInstance3D = get_node("MeshInstance3D")
@onready var collider: CollisionShape3D = get_node("Area3D/CollisionShape3D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	meshInstance.mesh = mesh
	collider.shape.radius = mesh.get_aabb().size.x / 2
	collider.shape.height = mesh.get_aabb().size.y
	
	gravity_scale = bulletGravityScale
	
	# Create a destruction timer 
	var scene_tree: SceneTree = get_tree()
	var timer: SceneTreeTimer = scene_tree.create_timer(lifeTime)
	
	timer.timeout.connect(_on_timeout)


func _on_timeout():
	self.queue_free()



func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Hit "+ str(body.name))
	if body is RigidBody3D:
		body.apply_force(linear_velocity.normalized() * knockbackForce * 100)
		#print(str(linear_velocity.normalized() * knockbackForce))
	
	if body.is_in_group("damagable"):
		# Apply damage
		body.applyDamage(damage)
	self.queue_free()
	
