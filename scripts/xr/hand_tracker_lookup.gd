class_name HandTrackerLookup
extends RefCounted

const LEFT_TRACKER := &"/user/hand_tracker/left"
const RIGHT_TRACKER := &"/user/hand_tracker/right"


static func tracker_name(side: StringName) -> StringName:
	if side == &"left":
		return LEFT_TRACKER
	return RIGHT_TRACKER


static func get_hand(side: StringName) -> XRHandTracker:
	var tracker: XRTracker = XRServer.get_tracker(tracker_name(side))
	if tracker != null and tracker is XRHandTracker:
		return tracker as XRHandTracker
	return null


static func has_optical_tracking(side: StringName) -> bool:
	var hand := get_hand(side)
	if hand == null or not hand.has_tracking_data:
		return false
	if hand.hand_tracking_source == XRHandTracker.HAND_TRACKING_SOURCE_CONTROLLER:
		return false
	return true
