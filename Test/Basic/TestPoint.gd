extends Position3D

#export(NodePath) var camera_path:NodePath;


# Called when the node enters the scene tree for the first time.
func _ready():
#	var camera = get_node(camera_path) as Camera;
	var camera = get_viewport().get_camera() as Camera;
	
	print(self.name, camera.unproject_position(self.get_global_transform().origin));
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
