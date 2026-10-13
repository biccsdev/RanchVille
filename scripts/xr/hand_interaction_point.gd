class_name HandInteractionPoint
extends Node3D

const _Lookup := preload("res://scripts/xr/hand_tracker_lookup.gd")

@export var side: StringName = &"right"

var _marker: MeshInstance3D
var _marker_mat: StandardMaterial3D
var _hand_node: XRNode3D


func _ready() -> void:
	position = Vector3.ZERO
	_hand_node = _find_hand_node()
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
	var optical := _Lookup.has_optical_tracking(side)
	if optical and _hand_node != null and _hand_node.get_has_tracking_data():
		global_transform = _hand_node.global_transform
	else:
		transform = Transform3D.IDENTITY
	_update_marker_color(optical)


func _find_hand_node() -> XRNode3D:
	var origin := _xr_origin()
	if origin == null:
		return null
	var node_name := "LeftHandTracked" if side == &"left" else "RightHandTracked"
	return origin.get_node_or_null(node_name) as XRNode3D


func _xr_origin() -> XROrigin3D:
	var n: Node = self
	while n != null:
		if n is XROrigin3D:
			return n as XROrigin3D
		n = n.get_parent()
	return null


func _update_marker_color(hand_tracked: bool) -> void:
	if _marker_mat == null:
		return
	if hand_tracked:
		_marker_mat.albedo_color = Color(0.15, 0.95, 1.0, 1.0)
		return
	var parent_hand := get_parent() as XRController3D
	if parent_hand != null and (parent_hand.get_is_active() or parent_hand.get_has_tracking_data()):
		_marker_mat.albedo_color = Color(0.35, 0.35, 0.4, 1.0)
		return
	_marker_mat.albedo_color = Color(0.15, 0.15, 0.15, 1.0)
