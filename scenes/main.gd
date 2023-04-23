extends Node2D

class_name Main

var floor = preload("res://scenes/floor.tscn")
@onready var floors_node = get_node("Floors")
@export var floorsToCreate : int = 12
var yPos : float = -96
var yPosStep : float = -96

func _ready():
	for n in floorsToCreate:
		create_new_floor(yPos)

func create_new_floor(currentYPos : float):
	var floor_instance = floor.instantiate()
	floor_instance.position = Vector2(0, currentYPos)
	floors_node.call_deferred("add_child", floor_instance)
	yPos += yPosStep

func _on_resetter_area_exited(area):
	if "Floor" in area.name:
		create_new_floor(yPos)

