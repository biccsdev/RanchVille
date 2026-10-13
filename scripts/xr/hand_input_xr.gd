class_name HandInputXr
extends Node

@export var left_hand: XRController3D
@export var right_hand: XRController3D

var _trigger_down := {&"left": false, &"right": false}


func _ready() -> void:
	for hand: XRController3D in [left_hand, right_hand]:
		if hand == null:
			continue
		hand.button_pressed.connect(_on_button_pressed.bind(hand))
		hand.button_released.connect(_on_button_released.bind(hand))


func _hand_id(hand: XRController3D) -> StringName:
	if hand == left_hand:
		return &"left"
	return &"right"


func _hand_input() -> Node:
	return get_node_or_null("/root/HandInput")


func _on_button_pressed(button_name: StringName, hand: XRController3D) -> void:
	if button_name != &"trigger_click":
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
	if button_name != &"trigger_click":
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
