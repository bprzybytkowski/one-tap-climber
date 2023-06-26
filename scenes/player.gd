extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const CHARGED_JUMP_VELOCITY = -470
const MAX_CHARGE_TIME = 0.8

var direction = 1
var time_since_last_direction_change = 0
var charge_timer = 0.0
var is_jump_charged = false

signal jumped()
signal player_killed()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	time_since_last_direction_change += delta
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump"):
		charge_timer += delta
		if charge_timer >= MAX_CHARGE_TIME:
			is_jump_charged = true

	if Input.is_action_just_released("jump"):
		if is_on_floor():
			if is_jump_charged:
				velocity.y = CHARGED_JUMP_VELOCITY
			else:
				velocity.y = JUMP_VELOCITY
			emit_signal("jumped")
		charge_timer = 0.0
		is_jump_charged = false
		
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
		emit_signal("player_killed")
		body.set_physics_process(false)
