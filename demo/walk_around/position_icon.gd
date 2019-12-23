extends SpatialMarkerBase;

export(NodePath) var manager:NodePath;
export(String) var nameplate:String;
export(bool) var show_displacement:bool = true;

onready var arrow:Sprite = self.get_node("Arrow");
onready var marker:Sprite = self.get_node("Arrow2");
onready var name_plate:RichTextLabel = self.get_node("Name");
#onready var text_box = self.get_node("RichTextLabel");

##Overrides
func _ready() -> void:
	get_node(manager).add_spatial_icon(self);

func set_position_data(is_offscreen:bool, uv:Vector2, displacement:Vector3)->void:
	if is_offscreen:
#		text_box.text = str(uv.angle());
		arrow.set_rotation((uv - 0.5*Vector2(1,1)).angle() + PI/2);
		arrow.set_visible(true);
		marker.set_visible(false);
		name_plate.set_visible(false);
	else:
		arrow.set_visible(false);
		marker.set_visible(true);
		name_plate.set_visible(true);
		
		name_plate.text = nameplate;
		if show_displacement:
			name_plate.text += " [" + str(round(displacement.length())) + "m]";
		
func get_spatial_position()->Vector3:
	var parent := self.get_parent() as Spatial;
	return parent.get_global_transform().origin;