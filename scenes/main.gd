extends Node2D

class_name Main

var floor_scene = preload("res://scenes/floor.tscn")
@onready var floors_node = get_node("Floors")
@export var floorsToCreate : int = 12
@onready var camera = get_node("Camera2D")
@onready var player = get_node("Player")
@onready var pause = get_node("UI/Pause")
@onready var pause_button = get_node("UI/PauseButton")
var yPosStep : float = -64
var yPos : float = yPosStep + 8 # first floor lower by a half of platform's height
var floor_number : int = 1
var current_score : int = 0
var high_score : int


signal score(score)

func _ready():
	pause.get_node("Panel/ResumeButton").connect("pressed", _on_resume_button_pressed)
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	for n in floorsToCreate:
		create_new_floor(yPos)
		
func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
		
func create_new_floor(currentYPos : float):
	var floor_instance = floor_scene.instantiate()
	# bind() method creates an additional parameter passed to the _update_score
	# function, so that it's possible to access specific floor_instance properties
	floor_instance.area_entered.connect(_update_score.bind(floor_instance))
	floor_instance.floor_number = floor_number
	floor_instance.position = Vector2(0, currentYPos)
	floors_node.call_deferred("add_child", floor_instance)
	yPos += yPosStep
	floor_number += 1

func _on_resetter_area_exited(area):
	if area.get_parent() == floors_node:
		create_new_floor(yPos)

func _update_score(area, floor_instance):
	if area.name == "PlayerArea2D" && floor_instance.floor_number > current_score:
		current_score = floor_instance.floor_number
		score.emit(current_score)

func _on_player_killed():
	# delay game over screen displaying if necessary
	# await get_tree().create_timer(0.5).timeout
	var game_over = get_node("UI/GameOver")
	if current_score > high_score:
		high_score = current_score
	game_over.set_score(current_score)
	game_over.set_high_score(high_score)
	game_over.visible = true
	pause_button.disabled = true
	save_game()
	
func _on_pause_button_pressed():
	camera.scrolling = false
	player.set_physics_process(false)
	pause.visible = true
	pause_button.disabled = true

func _on_resume_button_pressed():
	if camera.has_started:
		camera.scrolling = true
	pause.visible = false
	pause_button.disabled = false
	player.set_physics_process(true)
