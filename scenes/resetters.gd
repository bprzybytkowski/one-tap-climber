extends Node2D

@onready var camera_node = $"../Camera2D"

func _physics_process(_delta):
	position = camera_node.get_screen_center_position()
