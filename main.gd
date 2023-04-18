extends Node2D

class_name Main

var floor = preload("res://floor.tscn")
@onready var floors_node = get_node("Floors")
@export var floorsToCreate : int = 12
var yPos : float = -56
var yPosStep : float = -64
var yContinuedPos : float
var ySubtractCound : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in floorsToCreate:
		create_new_floor(yPos)
		yPos += yPosStep
	yContinuedPos = yPos - yPosStep * ySubtractCound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_new_floor(yPos : float):
	var floor_instance = floor.instantiate()
	floor_instance.position = Vector2(0, yPos)
	floors_node.call_deferred("add_child", floor_instance)

func _on_resetter_area_entered(area):
	if "Floor" in area.name:
		area.queue_free()
		create_new_floor(yContinuedPos)
