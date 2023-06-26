extends Control

func _on_button_pressed():
	get_tree().reload_current_scene()
	
func set_high_score(score):
	$Panel/HighScore.text = "High score: " + str(score)

func set_score(current_score):
	$Panel/Score.text = "Score: " + str(current_score)
