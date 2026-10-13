class_name FakeHandInput
extends RefCounted

var hand_input: Node


func _init(target: Node) -> void:
	hand_input = target


func pinch_start() -> void:
	hand_input.emit_pinch_started()


func pinch_end() -> void:
	hand_input.emit_pinch_ended()


func poke() -> void:
	hand_input.emit_poke()
