extends Area2D

var walls_instance = preload("res://scenes/walls.tscn").instantiate()
@onready var walls_height : float = walls_instance.find_child("LeftWallCollisionShape").shape.extents.y * 2
@onready var walls_node : Node2D = $"../../WallsNode"
@onready var walls_height_offset = 192
@onready var current_walls_height = walls_height

func _on_body_entered(body):
	if body.get_parent() == walls_node:
		var new_walls_instance = preload("res://scenes/walls.tscn").instantiate()
		new_walls_instance.position.y = -current_walls_height - walls_height_offset
		walls_node.call_deferred("add_child", new_walls_instance, true)
		current_walls_height += walls_height
