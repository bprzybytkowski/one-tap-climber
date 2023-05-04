extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0

var direction = 1
var time_since_last_direction_change = 0

signal jumped()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	time_since_last_direction_change += delta
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		emit_signal("jumped")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _on_area_2d_body_entered(body):
	# check time_since_last_direction_change to avoid direction changing twice
	# when touching adjacent walls
	if time_since_last_direction_change > 0.1 && "Walls" in body.name:
		direction *= -1
		if direction == -1:
			get_node("Sprite2D").flip_h = true
		else:
			get_node("Sprite2D").flip_h = false
		time_since_last_direction_change = 0

func _on_resetter_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
