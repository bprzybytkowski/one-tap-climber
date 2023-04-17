extends Node2D

@export var falling_speed : float = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for n in get_children():
		n.position.y += falling_speed
