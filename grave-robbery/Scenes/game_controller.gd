class_name GameController extends Node

@export var world_3d : Node3D
@export var world_2d : Node2D
@export var gui : Control

var current_3d_scene : Node3D
var current_2s_scene : Node2D
var current_gui_scene : Control

func _ready() -> void:
	Global.game_controller = self


func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_gui_scene != null :
		if delete:
			current_gui_scene.queue_free()
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.remove_child(current_gui_scene)
	var new : Control = load(new_scene).instantiate()
	gui.add_child(new)
	current_gui_scene = new
	
