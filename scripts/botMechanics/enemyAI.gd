extends RigidBody3D


@export var current_state = EnemyState.REST
@export var target = null

@export var force = 80 # Newtons (kg*m/s^2)
@export var max_speed = 100 # m/s
@export var idle_max_speed_ratio = 0.5

var time_before_ship_leaves = 5 # seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _idle_movement():
	# this probably won't work because it switches directions every frame
	# ill work on it later
	#var random_force = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * force
	var random_force = Vector3(0,0,-1) * force # this makes the ship move forward
	self.apply_central_impulse(random_force)
	pass

func _chase_movement(delta: float):
	var directional_force = target.global_transform.origin - global_transform.origin
	self.apply_central_impulse(directional_force.normalized() * force * delta)
	pass

# This is the state machine controlling what the ship is trying to do
#
func _physics_process(delta: float) -> void:
	match(current_state):
		EnemyState.REST: _rest_state()
		EnemyState.IDLE: _idle_state()
		EnemyState.CHASE: _chase_state(delta)
	pass

func _rest_state():
	await get_tree().create_timer(time_before_ship_leaves).timeout
	current_state = EnemyState.IDLE
	return

func _idle_state():
	target = find_target()
	_idle_movement()

	if target != null:
		current_state = EnemyState.CHASE
		return

func _chase_state(delta: float):
	target = find_target()
	_chase_movement(delta)

	if target == null:
		current_state = EnemyState.IDLE
		return
	pass

func find_target():
	var target_script = preload("res://scripts/classes/Ship.gd")

	return find_node_with_script(get_tree().get_root(), target_script)

func find_node_with_script(node, script_resource):
	for child in node.get_children():
		# Check the child itself.
		if child.get_script() == script_resource:
			return child
		# Recursively search its children.
		var found = find_node_with_script(child, script_resource)
		if found:
			return found
	return null

enum EnemyState {
	REST,
	IDLE,
	CHASE
}
