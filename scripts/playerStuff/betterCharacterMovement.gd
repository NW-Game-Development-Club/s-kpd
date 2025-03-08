extends CharacterBody3D



@export var speed: float = 5.0 # The speed the player moves
@export var sprintMultiplier: float = 1.5 # The multiplier used while sprinting
@export var jumpVelocity: float = 4.5

@export var label: Label

@export_group("Debug")
@export var isDebugMode:bool = false
@export var debugFlightSpeedModifier:float = 2

func getMovementSpeedModifier() -> float:
	return (sprintMultiplier if Input.is_action_pressed("sprint") else 1) * (debugFlightSpeedModifier if isDebugMode else 1)

var lerpStartTime = Time.get_ticks_msec()
func _physics_process(delta: float) -> void:
	var maybeFloor := get_last_slide_collision()
	if maybeFloor:
		#print(maybeFloor.get_collider() != self.get_parent() )
		if maybeFloor.get_collider() != self.get_parent() and (maybeFloor.get_collider().is_in_group("ship") or maybeFloor.get_collider().is_in_group("map")):
			self.reparent(maybeFloor.get_collider())
		self.up_direction = $"Rotation Helper".global_basis.y
	if (self.rotation != Vector3.ZERO):
		self.rotation = Vector3.ZERO
	
	# Normal Movement
	if currentVehicle == null:
		if Input.is_action_just_pressed("toggle_debug_flight"):
			isDebugMode = !isDebugMode
			$MainCollider.disabled = isDebugMode
			print("Debug flight "+ ("Activated!" if isDebugMode else "Deactivated!"))
		
		if isDebugMode:
			if Input.is_action_pressed("jump"):
				velocity.y = speed * getMovementSpeedModifier()
			elif Input.is_action_pressed("crouch"):
				velocity.y = -speed * getMovementSpeedModifier()
		else:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta

			# Handle jump.
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity += self.up_direction * jumpVelocity
				

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction: Vector3 = ($"Rotation Helper".global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#direction = direction.rotated((-get_gravity()).normalized(), character_rot_helper.basis.get_euler().y)
		if direction:
			var yVel = velocity.dot(self.up_direction)
			var applyVelocity = direction * speed * getMovementSpeedModifier()
			velocity = applyVelocity + self.up_direction * yVel
			#velocity.z = direction.z * speed * getMovementSpeedModifier()
		else:
			if isDebugMode:
				velocity.x = 0
				velocity.z = 0
				
			else:
				if is_on_floor():
					var slowedVelocity:Vector3 = Vector3(velocity.x, velocity.y, velocity.z)
					slowedVelocity -= slowedVelocity * min(delta/slowedVelocity.length()*20, 1.0)
					#slowedVelocity *= $"Rotation Helper".global_basis.y
					velocity = Vector3(slowedVelocity.x, slowedVelocity.y, slowedVelocity.z)
					pass
		
		if isDebugMode && !(Input.is_action_pressed("jump") or Input.is_action_pressed("crouch")):
			velocity.y = 0
		
		move_and_slide()
	# Ship Movement
	else:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := (currentVehicle.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if Input.is_action_pressed("jump"):
			direction.y = 1
		elif Input.is_action_pressed("crouch"):
			direction.y = -1
		#else:
			#direction.y = 0
		#direction = direction.rotated(currentVehicle.basis.y, currentVehicle.basis.get_euler().y)
		
		
			
		currentVehicle.apply_central_force(direction * currentVehicle.speed)
	#label.text = str(velocity if currentVehicle == null else currentVehicle.linear_velocity)
	label.text = "Self: "+str(velocity) + ("Parent: "+ str(get_parent().linear_velocity) if get_parent() is RigidBody3D else "")
	#label.text = str(self.get_gravity())
	#label.text = str(self.get_parent())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (GlobalVariables.captureMouse == true):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Locks the mouse to the screen
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Unlocks mouse

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

@export var MOUSE_SENSITIVITY: float = 0.3
@export var character_rot_helper: Node3D # The character model we should rotate when the camera should rotate
@onready var camera:Camera3D = get_viewport().get_camera_3d() # The current camera of the scene WARNING THIS MIGHT POSE A PROBLEM WITH MULTIPLAYER OR MULTIPLE CAMERAS SO I WILL NEED TO EDIT THIS TOO POTENTIALLY
func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if currentVehicle:
			print(str(currentVehicle.rotation_degrees))
			var horizTorque := Vector3(0, deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -100), 0) * currentVehicle.global_basis
			var vertTorque := Vector3(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -100),0,0).rotated(currentVehicle.global_basis.y, currentVehicle.basis.get_euler().y)
			
			# Rotates the ship
			currentVehicle.apply_torque(horizTorque + vertTorque)
		else:
			# Rotates the view vertically
			camera.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -75, 75)
			
			# Rotates the view horizontally
			character_rot_helper.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
			

var currentVehicle: Ship
func pilotVehicle(ship):
	self.reparent(ship)
	currentVehicle = ship
	
	
