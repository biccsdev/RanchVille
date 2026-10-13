class_name HandInteractionPoint
extends Node3D

const _Lookup := preload("res://scripts/xr/hand_tracker_lookup.gd")

@export var side: StringName = &"right"
@export var local_fallback: Vector3 = Vector3(0.0, 0.0, -0.08)

var _marker: MeshInstance3D
var _marker_mat: StandardMaterial3D


func _ready() -> void:
	_marker_mat = StandardMaterial3D.new()
	_marker_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_marker_mat.no_depth_test = true
	var mesh := SphereMesh.new()
	mesh.radius = 0.012
	mesh.height = 0.024
	_marker = MeshInstance3D.new()
	_marker.name = &"HandDetectMarker"
	_marker.mesh = mesh
	_marker.material_override = _marker_mat
	add_child(_marker)


func _process(_delta: float) -> void:
	var tracked := _apply_index_tip_position()
	if not tracked and get_parent() is Node3D:
		global_position = (get_parent() as Node3D).to_global(local_fallback)
	_update_marker_color(tracked)


func _apply_index_tip_position() -> bool:
	var hand: XRHandTracker = _Lookup.get_hand(side)
	if hand == null or not hand.has_tracking_data:
		return false
	var joint: Transform3D = hand.get_hand_joint_transform(XRHandTracker.HAND_JOINT_INDEX_FINGER_TIP)
	var origin := _xr_origin()
	if origin != null:
		global_position = origin.to_global(joint.origin)
	else:
		global_position = joint.origin
	return true


func _update_marker_color(hand_tracked: bool) -> void:
	if _marker_mat == null:
		return
	if hand_tracked:
		_marker_mat.albedo_color = Color(0.15, 0.95, 1.0, 1.0)
	elif get_parent() is XRController3D and (
		(get_parent() as XRController3D).get_is_active()
		or (get_parent() as XRController3D).get_has_tracking_data()
	):
		_marker_mat.albedo_color = Color(0.35, 0.35, 0.4, 1.0)
	else:
		_marker_mat.albedo_color = Color(0.15, 0.15, 0.15, 1.0)


func _xr_origin() -> XROrigin3D:
	var node: Node = get_parent()
	while node != null:
		if node is XROrigin3D:
			return node as XROrigin3D
		node = node.get_parent()
	return null
