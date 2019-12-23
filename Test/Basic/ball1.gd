extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var amplitude:float;
export(float) var period:float;

var time := 0.0;
var displacement := 0.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_parent().get_node("Control").add_spatial_icon($Icon);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var trans := self.get_global_transform() as Transform;
#	trans.origin.x = amplitude*sin(time/period*2*PI);
#	self.set_global_transform(trans);
	time += delta;
	
	var deltax = amplitude*sin(time*2*PI/period) - displacement
	
	self.translate(Vector3(deltax, 0,0));
	
	displacement += deltax
	pass
