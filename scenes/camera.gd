extends Camera2D

@export var target_path : NodePath = "../Player"
@export var follow_speed : float = 20.0
@export var upward_speed : float = 10.0
# simulate drag margin - 0 is screen center, 0.5 is top boundary
@export var top_margin : float = 0.25

var start_scrolling : bool = false
var has_started : bool = false

@onready var player = get_node(target_path)

func _ready():
	player.connect("jumped", _set_start_scrolling)

func _process(delta):
	var player_position = player.global_position
	var player_position_with_offset = player_position + Vector2(0, get_viewport_rect().size.y * top_margin)
	
	# only follow when moving up
	if player_position_with_offset.y < global_position.y:
		global_position.y = lerp(global_position.y, player_position_with_offset.y, follow_speed * delta)

	if start_scrolling:
		# steadily move the camera upwards
		global_position.y -= upward_speed * delta
		has_started = true

func _set_start_scrolling():
	start_scrolling = true
