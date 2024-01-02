extends CanvasLayer

signal start

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func game_over_message():
	$Message.text = 'Game Over'
	$Message.show()
	yield(get_tree().create_timer(6.0), "timeout") 
	$Message.hide()
	
func show_game_over():
	game_over_message();
	
func show_before_start():
	self.visible = true
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	$GameInfo.show()
	$Move.show()
	$Shoot.show()
	$InfoSeparator.show()
	$LoadingBar.visible = true
	$LoadingBar/ProgressBar.show()
	$LoadingBar/LoadingLabel.show()
	$LoadingBar/ProgressBarAnim.play("progressBar")
	yield(get_tree().create_timer(5.0),"timeout")
	$LoadingBar/ProgressBar.hide()
	$LoadingBar/LoadingLabel.hide()
	$LoadingBar/pressToStartLabel.visible = true
	$PressScreenToStart.visible = true
	
func hide_before_start():
	$LoadingBar/pressToStartLabel.visible = false
	$LoadingBar.visible = false
	$Message.hide()
	$GameInfo.hide()
	$Move.hide()
	$Shoot.hide()
	$InfoSeparator.hide()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()


func _on_PressScreenToStart_pressed():
	hide_before_start()
	emit_signal("start")
	$PressScreenToStart.visible = false
