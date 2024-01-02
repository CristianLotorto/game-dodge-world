extends Sprite


var pressing = false

export var maxLength = 35
export var deadzone = 5

func _ready():
	maxLength *= get_parent().scale.x*8
	
func _process(delta):
	if pressing:
		if get_global_mouse_position().distance_to(get_parent().global_position) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			var angle = get_parent().global_position.angle_to_point(get_global_mouse_position())
			global_position.x = get_parent().global_position.x + -cos(angle)*maxLength
			global_position.y = get_parent().global_position.y + -sin(angle)*maxLength
		calculateVector()
	else:
		global_position = lerp(global_position, get_parent().global_position, delta*50)
		get_parent().posVector = Vector2(0,0)
		
func calculateVector():
	if abs((global_position.x - get_parent().global_position.x)) >= deadzone:
		get_parent().posVector.x = (global_position.x - get_parent().global_position.x)/maxLength
	if abs((global_position.y - get_parent().global_position.y)) >= deadzone:
		get_parent().posVector.y = (global_position.y - get_parent().global_position.y)/maxLength

func _on_Button_pressed():
	pressing = true


func _on_Button_released():
	pressing = false
	GlobalVariables.eyePosition = get_parent().posVector
