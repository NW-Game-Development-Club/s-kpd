extends RigidBody3D


@export var current_state = EnemyState.IDLE
@export var target = null
var enemy_node

@export var force = 100 # Newtons (kg*m/s^2)
@export var max_speed = 100 # m/s
@export var idle_max_speed_ratio = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_node = self   # Changed: use self so add_central_force is valid
	pass

func _idle_movement(delta: float):
	# this probably won't work because it switches directions every frame
	# ill work on it later
	var random_force = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * force
	# var random_force = Vector3(1,1,1) * force # this is to check if the force is working
	enemy_node.apply_central_impulse(random_force * delta)
	pass

func _chase_movement(delta: float):
	var directional_force = target.global_transform.origin - global_transform.origin
	enemy_node.apply_central_impulse(directional_force.normalized() * force * delta)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match(current_state):
		EnemyState.IDLE: _idle_state(delta)
		EnemyState.CHASE: _chase_state(delta)
	pass

func _idle_state(delta: float):
	target = find_target()
	_idle_movement(delta)

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
	return null

enum EnemyState {
	IDLE,
	CHASE
}
