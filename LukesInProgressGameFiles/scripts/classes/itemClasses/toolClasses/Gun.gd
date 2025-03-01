extends Tool

class_name Gun

enum DETECTION_TYPE {HIT_SCAN, PROJECTILE} 
@export var weaponDetectionType: DETECTION_TYPE
@export var raycastRange: float = 100

@export var damage: int
@export var knockbackForce: float

@export var fireRate: float # Represents a cooldown time between shots
@export var isContinuousFire: bool

@export var clipSize: float
@export_group("Reload")
@export var reloadTime: float

@export var isCustomReloadAmount: bool
@export var reloadAmount: int # Only matters if isCustomReloadAmount is true

var firePoint: Node3D
var crossHair: Node3D
var lastFiredTime: int = 0

func prep(firePoint:Node3D, crossHair:Node3D):
	self.firePoint = firePoint
	self.crossHair = crossHair
	self.lastFiredTime = 0

func onReload():
	print("Reloaded "+ itemName)

func onActivate():
	var space_state = firePoint.get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var fireDirection = -crossHair.global_transform.basis.z*raycastRange
	var query = PhysicsRayQueryParameters3D.create(crossHair.global_position, crossHair.global_position + fireDirection)
	#query.exclude = firePoint.get_tree().get_nodes_in_group("Player")
	var result := space_state.intersect_ray(query)
	if result:
		print("Hit "+ str(result.collider.name))
		print(result.collider)
		if result.collider is RigidBody3D:
			result.collider.apply_force(fireDirection * knockbackForce)
		if result.collider.is_in_group("damagable"):
			result.collider.applyDamage(damage)
		
		# Put down shot hole thing (NOTE currently it is a sphere)
		#var orb = MeshInstance3D.new() # Create a new Sprite2D.
		#orb.mesh = SphereMesh.new()
		#orb.mesh.radius = 0.05
		#orb.mesh.height = 0.1
		#firePoint.get_tree().root.add_child(orb) # Add it as a child of this node.
		#orb.position = result.position
		
		return 1
	else:
		return 0
	
