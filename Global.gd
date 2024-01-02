extends Node


var current_scene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	goto_scene("res://Main-menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func goto_scene(path):
	call_deferred('_deferred_goto_scene', path)
	
func _deferred_goto_scene(path):
	#now can remove the current scene
	current_scene.free()
	
	# Load the new scene
	var s = ResourceLoader.load(path)
	
	#Instance the new scene
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	
	#Optionally, to make it compatible with the SceneTree.change_scene() API.
	
	get_tree().current_scene = current_scene
