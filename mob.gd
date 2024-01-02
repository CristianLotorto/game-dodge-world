extends RigidBody2D

#variables for mob chasing mode and collisionable

#export var speed = 400
#var player_at_sight = false

#var forgod = false
#var mob_moving = false
#var mob_movement_coord = []

var dead = false

func _process(delta):
#	var velocity = Vector2.ZERO #The player's movement vector
	
#	if player_at_sight:
#		chase_player(velocity, delta)
	
#	if mob_moving && !player_at_sight:
#		mob_random_movement(velocity, delta)
		
	if GlobalVariables.body_entered:
		$mobAttackAnim.visible = true
		$mobMovingAnim.visible = false
		$mobAttackAnim.play("attack")
		yield(get_tree().create_timer(2.0), "timeout")
		GlobalVariables.body_entered = false
		
		
# Code for mob chase the player in sight

#func _on_visionArea_body_entered(body):
#	if body.is_in_group("player"):
#		player_at_sight = true
		
#func _on_visionArea_body_exited(body):
#	if body.is_in_group("player"):
#		player_at_sight = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	$mobMovingTimer.start()
	$mobMovingAnim.visible = true
	$mobDeathAnim.visible = false
	$mobAttackAnim.visible = false
	$mobMovingAnim.play("move")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


# Mob's movement behavior when is not chasing

#func chase_player(velocity, delta):
#	if !dead :
#		self.look_at(GlobalVariables.player_position)
#		if self.position.x - GlobalVariables.player_position.x < 0:
#			velocity.x = 1
#		else:
#			velocity.x = -1
#		if self.position.y - GlobalVariables.player_position.y < 0:
#			velocity.y = 1
#		else:
#			velocity.y = -1
			
#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed

#	position += velocity * delta
	
#	move_and_slide(velocity, Vector2(0,1))
	
#func mob_random_movement(velocity, delta):
#	if !dead:
		
#		velocity.x = mob_movement_coord[0]
#		velocity.y = mob_movement_coord[1]
			
			
#	if is_on_wall() && !player_at_sight:
#		forgod = true
		
#	if forgod == true && !player_at_sight:
#		velocity.x = -mob_movement_coord[0]
#		velocity.y = -mob_movement_coord[1]
#		yield(get_tree().create_timer(1.5), "timeout")
#		forgod = false

#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed
		
#	position += velocity * delta
	
#	self.look_at(Vector2(self.position.x + velocity.x, self.position.y + velocity.y))
	
#	move_and_slide(velocity, Vector2(0,1))
	
func _on_hitArea_area_entered(area):
	if area.is_in_group("bullet"):
		dead = true
		$enemyDeathSound.play()
		$mobMovingAnim.visible = false
		$mobDeathAnim.visible = true
		linear_velocity = Vector2(0, 0)
		$mobDeathAnim.play("death")
		
func _on_mobDeathAnim_animation_finished():
	queue_free()


#Timer for mob's moving randomly

#func _on_mobMovingTimer_timeout():
#	var mob_movement_directions = [1, 0, -1]
#	mob_movement_coord = [
#		mob_movement_directions[randi() % mob_movement_directions.size()], 
#		mob_movement_directions[randi() % mob_movement_directions.size()]
#		]
#	mob_moving = true
#	yield(get_tree().create_timer(2.0), "timeout")
#	mob_moving = false
#	$mobMovingTimer.start()

#func _on_mobAttackAnim_animation_finished():
#	GlobalVariables.body_entered = false
#	$mobMovingAnim.visible = true
#	$mobAttackAnim.visible = false
