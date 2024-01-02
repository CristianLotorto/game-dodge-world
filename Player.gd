extends KinematicBody2D

signal hit

onready var joystick = $"../../Main/Joystick"
export (PackedScene) var preBullet
export var speed = 400 #How fast player will move (pixel/sec)
var screen_size #Size of the game window
var reloading = false
var isDead = false

func _ready():
	GlobalVariables.alive = true
	
func _physics_process(delta):
	var velocity = joystick.posVector #The player's movement vector
	
	look_at_mouse()
	
	if Input.is_action_pressed("ui_right") && !isDead:
		velocity.x += 1
	if Input.is_action_pressed("ui_left") && !isDead:
		velocity.x -= 1
	if Input.is_action_pressed("ui_up") && !isDead:
		velocity.y -= 1
	if Input.is_action_pressed("ui_down") && !isDead:
		velocity.y += 1
	if Input.is_action_pressed("ui_down") && Input.is_action_pressed("ui_left") && !isDead:
		$Pivot.position = Vector2(-3, -8)
		$Area.position = Vector2(-2, -2)
		$CollisionShape2D.position = Vector2(-1, -6)
	if Input.is_action_pressed("ui_down") && Input.is_action_pressed("ui_right") && !isDead:	
		$Pivot.position = Vector2(-3, -8)
		$Area.position = Vector2(-2, -2)
		$CollisionShape2D.position = Vector2(-1, -6)
	if velocity.x != 0 && velocity.y != 0 && !isDead:	
		$Pivot.position = Vector2(-3, -8)
		$Area.position = Vector2(-2, -2)
		$CollisionShape2D.position = Vector2(-1, -6)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	if !isDead && velocity.length() == 0:
		$AnimationPlayer.play("player_standing")
		$Pivot.position = Vector2(-3, -8)
		$Area.position = Vector2(-2, -2)
		$CollisionShape2D.position = Vector2(-1, -6)
		$Sprite.flip_v = false
	
	if velocity.x != 0:
		$AnimationPlayer.play("player_walking")
		$Sprite.flip_v = false
		$Sprite.flip_h = velocity.x < 0
		#$Pivot.position = Vector2(-3, 1)
		$Area.position = Vector2(-2, -2)
		$CollisionShape2D.position = Vector2(-1, -6)
	elif velocity.y !=0:
		$AnimationPlayer.play("player_moving_up")
		$Sprite.flip_v = velocity.y > 0
		if velocity.y > 0:
			$Pivot.position = Vector2(-3, 28)
			$Area.position = Vector2(-1, 20)
			$CollisionShape2D.position = Vector2(-2, 24)
				
	position += velocity * delta
	position.x = clamp(position.x, 30, 455)
	position.y = clamp(position.y, 40, 680)

	
	if Input.is_action_just_pressed("shoot") && !reloading && !isDead && self.visible:
		var bullet = preBullet.instance()
		get_parent().add_child(bullet)
		bullet.position = self.position
		bullet.rotate($Pivot.rotation)
		reloading = true
		$shootSound.play()
		yield(get_tree().create_timer(1.5), "timeout")
		reloading = false

	move_and_slide(velocity, Vector2(0,1))
	GlobalVariables.player_position = Vector2(self.position.x, self.position.y)
		
func start(pos):
	$AnimationPlayer.play("player_standing")
	position = pos
	isDead = false
	$Pivot.show()
	show()
	$CollisionShape2D.disabled = false

func look_at_mouse():
	var mouse_position = joystick.posVector
	if mouse_position.x != 0 || mouse_position.y != 0:
		 mouse_position = joystick.posVector *100
	else:
		mouse_position = GlobalVariables.eyePosition*100
	$Pivot.look_at(to_global(mouse_position))

func _on_Area_body_entered(body):
	if body.is_in_group("mobs") and !isDead:
		emit_signal("hit")
		$AnimationPlayer.play("player_dead")
		$Pivot.hide()
		isDead = true
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.disabled = true
		GlobalVariables.body_entered = true
		yield(get_tree().create_timer(5.0), "timeout")
		hide()
		$AnimationPlayer.stop()
