extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var period:float;

var radius := 0.0;
var time := 0.0;
var angle := 0.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	radius = abs(self.get_transform().origin.z);
	self.get_parent().get_node("Control").add_spatial_icon($Icon);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta;
	
	var trans = self.get_transform() as Transform;
	
	trans.origin = radius*Vector3(sin(time*2*PI/period), 0, cos(time*2*PI/period));
	
	self.set_transform(trans)
#	self.translate(radius*Vector3(sin(), 0, cos(time*2*PI/period)))
	pass
