extends SpatialMarkerManagerBase
class_name SpatialMarkerManagerSides

## Variables
#left_right - items behind the camera shown to left/right
#up_down - same as above but up/down (unlikely to be used but easy to implement)
enum BehindCameraMap{left_right, up_down};

export(BehindCameraMap) var behind_camera_map = BehindCameraMap.left_right;

## Functions
func _map(screen_position:Vector2, is_offscreen:bool, is_behind_camera:bool) -> Vector2:
	if is_behind_camera:
		if behind_camera_map == BehindCameraMap.left_right:
			screen_position.x = _axis_map(screen_position, 0);
		else:
			screen_position.y = _axis_map(screen_position, 1);
	return screen_position;

func _axis_map(position:Vector2, axis:int)->float:
	if position[axis] < 0.5*get_viewport_rect().size[axis]:
		return position[axis] - 0.5*get_viewport_rect().size[axis]
	return position[axis] + 0.5*get_viewport_rect().size[axis]