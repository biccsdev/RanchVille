class_name GrabSystem
extends Node

const _TableAnchorScript := preload("res://scripts/xr/table_anchor.gd")
const _GrabSelector := preload("res://scripts/grab/grab_selector.gd")

@export var left_hand_holder: Node3D
@export var right_hand_holder: Node3D
@export var table_anchor: Node

var _held: Dictionary = {}


func _ready() -> void:
	set_process(true)
	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input == null:
		return
	if not hand_input.pinch_started.is_connected(_on_pinch_started):
		hand_input.pinch_started.connect(_on_pinch_started)
	if not hand_input.pinch_ended.is_connected(_on_pinch_ended):
		hand_input.pinch_ended.connect(_on_pinch_ended)


func _grab_enabled() -> bool:
	if table_anchor == null:
		return true
	if not is_instance_valid(table_anchor):
		return true
	return (
		table_anchor.mode == _TableAnchorScript.Mode.PLACED
		or table_anchor.mode == _TableAnchorScript.Mode.MANUAL
	)


func _holder_for_hand(hand: StringName) -> Node3D:
	if hand == &"left":
		return left_hand_holder
	return right_hand_holder


func _process(_delta: float) -> void:
	_update_grab_highlights()


func _update_grab_highlights() -> void:
	var candidates: Array = get_tree().get_nodes_in_group(&"grabbable")
	var show: Dictionary = {}
	if _grab_enabled():
		for hand in [&"left", &"right"]:
			if _held.has(hand):
				continue
			var holder := _holder_for_hand(hand)
			if holder == null:
				continue
			var origin := holder.global_position if holder.is_inside_tree() else holder.position
			var target := _GrabSelector.pick_nearest_grabbable(origin, candidates)
			if target != null:
				show[target] = true
	for item: Variant in candidates:
		if item == null or not is_instance_valid(item):
			continue
		if not item.has_method("set_highlighted"):
			continue
		item.set_highlighted(show.has(item))


func _on_pinch_started() -> void:
	if not _grab_enabled():
		return
	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input == null:
		return
	var hand: StringName = hand_input.active_hand
	if _held.has(hand):
		return
	var holder := _holder_for_hand(hand)
	if holder == null:
		return
	var origin := holder.global_position if holder.is_inside_tree() else holder.position
	var candidates: Array = get_tree().get_nodes_in_group(&"grabbable")
	var target := _GrabSelector.pick_nearest_grabbable(origin, candidates)
	if target == null:
		return
	target.grab(holder)
	_held[hand] = target


func _on_pinch_ended() -> void:
	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input == null:
		return
	var hand: StringName = hand_input.active_hand
	if not _held.has(hand):
		return
	var target: Node3D = _held[hand]
	_held.erase(hand)
	if target != null and is_instance_valid(target):
		target.release()
