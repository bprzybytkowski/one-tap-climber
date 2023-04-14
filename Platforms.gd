extends StaticBody2D


@export var falling_speed : float = 0.5
@export var start_falling_after : float = 5
@onready var floor : StaticBody2D = $"../Floor"
var timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer < start_falling_after:
		timer += delta
	else:
		position.y += falling_speed
		floor.position.y += falling_speed
