extends Node

export (PackedScene) var mob_scene
var score = 0
var start = false
var audio_bus = AudioServer.get_bus_index("Master")

func _ready():
	new_game()
	randomize()
	

func game_over():
	$Joystick.visible = false
	$Shoot.visible = false
	$Music.stop()
	$DeathSound.play()
	yield(get_tree().create_timer(2.0), "timeout") 	
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()
	yield(get_tree().create_timer(5.0), "timeout") 
	$HUD.hide()
	GlobalScene.goto_scene("res://Main-menu.tscn")
	
func new_game():
	$HUD.show()
	$HUD.update_score(score)
	$Music.play()
	$HUD.show_before_start()
	
func _process(delta):
	if Input.is_action_just_pressed("shoot") && $HUD/LoadingBar/pressToStartLabel.visible == true:
		$HUD.hide_before_start()
		yield(get_tree().create_timer(.1), "timeout")
		start_game()

func start_game():
#	$TubeBackground.visible = true
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD/Move.hide()
	$HUD/GameInfo.hide()
	$HUD/InfoSeparator.hide()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Joystick.visible = true
	$Shoot.visible = true
	get_tree().call_group("mobs", "queue_free")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_AudioButton_pressed():
	AudioServer.set_bus_mute(audio_bus, not AudioServer.is_bus_mute(audio_bus))
	
func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.offset = randi()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	# Add some randoms to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Sawn the mob by adding it to the Main scene.
	add_child(mob)
