extends RigidBody3D
@export var isDebugMode:bool = false

@export var speed: float = 2.5 # The speed the player moves
@export var sprintMultiplier: float = 1.5 # The multiplier used while sprinting
@export var jumpPower: float = 0.5

@export var feet: Area3D; # The collison field that detects if we are standing on anything




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks the mouse to the screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Returns true if we are standing on something
func getIsGrounded():
	return $Feet.get_overlapping_bodies().size() > 1 # Greater than one because the player is included in the count

@export var label: Label
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if Input.is_action_just_pressed("toggleDebugFlight"):
		isDebugMode = !isDebugMode
		print("Debug flight "+ ("Activated!" if isDebugMode else "Deactivated!"))
	if gravity_scale != 0 if isDebugMode else 1:
		gravity_scale = 0 if isDebugMode else 1 # THIS MIGHT BE A BIT JANKY IN LEVELS SO BE CAREFUL
	
	var move_direction = Vector3.ZERO
	
	# Handle movement inputs
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		move_direction.z += 1
	if Input.is_action_pressed("move_forward"):
		move_direction.z -= 1
	
	var target_velocity = Vector3.ZERO # Temp ver for storing the velocity we will add to the character
	
	# If we are holding some move buttons, calculate velocity
	if move_direction != Vector3.ZERO:
		move_direction = move_direction.normalized()
		# Update target velocity
		target_velocity.x = move_direction.x
		target_velocity.z = move_direction.z 
		
		# 10 is multiplied onto the speed so that we have prettier speed numbers than "20"
		target_velocity = target_velocity * speed * (sprintMultiplier if Input.is_action_pressed("sprint") else 1) * 10
		
		# Rotate target velocity so that it is relative to the players look dir
		target_velocity = target_velocity.rotated(Vector3(0,1,0), character_body.basis.get_euler().y)
			
	# Use Ground movement if there is gravity && not debug mode, and EVA movement if there is no gravity
	if state.total_gravity.y != 0 && !isDebugMode:
		# Apply ground movement unless we are off the ground
		if getIsGrounded():
			# Apply some dampening to make movement more snappy and limit speed
			self.linear_damp = 2
			state.apply_force(target_velocity)
			if Input.is_action_pressed("jump"):
				if linear_velocity.y < 7:
					linear_velocity.y = 7
				else:
					# This is so that we can jump on upward moving platforms
					linear_velocity.y += 7
		else:
			# Remove dampening if we are in the air so that we keep constant linear velocity in the air
			self.linear_damp = 0
			
	else:
		if !isDebugMode:
			if self.linear_damp != 0:
				self.linear_damp = 0
			# EVA WIP movement for when there is zero gravity
			state.apply_force(target_velocity * 0.2)
			if Input.is_action_pressed("jump"):
				state.apply_force(Vector3.UP * speed)
			if Input.is_action_pressed("crouch"):
				state.apply_force(Vector3.DOWN * speed)
		else:
			if self.linear_damp != 1:
				self.linear_damp = 1
			state.linear_velocity = target_velocity * 0.8
			if Input.is_action_pressed("jump"):
				state.linear_velocity.y =  speed * 10 * 0.8
			if Input.is_action_pressed("crouch"):
				state.linear_velocity.y = -speed * 10 * 0.8
		
	#label.text = "Speed: "+str(round_to_dec(state.linear_velocity.length(), 2))
	#label.text = "Speed: "+str(Vector3(round_to_dec(state.linear_velocity.x,2),round_to_dec(state.linear_velocity.y,2),round_to_dec(state.linear_velocity.z,2)))
	label.text = "Gravity: "+str(state.total_gravity)
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

@export var MOUSE_SENSITIVITY: float = 0.3
@export var character_body: Node3D # The character model we should rotate when the camera should rotate
@onready var camera:Camera3D = get_viewport().get_camera_3d() # The current camera of the scene THIS MIGHT POSE A PROBLEM WITH MULTIPLAYER OR MULTIPLE CAMERAS SO I WILL NEED TO EDIT THIS TOO POTENTIALLY
func _input(event):
	if event is InputEventMouseMotion:
		# Rotates the view vertically
		camera.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -75, 75)
		
		# Rotates the view horizontally
		character_body.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
