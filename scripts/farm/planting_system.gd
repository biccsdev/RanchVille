class_name PlantingSystem
extends Node

const _GrabSelector := preload("res://scripts/grab/grab_selector.gd")

@export var plant_range_m := 0.08
@export var grab_system: NodePath

var _grab: Node


func _ready() -> void:
	if grab_system.is_empty():
		_grab = get_node_or_null("../GrabSystem")
	else:
		_grab = get_node_or_null(grab_system)
	if _grab == null and get_parent() != null:
		_grab = get_parent().get_node_or_null("GrabSystem")
	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input != null and not hand_input.poke.is_connected(_on_poke):
		hand_input.poke.connect(_on_poke)
	if _grab != null and _grab.has_signal("item_released"):
		if not _grab.item_released.is_connected(_on_item_released):
			_grab.item_released.connect(_on_item_released)


func try_plant_seed_at(seed: Node3D, world_pos: Vector3) -> bool:
	if seed == null or not is_instance_valid(seed):
		return false
	if not seed.is_in_group(&"seed"):
		return false
	var tile := _pick_soil_tile(world_pos)
	if tile == null:
		return false
	if not tile.has_method("try_plant"):
		return false
	if not tile.try_plant():
		return false
	_consume_seed(seed)
	return true


func _on_item_released(item: Node3D) -> void:
	if item == null or not is_instance_valid(item):
		return
	if not item.is_in_group(&"seed"):
		return
	try_plant_seed_at(item, item.global_position)


func _on_poke() -> void:
	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input == null:
		return
	var hand: StringName = hand_input.active_hand
	var seed := _seed_for_poke(hand)
	if seed == null:
		return
	try_plant_seed_at(seed, seed.global_position)


func _seed_for_poke(hand: StringName) -> Node3D:
	if _grab != null and _grab.has_method("get_held"):
		var held: Node3D = _grab.get_held(hand)
		if held != null and held.is_in_group(&"seed"):
			return held
	var holder := _holder_for_hand(hand)
	if holder == null:
		return null
	var origin := holder.global_position if holder.is_inside_tree() else holder.position
	var candidates: Array = get_tree().get_nodes_in_group(&"seed")
	return _GrabSelector.pick_nearest(origin, plant_range_m, candidates) as Node3D


func _pick_soil_tile(world_pos: Vector3) -> Node3D:
	var candidates: Array = get_tree().get_nodes_in_group(&"soil_tile")
	return _GrabSelector.pick_nearest(world_pos, plant_range_m, candidates) as Node3D


func _holder_for_hand(hand: StringName) -> Node3D:
	if _grab == null:
		return null
	if hand == &"left":
		return _grab.left_hand_holder as Node3D
	return _grab.right_hand_holder as Node3D


func _consume_seed(seed: Node3D) -> void:
	if _grab != null and _grab.has_method("get_held"):
		for hand in [&"left", &"right"]:
			if _grab.get_held(hand) == seed:
				if _grab.has_method("release_hand"):
					_grab.release_hand(hand)
				break
	if is_instance_valid(seed):
		seed.queue_free()
