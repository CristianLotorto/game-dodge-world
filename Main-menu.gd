extends Control


export (PackedScene) var opening
export (PackedScene) var background
var intro_playing = false
var opening_scene
var background_scene

func _ready():
	$"Main-menu-music".play()
	background_scene = background.instance()
	opening_scene = opening.instance()
	add_child(background_scene)
	
func _process(delta):
	$VBoxMenu/Logo/AnimationPlayer.play("eyeBowlMoving")
	if Input.is_action_just_pressed("shoot") && intro_playing:
		skip_intro()
		
	
func _on_StartButton_pressed():
	$"Main-menu-music".stop()
	$VBoxMenu/VBoxButtons/StartButton.hide()
	$VBoxMenu/Logo/AnimationPlayer.stop()
	add_child(opening_scene)
	$introTimer.start()
	intro_playing = true
	$SkipIntro.visible = true
	yield($introTimer,"timeout")
	skip_intro()
	
	
func on_game_over():
	$VBoxMenu/Logo/AnimationPlayer.play("eyebowlMoving")
	$VBoxMenu/VBoxButtons/StartButton.show()


func _on_ExitButton_pressed():
	get_tree().quit()

func skip_intro():
	$SkipIntro.visible = false
	GlobalScene.goto_scene('res://Main.tscn')


func _on_SkipIntro_pressed():
	skip_intro()
