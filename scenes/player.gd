extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -350.0
const CHARGED_JUMP_VELOCITY = -470
const MAX_CHARGE_TIME = 0.8

var direction = 1
var time_since_last_direction_change = 0
var charge_timer = 0.0
var is_jump_pressed = false
var is_jump_released = false
var is_jump_charged = false

signal jumped()
signal player_killed()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_process_unhandled_input(true)

# used _unhandled_input to prevent jumping when interacting with menu
func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		is_jump_pressed = true
	if event.is_action_released("jump"):
			is_jump_released = true
			is_jump_pressed = false
	
func _physics_process(delta):
	time_since_last_direction_change += delta
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_jump_pressed:
		charge_timer += delta
		if charge_timer >= MAX_CHARGE_TIME:
			is_jump_charged = true

	if is_jump_released:
		if is_on_floor():
			if is_jump_charged:
				velocity.y = CHARGED_JUMP_VELOCITY
			else:
				velocity.y = JUMP_VELOCITY
			emit_signal("jumped")
		charge_timer = 0.0
		is_jump_charged = false
		is_jump_released = false
		
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
