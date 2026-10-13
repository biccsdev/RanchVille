class_name PinchDetector
extends RefCounted

## Max thumb-tip to index-tip distance (meters) that counts as pinched.
const PINCH_DISTANCE_M := 0.02

var _was_pinched: bool = false


## Headless tests pass tip positions here. Live XR does not use this detector.
func is_pinched(thumb_tip: Vector3, index_tip: Vector3) -> bool:
	return thumb_tip.distance_to(index_tip) <= PINCH_DISTANCE_M


func apply(thumb_tip: Vector3, index_tip: Vector3, hand_input: Node) -> bool:
	var pinched := is_pinched(thumb_tip, index_tip)
	if pinched and not _was_pinched:
		hand_input.emit_pinch_started()
	elif not pinched and _was_pinched:
		hand_input.emit_pinch_ended()
	_was_pinched = pinched
	return pinched
