extends SpringArm3D

@onready var camera: Camera3D = $Camera3D
@export var turn_rate := 200.0
@export var mouse_sensitivity := 0.07

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spring_length = camera.position.z
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var look_input := Input.get_vector("view_right", "view_left", "view_down", "view_up")
	look_input = turn_rate * look_input * delta

	rotation_degrees.x += look_input.y
	rotation_degrees.y += look_input.x
	rotation_degrees.x = clampf(rotation_degrees.x, -70, 50)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_delta: Vector2 = event.relative * -mouse_sensitivity
		rotation_degrees.y += mouse_delta.x
		rotation_degrees.x += mouse_delta.y
		rotation_degrees.x = clampf(rotation_degrees.x, -70, 50)
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
