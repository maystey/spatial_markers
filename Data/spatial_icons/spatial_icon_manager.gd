extends Control
class_name SpatialIconManager

var camera:Camera;

##Variables
#y_axis items behind shown to left/right
#x_axis same as above but up/down (unlikely to be used but easy to implement)
#back_bottom items behidn mapped to bottom of screen)
#pole directionally invariant
enum BehindCameraUnwrap {down, y_axis, x_axis, pole};

export(BehindCameraUnwrap) var behind_camera_unwrap = BehindCameraUnwrap.y_axis;

var spatial_icons := []; #make this a map that uses the owner?

# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_viewport().get_camera() as Camera;
	print(get_viewport_rect().size);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for si in spatial_icons:
		var position := si.get_spatial_position() as Vector3;
#
		var screen_pos := camera.unproject_position(position) as Vector2;
		
#		var uv := _position_to_uv(si.get_spatial_position()) as Vector2;
		
#		var margins := (Vector2(1,1) - Vector2(1,1)*si.radius/get_viewport_rect().size) as Vector2;
		
		var margins := (get_viewport_rect().size - Vector2(1,1)*si.radius) as Vector2;
		
		##Check if the icon is offscreen (used later)
		var is_offscreen := (screen_pos.x < si.radius or screen_pos.x > margins.x 
							or screen_pos.y < si.radius or screen_pos.y > margins.y) as bool;
		
		##Check if position is behind camera and adjust the uv
		if camera.is_position_behind(position):
			is_offscreen = true;
#			uv = Vector2(1,1) - uv;
			screen_pos = get_viewport_rect().size - screen_pos;
			
			if behind_camera_unwrap == BehindCameraUnwrap.down:
				screen_pos.y = get_viewport_rect().size.y;
			if behind_camera_unwrap == BehindCameraUnwrap.y_axis:
				screen_pos.x = _axis_unwrap(screen_pos, 0);
			elif behind_camera_unwrap == BehindCameraUnwrap.x_axis:
				screen_pos.y = _axis_unwrap(screen_pos, 1);
		
		##Confine the uv to the bounds of the screen
		screen_pos.x = clamp(screen_pos.x, si.radius, margins.x);
		screen_pos.y = clamp(screen_pos.y, si.radius, margins.y);
#		uv.x = clamp(uv.x, si.radius, get_viewport_rect().size.x - si.radius); #include radius, need to actually do if statement for arrow
#		uv.y = clamp(uv.y, si.radius , get_viewport_rect().size.y - si.radius); #ditto
		
		si.set_global_position(screen_pos);
		si.set_position_data(is_offscreen, screen_pos/get_viewport_rect().size, 
								camera.get_global_transform().origin - position);
	pass

##Functions

#func _screen_to_uv(position:Vector2):
#	return position/get_viewport_rect().size;

func _axis_unwrap(position:Vector2, axis:int)->float:
	if position[axis] < 0.5*get_viewport_rect().size[axis]:
		return position[axis] - 0.5*get_viewport_rect().size[axis]
	return position[axis] + 0.5*get_viewport_rect().size[axis]

func _pole_unwrap(position:Vector2) -> Vector2:
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

func _axis_unwrap_uv(uv:Vector2, axis:int):
	if uv[axis] < 0.5:
		return uv[axis] - 0.5;
	return uv[axis] + 0.5;

func add_spatial_icon(spatial_icon):
	spatial_icons.append(spatial_icon);
	pass