extends Area2D

@export var minimum_platform_width : int = 3
@export var maximum_platform_width : int = 6
@export var minimum_gap_width : int = 2
@export var maximum_gap_width : int = 3
var current_platform_width = 0
var current_gap_width = 0
var floor_number : int
var floor_width : int
var children : Array[Node]
var nodes_to_delete = []

func _ready():
	children = get_children()
#	filter out any nodes different than Platform
	children = children.filter(is_platform)
	floor_width = len(children)
	
	var i = 0
	while i < floor_width:
		var child = children[i]
		if generate_floor(child, i):
			i = 0
		else:
			i += 1
	for node in nodes_to_delete:
		remove_child(node)

func generate_floor(child, i) -> bool:
	var should_repeat : bool
	if "Platform" in child.name:
		if current_platform_width >= minimum_platform_width || current_platform_width == 0:
			if current_platform_width >= maximum_platform_width || current_gap_width < maximum_gap_width && ((current_gap_width != 0 && current_gap_width < minimum_gap_width) || randi() % 2 == 0):
				nodes_to_delete.append(child)
				current_platform_width = 0
				current_gap_width += 1
			else:
				current_platform_width += 1
				current_gap_width = 0
		else:
			current_platform_width += 1
	if i == floor_width - 1 && is_last_element_valid():
		should_repeat = true
		nodes_to_delete = []
		current_gap_width = 0
		current_platform_width = 0
	return should_repeat

func is_platform(element) -> bool:
	return "Platform" in element.name

func is_last_element_valid() -> bool:
	return (current_gap_width != 0 && current_gap_width < minimum_gap_width) || (current_platform_width > 0 && current_platform_width < minimum_platform_width)
