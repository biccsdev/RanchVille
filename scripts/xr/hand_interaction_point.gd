class_name HandInteractionPoint
extends Node3D

## OpenXR hand joint indices (index tip, thumb tip).
const _JOINT_INDEX_TIP := 8
const _JOINT_THUMB_TIP := 5

## World position used for grab range and highlight (index tip when hand tracking is active).
@export var hand_tracker_name: StringName = &"right_hand"
@export var local_fallback: Vector3 = Vector3(0.0, 0.0, -0.08)


func _process(_delta: float) -> void:
	if _apply_index_tip_position():
		return
	if get_parent() is Node3D:
		global_position = (get_parent() as Node3D).to_global(local_fallback)


func _apply_index_tip_position() -> bool:
	var tracker: XRTracker = XRServer.get_tracker(hand_tracker_name)
	if tracker == null or not tracker is XRHandTracker:
		return false
	var hand: XRHandTracker = tracker as XRHandTracker
	if not hand.has_tracking_data:
		return false
	var joint: Transform3D = hand.get_hand_joint_transform(_JOINT_INDEX_TIP)
	global_position = joint.origin
	return true
