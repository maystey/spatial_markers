extends KinematicBody

##Exports
export(float, 0, 20) var move_speed = 10;

export(float, 0 , 0.1) var camera_sensitivity = 0.001;
export(float, -90, 90) var camera_min_pitch = -90;
export(float, -90, 90) var camera_max_pitch = 90;

onready var camera:Camera = $Camera;

var fall_velocity :float = 0;

func _input(event: InputEvent) -> void:
	#I need to move this lower in the inheretance
	var look_direction: Vector2 = get_look_input_direction(event)
	
	if look_direction == Vector2():
		return
		
	rotate_y(-look_direction.x*camera_sensitivity)
	var camera_pitch:float = clamp(camera.get_rotation().x - 
							look_direction.y*camera_sensitivity,
							camera_min_pitch, camera_max_pitch)
	camera.set_rotation(Vector3(camera_pitch,0,0))

func _physics_process(delta: float) -> void:
	var motion :Vector3 =  get_move_input_direction()*move_speed;
	
	if is_on_floor():
		fall_velocity = 0;
	else:
		fall_velocity -= 9.8*delta;
	
	motion.y = fall_velocity;
	
	move_and_slide(motion, Vector3.UP);

func get_look_input_direction(event:InputEvent)->Vector2:
	var mouse_event := event as InputEventMouseMotion;
	
	if not mouse_event:
		return Vector2();
	
	var mouse_relative:Vector2 = mouse_event.relative;
	
	return mouse_relative;

func get_move_input_direction()->Vector3:
	var input_direction:Vector3 = Vector3()
	
	input_direction.z = (int(Input.is_action_pressed("move_back")) 
						- int(Input.is_action_pressed("move_forward")))
	input_direction.x = (int(Input.is_action_pressed("move_right"))
						- int(Input.is_action_pressed("move_left")))
	
	return self.get_transform().basis.xform(input_direction.normalized())