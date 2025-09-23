extends CharacterBody3D


@export var speed := 5.0
const JUMP_VELOCITY = 4.5
@onready var run_speed := 2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("run"):
		if direction:
			velocity.x = direction.x * speed * run_speed
			velocity.z = direction.z * speed * run_speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	else:
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
#	var input_rot := Input.get_vector("turn_left", "turn_right","rotate_below","rotate_above")
	#var camera_move := (rotate * Vector2(input_rot.y, input_rot.z))
