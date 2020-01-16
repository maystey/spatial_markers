extends Control
class_name SpatialMarkerManagerBase

var camera:Camera;

## Variables
var spatial_markers := [];

## Functions
### Overrides
func _ready() -> void:
	camera = get_viewport().get_camera() as Camera;

func _process(delta):
	for si in spatial_markers:
		var position := si.get_spatial_position() as Vector3;
#
		var screen_pos := camera.unproject_position(position) as Vector2;
		
		var margins := (get_viewport_rect().size - Vector2(1,1)*si.radius) as Vector2;
		
		##Check if the icon is offscreen (used later)
		var is_offscreen := (screen_pos.x < si.radius or screen_pos.x > margins.x 
							or screen_pos.y < si.radius or screen_pos.y > margins.y) as bool;
		
		##Check if position is behind camera and adjust the uv
		var is_behind := false;
		if camera.is_position_behind(position):
			is_behind = true;
			screen_pos = get_viewport_rect().size - screen_pos; #Should this be so general?
		
		screen_pos = _map(screen_pos, is_offscreen, is_behind);
		
		##Confine the position to the bounds of the screen
		screen_pos.x = clamp(screen_pos.x, si.radius, margins.x);
		screen_pos.y = clamp(screen_pos.y, si.radius, margins.y);

		si.set_global_position(screen_pos);
		si.set_position_data(is_offscreen, is_behind, screen_pos/get_viewport_rect().size, 
								camera.get_global_transform().origin - position);

## Virtual functions
func _map(screen_position:Vector2, is_offscreen:bool, is_behind:bool) -> Vector2:
	return Vector2();

### Map Functions
#func _pole_map(position:Vector2) -> Vector2:
#	if (position.x < 0 or position.x > get_viewport_rect().size.x) or\
#		(position.y < 0 or position.y > get_viewport_rect().size.y):
#			#Outside camera area
#			return position;
#	else:
#		#approximate the 2*sqrt(2)?
#		#Need to double check this equation!!!!!
#		position = get_viewport_rect().size/(2*sqrt(2)*(position/get_viewport_rect().size - 0.5*Vector2(1,1))) + 0.5*get_viewport_rect().size;
#
#		return position;

### Misc Functions
func add_spatial_marker(spatial_marker):
	spatial_markers.append(spatial_marker);
	pass