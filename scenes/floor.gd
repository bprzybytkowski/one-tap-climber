extends Area2D

@export var minimum_platform_width : int = 4
@export var maximum_platform_width : int = 6
@export var minimum_gap_width : int = 2
@export var maximum_gap_width : int = 3
var current_platform_width = 0
var current_gap_width = 0

func _ready():
	for child in get_children():
		if "Platform" in child.name:
			divide_floor(child)

func divide_floor(child):
	if "Platform" in child.name:
		if current_platform_width >= minimum_platform_width || current_platform_width == 0:
			if current_platform_width >= maximum_platform_width || current_gap_width < maximum_gap_width && ((current_gap_width != 0 && current_gap_width < minimum_gap_width) || randi() % 2 == 0):
				remove_child(child)
				current_platform_width = 0
				current_gap_width += 1
			else:
				current_platform_width += 1
				current_gap_width = 0
		else:
			current_platform_width += 1
