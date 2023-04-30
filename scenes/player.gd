extends CharacterBody2D

const SPEED = 140.0
const JUMP_VELOCITY = -480.0

var direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _on_area_2d_body_entered(body):
	if "Walls" in body.name:
		direction *= -1

func _on_resetter_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
