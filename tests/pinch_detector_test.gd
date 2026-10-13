class_name PinchDetectorTest
extends GdUnitTestSuite

const _HandInputScript := preload("res://scripts/input/hand_input.gd")
const _PinchDetectorScript := preload("res://scripts/input/pinch_detector.gd")
const _PINCH_DETECTOR_SCRIPT := "res://scripts/input/pinch_detector.gd"


func _make_hand_input() -> Node:
	var node: Node = _HandInputScript.new()
	auto_free(node)
	return node


func _connect_counters(hand: Node) -> Dictionary:
	var counts := {"pinch_started": 0, "pinch_ended": 0}
	hand.pinch_started.connect(func() -> void: counts["pinch_started"] += 1)
	hand.pinch_ended.connect(func() -> void: counts["pinch_ended"] += 1)
	return counts


func _joints_x_separation(separation_m: float) -> Array:
	return [Vector3.ZERO, Vector3(separation_m, 0.0, 0.0)]


func test_clearly_pinched_returns_true() -> void:
	var detector: RefCounted = _PinchDetectorScript.new()
	var joints := _joints_x_separation(0.005)
	assert_bool(detector.is_pinched(joints[0], joints[1])).is_true()


func test_clearly_open_returns_false() -> void:
	var detector: RefCounted = _PinchDetectorScript.new()
	var joints := _joints_x_separation(0.08)
	assert_bool(detector.is_pinched(joints[0], joints[1])).is_false()


func test_boundary_at_threshold_is_pinched() -> void:
	var detector: RefCounted = _PinchDetectorScript.new()
	var joints := _joints_x_separation(_PinchDetectorScript.PINCH_DISTANCE_M)
	assert_bool(detector.is_pinched(joints[0], joints[1])).is_true()


func test_boundary_just_above_threshold_is_open() -> void:
	var detector: RefCounted = _PinchDetectorScript.new()
	var joints := _joints_x_separation(0.02001)
	assert_bool(detector.is_pinched(joints[0], joints[1])).is_false()


func test_apply_open_to_pinched_emits_pinch_started_once() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var detector: RefCounted = _PinchDetectorScript.new()
	var open := _joints_x_separation(0.08)
	var pinched := _joints_x_separation(0.005)
	detector.apply(open[0], open[1], hand)
	detector.apply(pinched[0], pinched[1], hand)
	assert_int(counts["pinch_started"]).is_equal(1)
	assert_int(counts["pinch_ended"]).is_equal(0)


func test_apply_pinched_to_open_emits_pinch_ended_once() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var detector: RefCounted = _PinchDetectorScript.new()
	var pinched := _joints_x_separation(0.005)
	var open := _joints_x_separation(0.08)
	detector.apply(pinched[0], pinched[1], hand)
	detector.apply(open[0], open[1], hand)
	assert_int(counts["pinch_started"]).is_equal(1)
	assert_int(counts["pinch_ended"]).is_equal(1)


func test_apply_same_state_twice_emits_no_extra_signals() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var detector: RefCounted = _PinchDetectorScript.new()
	var pinched := _joints_x_separation(0.005)
	detector.apply(pinched[0], pinched[1], hand)
	detector.apply(pinched[0], pinched[1], hand)
	assert_int(counts["pinch_started"]).is_equal(1)
	assert_int(counts["pinch_ended"]).is_equal(0)


func test_pinch_detector_script_does_not_reference_openxr() -> void:
	var text := FileAccess.get_file_as_string(_PINCH_DETECTOR_SCRIPT)
	assert_bool(text.contains("OpenXR")).is_false()
	assert_bool(text.contains("XRHand")).is_false()
