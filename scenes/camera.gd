extends Camera2D

@export var target_path : NodePath = "../Player"
@export var follow_speed : float = 20.0
@export var upward_speed : float = 10.0
# simulate drag margin - 0 is screen center, 0.5 is top boundary
@export var top_margin : float = 0.25

@export var random_strength: float = 1.0
# 0.0 to shake as long as jump_charged is being emitted
@export var shake_fade: float = 0.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shaked: bool = false

var scrolling : bool = false
var has_started : bool = false

@onready var player = get_node(target_path)

func _ready():
	player.connect("jumped", _set_start_scrolling)
	player.connect("jumped", _stop_shake)
	player.connect("jump_charged", _apply_shake)
	player.connect("jump_released", _stop_shake)
	player.connect("player_killed", _set_stop_scrolling)

func _process(delta):
	var player_position = player.global_position
	var player_position_with_offset = player_position + Vector2(0, get_viewport_rect().size.y * top_margin)
	
	# only follow when moving up
	if player_position_with_offset.y < global_position.y:
		global_position.y = lerp(global_position.y, player_position_with_offset.y, follow_speed * delta)

	if scrolling:
		# steadily move the camera upwards
		global_position.y -= upward_speed * delta
		has_started = true
	
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = randomOffset()

		
func shake():
	shake_strength = random_strength
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _set_start_scrolling():
	scrolling = true
	
func _set_stop_scrolling():
	scrolling = false
	
func _apply_shake():
	if not shaked:
		shaked = true
		shake()

func _stop_shake():
	shaked = false
	shake_strength = 0.0
