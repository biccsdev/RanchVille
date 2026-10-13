class_name HandInputXr
extends Node

const _PinchDetector := preload("res://scripts/input/pinch_detector.gd")

@onready var left_hand: XRController3D = $"../XROrigin3D/LeftHand"
@onready var right_hand: XRController3D = $"../XROrigin3D/RightHand"

var _trigger_down := {&"left": false, &"right": false}
var _pinch_left := _PinchDetector.new()
var _pinch_right := _PinchDetector.new()


func _ready() -> void:
	for hand: XRController3D in [left_hand, right_hand]:
		if hand == null:
			continue
		hand.button_pressed.connect(_on_button_pressed.bind(hand))
		hand.button_released.connect(_on_button_released.bind(hand))


func _process(_delta: float) -> void:
	_update_hand_pinch(&"left", left_hand, _pinch_left)
	_update_hand_pinch(&"right", right_hand, _pinch_right)


func _update_hand_pinch(side: StringName, hand: XRController3D, detector: PinchDetector) -> void:
	if hand == null:
		return
	if _apply_hand_pinch(side, hand, detector):
		return
	_poll_controller_pinch(hand, side)


func _apply_hand_pinch(side: StringName, hand: XRController3D, detector: PinchDetector) -> bool:
	var tracker: XRTracker = XRServer.get_tracker(hand.tracker)
	if tracker == null or not tracker is XRHandTracker:
		return false
	var ht: XRHandTracker = tracker as XRHandTracker
	if not ht.has_tracking_data:
		return false
	var thumb: Vector3 = ht.get_hand_joint_transform(XRHandTracker.HAND_JOINT_THUMB_TIP).origin
	var index: Vector3 = ht.get_hand_joint_transform(XRHandTracker.HAND_JOINT_INDEX_FINGER_TIP).origin
	var bus: Node = _hand_input()
	if bus == null:
		return false
	bus.active_hand = side
	detector.apply(thumb, index, bus)
	return true


func _hand_uses_joint_pinch(hand: XRController3D) -> bool:
	var tracker: XRTracker = XRServer.get_tracker(hand.tracker)
	if tracker == null or not tracker is XRHandTracker:
		return false
	return (tracker as XRHandTracker).has_tracking_data


func _controller_pinching(hand: XRController3D) -> bool:
	if hand.is_button_pressed(&"trigger_click"):
		return true
	if hand.is_button_pressed(&"grip_click"):
		return true
	if hand.get_float(&"trigger") > 0.6:
		return true
	if hand.get_float(&"grip") > 0.6:
		return true
	return false


func _poll_controller_pinch(hand: XRController3D, side: StringName) -> void:
	if not hand.get_is_active() and not hand.get_has_tracking_data():
		return
	var pressed: bool = _controller_pinching(hand)
	var bus: Node = _hand_input()
	if bus == null:
		return
	if pressed and not _trigger_down[side]:
		_trigger_down[side] = true
		bus.active_hand = side
		bus.emit_pinch_started()
	elif not pressed and _trigger_down[side]:
		_trigger_down[side] = false
		bus.active_hand = side
		bus.emit_pinch_ended()


func _hand_id(hand: XRController3D) -> StringName:
	if hand == left_hand:
		return &"left"
	return &"right"


func _hand_input() -> Node:
	return get_node_or_null("/root/HandInput")


func _on_button_pressed(button_name: StringName, hand: XRController3D) -> void:
	if button_name != &"trigger_click" and button_name != &"grip_click":
		return
	if _hand_uses_joint_pinch(hand):
		return
	var id := _hand_id(hand)
	if _trigger_down[id]:
		return
	_trigger_down[id] = true
	var bus := _hand_input()
	if bus == null:
		return
	bus.active_hand = id
	bus.emit_pinch_started()


func _on_button_released(button_name: StringName, hand: XRController3D) -> void:
	if button_name != &"trigger_click" and button_name != &"grip_click":
		return
	if _hand_uses_joint_pinch(hand):
		return
	if _controller_pinching(hand):
		return
	var id := _hand_id(hand)
	if not _trigger_down[id]:
		return
	_trigger_down[id] = false
	var bus := _hand_input()
	if bus == null:
		return
	bus.active_hand = id
	bus.emit_pinch_ended()
