class_name TableAnchorPicker
extends RefCounted

const TABLE_LABEL := "table"


static func is_table_label(labels: PackedStringArray) -> bool:
	for label: String in labels:
		if label.to_lower() == TABLE_LABEL:
			return true
	return false


static func pick_nearest(
	camera_global_position: Vector3,
	candidates: Array[Node3D]
) -> Node3D:
	if candidates.is_empty():
		return null
	var best: Node3D = candidates[0]
	var best_dist_sq := camera_global_position.distance_squared_to(_node_position(best))
	for i in range(1, candidates.size()):
		var node: Node3D = candidates[i]
		var dist_sq := camera_global_position.distance_squared_to(_node_position(node))
		if dist_sq < best_dist_sq:
			best = node
			best_dist_sq = dist_sq
	return best


static func _node_position(node: Node3D) -> Vector3:
	if node.is_inside_tree():
		return node.global_position
	return node.position
