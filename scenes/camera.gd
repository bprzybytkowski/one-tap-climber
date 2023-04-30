extends Camera2D

@export var target_path : NodePath = "../Player"
@export var follow_speed : float = 20.0
@export var upward_speed : float = 10.0
@export var top_margin : float = 0.25 # simulate drag margin - 0 is screen center, 0.5 is top boundary

@onready var target = get_node(target_path)

func _process(delta):
#	move target position up, so that the camera follow the player when reaching top boundary
	var target_position = target.global_position + Vector2(0, get_viewport_rect().size.y * 0.25)
	
	if target_position.y < global_position.y:  # Only follow when moving up
		global_position.y = lerp(global_position.y, target_position.y, follow_speed * delta)

	global_position.y -= upward_speed * delta  # Steadily move the camera upwards
