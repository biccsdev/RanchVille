class_name Grabbable
extends Node3D

@export var grab_range_m := 0.28

var _holder: Node3D
var _original_parent: Node
var _highlight: MeshInstance3D


func _ready() -> void:
	add_to_group(&"grabbable")
	_setup_highlight()


func set_highlighted(on: bool) -> void:
	if _highlight != null:
		_highlight.visible = on


func _setup_highlight() -> void:
	var mesh_node := get_node_or_null("Mesh") as MeshInstance3D
	var size := Vector3(0.075, 0.075, 0.075)
	if mesh_node != null and mesh_node.mesh is BoxMesh:
		size = (mesh_node.mesh as BoxMesh).size
	_highlight = MeshInstance3D.new()
	_highlight.name = &"GrabHighlight"
	var outline := BoxMesh.new()
	var pad := 0.012
	outline.size = size + Vector3(pad, pad, pad)
	_highlight.mesh = outline
	if mesh_node != null:
		_highlight.transform = mesh_node.transform
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 0.92, 0.35, 0.45)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_highlight.material_override = mat
	_highlight.visible = false
	add_child(_highlight)


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
