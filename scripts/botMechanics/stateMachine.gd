extends Node


var current_state = EnemyState.IDLE
var target = null
var enemy_node
var force = 100 # Newtons (kg*m/s^2)
var mass = 20 # kg

var max_speed = 100 # m/s
var idle_max_speed_ratio = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_node = get_parent()
	pass

func _idle_movement():
	# this probably won't work because it switches directions every frame
	# ill work on it later
	# var random_force = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * force
	var random_force = Vector3(1,1,1) * force # this is to check if the force is working
	enemy_node.apply_central_impulse(random_force)
	pass

func _chase_movement():
	var direction = target.global_position.origin - enemy_node.global_position.origin
	enemy_node.apply_central_impulse(direction * force)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.CHASE: _chase_state()
	pass

func _idle_state():
	target = find_target()
	_idle_movement()

	if target != null:
		current_state = EnemyState.CHASE
		return

func _chase_state():
	target = find_target()
	_chase_movement()

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
