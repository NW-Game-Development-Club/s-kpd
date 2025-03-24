extends Node


var current_state = EnemyState.IDLE
var target = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(current_state):
		EnemyState.IDLE: _idle_state()
		EnemyState.CHASE: _chase_state()
	pass

func _idle_state():
	target = find_target()

	if target != null:
		current_state = EnemyState.CHASE
		return

func _chase_state():
	target = find_target()

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
