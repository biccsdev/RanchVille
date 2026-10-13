class_name GrabSelector
extends RefCounted

const _GrabbableScript := preload("res://scripts/grab/grabbable.gd")


static func pick_nearest(
	origin: Vector3,
	range_m: float,
	nodes: Array
) -> Node3D:
	var best: Node3D = null
	var best_dist_sq := INF
	for item: Variant in nodes:
		if item == null or not is_instance_valid(item):
			continue
		if not item is Node3D:
			continue
		var node := item as Node3D
		var dist_sq := origin.distance_squared_to(_node_position(node))
		if not _within_range(dist_sq, range_m):
			continue
		if dist_sq < best_dist_sq:
			best = node
			best_dist_sq = dist_sq
	return best


static func pick_nearest_grabbable(origin: Vector3, nodes: Array) -> Node3D:
	var best: Node3D = null
	var best_dist_sq := INF
	for item: Variant in nodes:
		if item == null or not is_instance_valid(item):
			continue
		if not item is Node3D:
			continue
		var grabbable := item as Node3D
		if grabbable.get_script() != _GrabbableScript:
			continue
		if grabbable.is_held():
			continue
		var range_m: float = grabbable.grab_range_m
		var dist_sq := origin.distance_squared_to(_node_position(grabbable))
		if not _within_range(dist_sq, range_m):
			continue
		if dist_sq < best_dist_sq:
			best = grabbable
			best_dist_sq = dist_sq
	return best


static func _within_range(dist_sq: float, range_m: float) -> bool:
	return dist_sq <= range_m * range_m + 0.000001


static func _node_position(node: Node3D) -> Vector3:
	if node.is_inside_tree():
		return node.global_position
	return node.position
