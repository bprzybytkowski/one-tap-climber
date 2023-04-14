extends Camera2D


@export var camera_speed : float = 0.5
@export var start_camera_movement_after : float = 5
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < start_camera_movement_after:
		timer += delta
	else:
		position.y -= camera_speed
