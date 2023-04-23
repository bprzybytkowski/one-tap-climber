extends Node2D

@onready var camera_node = get_node("../Player/Camera2D")

func _physics_process(delta):
	position = camera_node.get_screen_center_position()
