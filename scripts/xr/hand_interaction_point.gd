class_name HandInteractionPoint
extends Node3D

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
	var joint: Transform3D = hand.get_hand_joint_transform(XRHandTracker.HAND_JOINT_INDEX_FINGER_TIP)
	var origin := _xr_origin()
	if origin != null:
		global_position = origin.to_global(joint.origin)
	else:
		global_position = joint.origin
	return true


func _xr_origin() -> XROrigin3D:
	var node: Node = get_parent()
	while node != null:
		if node is XROrigin3D:
			return node as XROrigin3D
		node = node.get_parent()
	return null
