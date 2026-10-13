class_name FakeHandInput
extends RefCounted

var hand_input: Node


func _init(target: Node) -> void:
	hand_input = target


func pinch_start(hand: StringName = &"right") -> void:
	hand_input.active_hand = hand
	hand_input.emit_pinch_started()


func pinch_end(hand: StringName = &"right") -> void:
	hand_input.active_hand = hand
	hand_input.emit_pinch_ended()


func poke() -> void:
	hand_input.emit_poke()
