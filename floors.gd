extends Node2D

@export var falling_speed : float = 0.5
@export var start_falling_after : float = 5
var timer : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > start_falling_after:
		for n in get_children():
			n.position.y += falling_speed
