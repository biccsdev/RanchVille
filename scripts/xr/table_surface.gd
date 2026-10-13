class_name TableSurface
extends Node3D

var surface_height_m := 0.0


func setup_scene(entity: OpenXRFbSpatialEntity) -> void:
	surface_height_m = 0.0
	if entity.is_component_enabled(OpenXRFbSpatialEntity.COMPONENT_TYPE_BOUNDED_3D):
		surface_height_m = height_from_aabb(entity.get_bounding_box_3d())


func get_surface_height() -> float:
	return surface_height_m


static func height_from_aabb(box: AABB) -> float:
	return box.position.y + box.size.y
