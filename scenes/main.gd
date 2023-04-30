extends Node2D

class_name Main

var floor_scene = preload("res://scenes/floor.tscn")
@onready var floors_node = get_node("Floors")
@export var floorsToCreate : int = 12
var yPos : float = -96
var yPosStep : float = -96
var floor_number : int = 1
var current_score : int = 0

signal score(current_score)

func _ready():
	for n in floorsToCreate:
		create_new_floor(yPos)
		
func create_new_floor(currentYPos : float):
	var floor_instance = floor_scene.instantiate()
	# bind() method creates an additional parameter passed to the _update_score
	# function, so that it's possible to access specific floor_instance properties
	floor_instance.area_entered.connect(_update_score.bind(floor_instance))
	floor_instance.floor_number = floor_number
	floor_instance.position = Vector2(0, currentYPos)
	floors_node.call_deferred("add_child", floor_instance)
	yPos += yPosStep
	floor_number += 1

func _on_resetter_area_exited(area):
	if "Floor" in area.name:
		create_new_floor(yPos)

func _update_score(area, floor_instance):
	if area.name == "PlayerArea2D" && area.get_parent().is_on_floor() && floor_instance.floor_number > current_score:
		current_score = floor_instance.floor_number
		score.emit(current_score)
  
