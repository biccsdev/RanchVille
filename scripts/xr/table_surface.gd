class_name TableSurface
extends Node3D

const FALLBACK_SIZE := Vector3(0.8, 0.0, 0.6)

var surface_height_m := 0.0
var surface_size := FALLBACK_SIZE


func setup_scene(entity: OpenXRFbSpatialEntity) -> void:
	surface_height_m = 0.0
	surface_size = FALLBACK_SIZE
	if entity.is_component_enabled(OpenXRFbSpatialEntity.COMPONENT_TYPE_BOUNDED_3D):
		var box: AABB = entity.get_bounding_box_3d()
		surface_height_m = height_from_aabb(box)
		surface_size = Vector3(maxf(box.size.x, 0.2), 0.0, maxf(box.size.z, 0.2))


func get_surface_height() -> float:
	return surface_height_m


func get_surface_size() -> Vector3:
	return surface_size


static func height_from_aabb(box: AABB) -> float:
	return box.position.y + box.size.y
