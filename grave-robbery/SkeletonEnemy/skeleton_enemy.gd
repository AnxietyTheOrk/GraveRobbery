extends CharacterBody3D

var player : Node
var state_machine : AnimationNodeStateMachinePlayback

const SPEED = 4.0
const ATTACK_RANGE = 1.5
const VISION_RANGE = 5

@export var player_path : NodePath

@onready var nav_agent := $NavigationAgent3D
@onready var anim_tree := $AnimationTree

func _ready() -> void:
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
	# Setup navigation agent
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	
	# Wait for navigation to be ready
	call_deferred("actor_setup")

func actor_setup() -> void:
	# Wait for the first physics frame so the NavigationServer can sync
	await get_tree().physics_frame
	
	# Set initial target
	nav_agent.set_target_position(player.global_position)

func _physics_process(_delta: float) -> void:
	# Conditions 
	var visible : bool = _target_visible()
	
	var in_range : bool = _target_in_range()
	#var distance : float = global_position.distance_to(player.global_position)
	
	anim_tree.set("parameters/conditions/idle", !visible)
	if visible == true:
		anim_tree.set("parameters/conditions/attack", in_range)
		anim_tree.set("parameters/conditions/run", !in_range)
	
	
	
	
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Idle":
			pass
		"Run":
			# Update navigation target
			nav_agent.set_target_position(player.global_position)
			
			var next_nav_point : Vector3 = nav_agent.get_next_path_position()
			var direction : Vector3 = (next_nav_point - global_position).normalized()
			
			velocity = direction * SPEED
			
			# Look in movement direction
			if velocity.length() > 0.01:
				look_at(global_position + direction, Vector3.UP)
				
		"Attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	move_and_slide()


func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _target_visible() -> bool:
	return global_position.distance_to(player.global_position) <VISION_RANGE

#func _hit_finished() -> void:
	#player.hit
