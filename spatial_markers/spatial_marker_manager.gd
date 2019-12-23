extends Control
class_name SpatialMarkerManager

var camera:Camera;

##Variables
#down - items behind the camera mapped to bottom of screen)
#left_right - items behind the camera shown to left/right
#up_down - same as above but up/down (unlikely to be used but easy to implement)
#pole directionally invariant (coming soon)
enum BehindCameraMap{down, left_right, up_down, pole};

export(BehindCameraMap) var behind_camera_map = BehindCameraMap.left_right;

var spatial_icons := [];

## Functions
### Overrides
func _ready() -> void:
	camera = get_viewport().get_camera() as Camera;
#	print(get_viewport_rect().size);

func _process(delta):
	for si in spatial_icons:
		var position := si.get_spatial_position() as Vector3;
#
		var screen_pos := camera.unproject_position(position) as Vector2;
		
		var margins := (get_viewport_rect().size - Vector2(1,1)*si.radius) as Vector2;
		
		##Check if the icon is offscreen (used later)
		var is_offscreen := (screen_pos.x < si.radius or screen_pos.x > margins.x 
							or screen_pos.y < si.radius or screen_pos.y > margins.y) as bool;
		
		##Check if position is behind camera and adjust the uv
		if camera.is_position_behind(position):
			is_offscreen = true;
			screen_pos = get_viewport_rect().size - screen_pos;
			
			if behind_camera_map == BehindCameraMap.down:
				screen_pos.y = get_viewport_rect().size.y;
			if behind_camera_map == BehindCameraMap.left_right:
				screen_pos.x = _axis_map(screen_pos, 0);
			elif behind_camera_map == BehindCameraMap.up_down:
				screen_pos.y = _axis_map(screen_pos, 1);
		
		##Confine the uv to the bounds of the screen
		screen_pos.x = clamp(screen_pos.x, si.radius, margins.x);
		screen_pos.y = clamp(screen_pos.y, si.radius, margins.y);

		si.set_global_position(screen_pos);
		si.set_position_data(is_offscreen, screen_pos/get_viewport_rect().size, 
								camera.get_global_transform().origin - position);
	pass

### Map Functions
func _axis_map(position:Vector2, axis:int)->float:
	if position[axis] < 0.5*get_viewport_rect().size[axis]:
		return position[axis] - 0.5*get_viewport_rect().size[axis]
	return position[axis] + 0.5*get_viewport_rect().size[axis]

func _pole_map(position:Vector2) -> Vector2:
	if (position.x < 0 or position.x > get_viewport_rect().size.x) or\
		(position.y < 0 or position.y > get_viewport_rect().size.y):
			#Outside camera area
			return position;
	else:
		#approximate the 2*sqrt(2)?
		#Need to double check this equation!!!!!
		position = get_viewport_rect().size/(2*sqrt(2)*(position/get_viewport_rect().size - 0.5*Vector2(1,1))) + 0.5*get_viewport_rect().size;
		
		return position;

func _back_map_down(position:Vector2) -> Vector2:
	return Vector2(position.x, get_viewport_rect().size.y)

### Misc Functions
func add_spatial_icon(spatial_icon):
	spatial_icons.append(spatial_icon);
	pass