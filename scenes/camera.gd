extends Camera2D

var velocity = Vector2.ZERO
@export var camera_move_speed = 10
var player_jumped : bool

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		player_jumped = true
	if player_jumped:
		velocity.y = camera_move_speed
		offset.y -= velocity.y * delta
