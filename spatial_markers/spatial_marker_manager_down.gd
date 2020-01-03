extends SpatialMarkerManagerBase
class_name SpatialMarkerManagerDown

## Variables
# The offscreen margin to the left/right of the camera where the marker position remains unaltered
# the actual width of the margin is the this value multiplied by the screen width.
export(float, 0, 5) var side_margin : float = 0;

# The margin after the side_margin where the screen position is interpolated between the actual screen
# position and the corresponding position behind the camera
export(float, 0, 5) var interpolation_margin : float = 1;

## Functions
func _map(screen_position:Vector2, is_offscreen:bool, is_behind_camera:bool) -> Vector2:
	if is_behind_camera:
		screen_position.y = get_viewport_rect().size.y;
		return screen_position;
	if is_offscreen:
		if screen_position.x > (1 + side_margin + interpolation_margin)*get_viewport_rect().size.x or screen_position.x < -(side_margin + interpolation_margin)*get_viewport_rect().size.x:
#		if screen_position.x > 2*get_viewport_rect().size.x or screen_position.x < - get_viewport_rect().size.x: #or is_behind:
			#Treat these cases as being behind the screen
			screen_position.y = get_viewport_rect().size.y;
		elif screen_position.x > (1 + side_margin)*get_viewport_rect().size.x:
#		elif screen_position.x > get_viewport_rect().size.x:
			#Offscreen to the right
			#TODO: I should probably be using margins instead of viewport_rect ...
			var x : float = screen_position.x/get_viewport_rect().size.x;
			screen_position.y = screen_position.y*(2 + side_margin - x) + get_viewport_rect().size.y*(x - 1 - side_margin); 
		elif screen_position.x < -side_margin*get_viewport_rect().size.x:
#		elif screen_position.x < 0:
			#Offscreen to the left
			var x : float = screen_position.x/get_viewport_rect().size.x;
			screen_position.y = screen_position.y*(1 + side_margin + x) - get_viewport_rect().size.y*(x + side_margin);
		#The else should contain offscreen positions inside the margins
	return screen_position;