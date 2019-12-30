extends Node2D
class_name SpatialMarkerBase

##Variables
export(float) var radius:float setget set_radius, get_radius; #Make a visual widdget for this

export(Vector3) var spatial_position:Vector3 setget set_spatial_position, get_spatial_position;

func _ready() -> void:
	pass

##Functions
func set_position_data(is_offscreen:bool, is_behind_camera:bool, uv:Vector2, displacement:Vector3) -> void: 
	pass

##Setters and getters
func set_spatial_position(value:Vector3) -> void:
	spatial_position = value;
	
func get_spatial_position() -> Vector3:
	return Vector3();

func set_radius(value) -> void:
	radius = value;

func get_radius() -> float:
	return radius;