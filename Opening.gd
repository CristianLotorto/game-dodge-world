extends Node2D

var anim_skipped = false

func _ready():
	anim_skipped = false
	$CameraAnimation.play("camera")
	$FlaskUniverseAnimation.play("bubbling")
	$LabGuyAnimation.play("labGuyAnim")
	$FlaskUniverseAnimation/dodgerAnim.play("dodgerAnim")
	$introMusic.play()

func _process(delta):
	if Input.is_action_just_pressed("shoot") && !anim_skipped:
		skip_intro()

func skip_intro():
	$newEnvironmentAnimation/Camera2D.current = false
	if $FlaskUniverseAnimation:
		queue_free()
	anim_skipped = true
	$newEnvironmentAnimation.queue_free()
	$introMusic.stop()	


func _on_CameraAnimation_animation_finished(anim_name):
	if anim_name == 'camera':
		$FlaskUniverseAnimation.queue_free()
		$CameraAnimation.queue_free()
		$LabGuyAnimation.queue_free()
		$Background.queue_free()
		$blackboard.queue_free()
		$testTube.queue_free()
		$labTable.queue_free()
		$matraz.queue_free()
		$newEnvironmentAnimation.play("newEnvAnim")
	

func _on_newEnvironmentAnimation_animation_finished(anim_name):
	if anim_name == 'newEnvAnim':
		skip_intro()


