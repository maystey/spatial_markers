extends Control
class_name SpatialMarkerManagerBase

var camera:Camera;

## Variables
#TODO: Should I make a node for each of these instead?
#down - items behind the camera mapped to bottom of screen)
#left_right - items behind the camera shown to left/right
#up_down - same as above but up/down (unlikely to be used but easy to implement)
#pole - directionally invariant (coming soon)
enum BehindCameraMap{down, left_right, up_down, pole};

export(BehindCameraMap) var behind_camera_map = BehindCameraMap.down;

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
		
#		if behind_camera_map == BehindCameraMap.down:
#			screen_pos = down_map(screen_pos, is_offscreen, is_behind);
#		elif behind_camera_map == BehindCameraMap.left_right:
#			screen_pos = left_right_map(screen_pos, is_offscreen, is_behind);
#		elif behind_camera_map == BehindCameraMap.up_down:
#			screen_pos = up_down_map(screen_pos, is_offscreen, is_behind);
		
		##Confine the uv to the bounds of the screen
		screen_pos.x = clamp(screen_pos.x, si.radius, margins.x);
		screen_pos.y = clamp(screen_pos.y, si.radius, margins.y);

		si.set_global_position(screen_pos);
		si.set_position_data(is_offscreen, is_behind, screen_pos/get_viewport_rect().size, 
								camera.get_global_transform().origin - position);

## Virtual functions
func _map(screen_position:Vector2, is_offscreen:bool, is_behind:bool) -> Vector2:
	return Vector2();

### Map Functions
#func down_map(screen_position:Vector2, is_offscreen:bool, is_behind:bool) -> Vector2:
#	if is_behind:
#		screen_position.y = get_viewport_rect().size.y;
#		return screen_position;
#	if is_offscreen:
#		if screen_position.x > 2*get_viewport_rect().size.x or screen_position.x < - get_viewport_rect().size.x: #or is_behind:
#			#Treat these cases as being behind the screen
#			screen_position.y = get_viewport_rect().size.y;
#		elif screen_position.x > get_viewport_rect().size.x:
#			#Offscreen to the right
#			#TODO: I should probably be using margins instead of viewport_rect ...
#			var x : float = screen_position.x/get_viewport_rect().size.x;
#			screen_position.y = screen_position.y*(2 - x) + get_viewport_rect().size.x*(x - 1); 
#		elif screen_position.x < 0:
#			#Offscreen to the left
#			var x : float = screen_position.x/get_viewport_rect().size.x;
#			screen_position.y = screen_position.y*(1 + x) - get_viewport_rect().size.x*x
#		#The else would contain offscreen positions inside the margins
#	return screen_position;
#
#func left_right_map(screen_position:Vector2, is_offscreen:bool, is_behind:bool):
#	if is_behind:
#		screen_position.x = _axis_map(screen_position, 0);
#	return screen_position;
#
#func up_down_map(screen_position:Vector2, is_offscreen:bool, is_behind:bool):
#	if is_behind:
#		screen_position.y = _axis_map(screen_position, 1);
#	return screen_position;
#
#func pole_map(screen_position:Vector2, is_offscreen:bool, is_behind:bool):
#	return Vector2();
#
#
#func _axis_map(position:Vector2, axis:int)->float:
#	if position[axis] < 0.5*get_viewport_rect().size[axis]:
#		return position[axis] - 0.5*get_viewport_rect().size[axis]
#	return position[axis] + 0.5*get_viewport_rect().size[axis]
#
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