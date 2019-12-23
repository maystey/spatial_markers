extends SpatialMarkerBase

onready var arrow_pivot = self.get_node("ArrowPivot");
onready var arrow = self.get_node("ArrowPivot/Arrow");
#onready var text_box = self.get_node("RichTextLabel");

##Overrides
func set_position_data(is_offscreen:bool, uv:Vector2, displacement:Vector3)->void:
	if is_offscreen:
#		text_box.text = str(uv.angle());
		arrow_pivot.set_rotation((uv - 0.5*Vector2(1,1)).angle());
		arrow.set_visible(true);
	else:
		arrow.set_visible(false);
	pass

func get_spatial_position()->Vector3:
	var parent := self.get_parent() as Spatial;
	return parent.get_global_transform().origin;