extends SpringArm3D

@onready var camera: Camera3D = $Camera3D
@export var turn_rate := 200.0
@export var mouse_sensitivity := 0.07
var mouse_delta: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spring_length = camera.position.z
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle keyboard look input
	var look_input := Input.get_vector("view_right", "view_left", "view_down", "view_up")
	look_input *= turn_rate * delta
	
	# Apply rotations
	rotation_degrees.y += look_input.x + mouse_delta.x
	rotation_degrees.x += look_input.y + mouse_delta.y
	rotation_degrees.x = clampf(rotation_degrees.x, -70, 50)
	
	# Clear mouse delta after using it
	mouse_delta = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = event.relative * -mouse_sensitivity
		get_viewport().set_input_as_handled()
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
