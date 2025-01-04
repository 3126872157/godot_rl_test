extends CanvasLayer

func show_message(text):
	$Message.text = text
	$Message.show()
	
func show_game_over():
	show_message("Game Over")
	$Message.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
