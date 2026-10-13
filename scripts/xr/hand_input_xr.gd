class_name HandInputXr
extends Node

@onready var left_hand: XRController3D = $"../XROrigin3D/LeftHand"
@onready var right_hand: XRController3D = $"../XROrigin3D/RightHand"

var _trigger_down := {&"left": false, &"right": false}


func _ready() -> void:
	for hand: XRController3D in [left_hand, right_hand]:
		if hand == null:
			continue
		hand.button_pressed.connect(_on_button_pressed.bind(hand))
		hand.button_released.connect(_on_button_released.bind(hand))


func _process(_delta: float) -> void:
	_update_pinch(&"left", left_hand)
	_update_pinch(&"right", right_hand)


func _update_pinch(side: StringName, hand: XRController3D) -> void:
	_emit_pinch_edge(side, _runtime_pinching(hand))


func _runtime_pinching(hand: XRController3D) -> bool:
	if hand == null:
		return false
	if hand.is_button_pressed(&"trigger_click"):
		return true
	if hand.is_button_pressed(&"grip_click"):
		return true
	if hand.get_float(&"trigger") > 0.5:
		return true
	if hand.get_float(&"grip") > 0.5:
		return true
	return false


func _emit_pinch_edge(side: StringName, pinched: bool) -> void:
	if pinched == _trigger_down[side]:
		return
	_trigger_down[side] = pinched
	var bus: Node = _hand_input()
	if bus == null:
		return
	bus.active_hand = side
	if pinched:
		bus.emit_pinch_started()
	else:
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
	_emit_pinch_edge(_hand_id(hand), true)


func _on_button_released(button_name: StringName, hand: XRController3D) -> void:
	if button_name != &"trigger_click" and button_name != &"grip_click":
		return
	if _runtime_pinching(hand):
		return
	_emit_pinch_edge(_hand_id(hand), false)
