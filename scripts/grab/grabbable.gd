class_name Grabbable
extends Node3D

@export var grab_range_m := 0.15

var _holder: Node3D
var _original_parent: Node


func _ready() -> void:
	add_to_group(&"grabbable")


func is_held() -> bool:
	return _holder != null and is_instance_valid(_holder)


func get_holder() -> Node3D:
	return _holder


func grab(holder: Node3D) -> void:
	if holder == null or is_held():
		return
	_original_parent = get_parent()
	_holder = holder
	var world := global_transform
	reparent(holder)
	if is_inside_tree():
		global_transform = world
	else:
		transform = holder.global_transform.affine_inverse() * world


func release() -> void:
	if not is_held():
		return
	var world := global_transform
	var parent := _original_parent
	_holder = null
	_original_parent = null
	if parent == null or not is_instance_valid(parent):
		return
	reparent(parent)
	if is_inside_tree():
		global_transform = world
	else:
		transform = parent.global_transform.affine_inverse() * world
