class_name TableAnchor
extends Node

const _Picker := preload("res://scripts/xr/table_anchor_picker.gd")

enum Mode { SEEKING, MANUAL, PLACED }

const SETTLE_SEC := 1.0
const NO_TABLE_SEC := 3.0
const SCENE_PERMISSION := "com.oculus.permission.USE_SCENE"
const MANUAL_PREVIEW_FORWARD_M := 0.7
const MANUAL_PREVIEW_DROP_M := 0.25
const HAND_HOVER_UP_M := 0.08

@export var cube_size_m := 0.075
@export var table_offset_right := 0.25
@export var table_offset_toward := 0.35

var mode: Mode = Mode.SEEKING
var _capture_requested := false
var _table_candidates: Array[XRAnchor3D] = []
var _settle_generation := 0
var _no_table_generation := 0
var _placed_anchor: Node3D
var _placed_toward := Vector3.ZERO

@onready var _farm_root: Node3D = $"../FarmRoot"
@onready var _world_root: Node3D = get_parent()
@onready var _camera: XRCamera3D = $"../XROrigin3D/XRCamera3D"
@onready var _scene_manager: OpenXRFbSceneManager = $"../XROrigin3D/OpenXRFbSceneManager"
@onready var _right_hand: XRController3D = $"../XROrigin3D/RightHand"
@onready var _left_hand: XRController3D = $"../XROrigin3D/LeftHand"


func _ready() -> void:
	_style_marker()
	if _farm_root != null:
		_farm_root.visible = true

	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input != null:
		hand_input.poke.connect(_on_hand_poke)

	for hand: XRController3D in [_right_hand, _left_hand]:
		if hand != null:
			hand.button_pressed.connect(_on_controller_button_pressed.bind(hand))

	if not _openxr_active():
		enter_manual_mode()
		return

	_scene_manager.openxr_fb_scene_anchor_created.connect(_on_scene_anchor_created)
	_scene_manager.openxr_fb_scene_data_missing.connect(_on_scene_data_missing)
	_scene_manager.openxr_fb_scene_capture_completed.connect(_on_scene_capture_completed)

	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface != null and not xr_interface.session_begun.is_connected(_on_session_begun):
		xr_interface.session_begun.connect(_on_session_begun)


func _process(_delta: float) -> void:
	if _farm_root == null:
		return
	_farm_root.visible = true
	if mode == Mode.PLACED:
		_ensure_placed_anchor()
		if _placed_anchor != null:
			_apply_placed_table_pose()
		return
	_farm_root.global_transform = _manual_preview_transform()


func _openxr_active() -> bool:
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	return xr_interface != null and xr_interface.is_initialized()


func _on_session_begun() -> void:
	if mode == Mode.PLACED:
		return
	_request_scene_permission()
	if not _scene_manager.are_scene_anchors_created():
		_scene_manager.create_scene_anchors()
	_restart_no_table_timer()


func _request_scene_permission() -> void:
	if OS.get_name() != "Android":
		return
	OS.request_permission(SCENE_PERMISSION)


func _right_hand_tracked() -> bool:
	return (
		_right_hand != null
		and (_right_hand.get_has_tracking_data() or _right_hand.get_is_active())
	)


func _on_scene_anchor_created(_scene_node: Object, spatial_entity: OpenXRFbSpatialEntity) -> void:
	if mode == Mode.PLACED:
		return
	if not _Picker.is_table_label(spatial_entity.get_semantic_labels()):
		return
	var anchor := _scene_manager.get_anchor_node(spatial_entity.uuid) as XRAnchor3D
	if anchor == null:
		return
	if anchor not in _table_candidates:
		_table_candidates.append(anchor)
	_restart_settle_timer()


func _restart_settle_timer() -> void:
	if not is_inside_tree():
		return
	_settle_generation += 1
	var generation := _settle_generation
	var timer := get_tree().create_timer(SETTLE_SEC)
	timer.timeout.connect(func() -> void: _on_settle_timeout(generation))


func _restart_no_table_timer() -> void:
	if not is_inside_tree():
		return
	_no_table_generation += 1
	var generation := _no_table_generation
	var timer := get_tree().create_timer(NO_TABLE_SEC)
	timer.timeout.connect(func() -> void: _on_no_table_timeout(generation))


func _on_settle_timeout(generation: int) -> void:
	if generation != _settle_generation:
		return
	if mode == Mode.PLACED:
		return
	if _table_candidates.is_empty():
		if mode == Mode.SEEKING:
			enter_manual_mode()
		return
	var nodes: Array[Node3D] = []
	for anchor: XRAnchor3D in _table_candidates:
		nodes.append(anchor)
	var chosen := _Picker.pick_nearest(_camera.global_position, nodes) as XRAnchor3D
	if chosen != null:
		place_on_table(chosen)


func _on_no_table_timeout(generation: int) -> void:
	if generation != _no_table_generation:
		return
	if mode != Mode.SEEKING:
		return
	if _table_candidates.is_empty():
		enter_manual_mode()


func _on_scene_data_missing() -> void:
	if mode != Mode.SEEKING:
		return
	if _capture_requested:
		enter_manual_mode()
		return
	_capture_requested = true
	if _scene_manager.is_scene_capture_supported():
		_scene_manager.request_scene_capture()
	else:
		enter_manual_mode()


func _on_scene_capture_completed(success: bool) -> void:
	if mode != Mode.SEEKING:
		return
	if not success:
		enter_manual_mode()
		return
	if _scene_manager.are_scene_anchors_created():
		_scene_manager.remove_scene_anchors()
	_table_candidates.clear()
	_scene_manager.create_scene_anchors()
	_restart_no_table_timer()


func _on_controller_button_pressed(button_name: StringName, hand: XRController3D) -> void:
	if button_name == &"trigger_click" and mode == Mode.MANUAL:
		confirm_manual(hover_over_hand(hand.global_transform))


func _on_hand_poke() -> void:
	if mode != Mode.MANUAL:
		return
	confirm_manual(_manual_preview_transform())


func _style_marker() -> void:
	if _farm_root == null:
		return
	var marker := _farm_root.get_node_or_null("Marker") as MeshInstance3D
	if marker == null:
		return
	var box := marker.mesh as BoxMesh
	if box == null:
		box = BoxMesh.new()
		marker.mesh = box
	box.size = Vector3(cube_size_m, cube_size_m, cube_size_m)
	if marker.material_override == null:
		var mat := StandardMaterial3D.new()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.albedo_color = Color(0.85, 0.85, 0.88, 1.0)
		marker.material_override = mat


func enter_manual_mode() -> void:
	mode = Mode.MANUAL
	if _farm_root != null:
		_farm_root.visible = true


func place_on_table(anchor: XRAnchor3D) -> void:
	_placed_anchor = anchor
	_placed_toward = Vector3.ZERO
	if _camera != null:
		_placed_toward = _camera.global_position - anchor.global_position
	_apply_placed_table_pose()
	if _farm_root != null:
		_farm_root.visible = true
	mode = Mode.PLACED


func _ensure_placed_anchor() -> void:
	if _placed_anchor != null and is_instance_valid(_placed_anchor):
		return
	if _farm_root == null:
		return
	var parent := _farm_root.get_parent() as Node3D
	if parent == null or parent == _world_root:
		return
	_placed_anchor = parent


func _apply_placed_table_pose() -> void:
	if _placed_anchor == null or _farm_root == null:
		return
	if not is_instance_valid(_placed_anchor):
		return
	if _placed_toward == Vector3.ZERO and _camera != null:
		_placed_toward = _camera.global_position - _placed_anchor.global_position
	var toward := _placed_toward
	var height := surface_height_from_anchor(_placed_anchor)
	var aligned := table_place_offset(
		height,
		surface_size_from_anchor(_placed_anchor),
		toward,
		table_offset_right,
		table_offset_toward
	)
	if _placed_anchor.is_inside_tree() and _farm_root.is_inside_tree():
		if _farm_root.get_parent() != _placed_anchor:
			_farm_root.reparent(_placed_anchor)
		var top := _placed_anchor.to_global(Vector3(0.0, height, 0.0))
		_farm_root.global_position = top + Vector3(aligned.x, 0.0, aligned.z)
		_farm_root.global_basis = Basis.IDENTITY
		var marker: Node3D = _farm_root.get_node_or_null("Marker") as Node3D
		if marker != null:
			marker.position = Vector3(0.0, cube_size_m * 0.5, 0.0)
	else:
		attach_farm_to_anchor(
			_farm_root,
			_placed_anchor,
			cube_size_m * 0.5,
			Vector3(aligned.x, aligned.y, aligned.z)
		)
	_style_marker()


func confirm_manual(world_transform: Transform3D) -> void:
	lock_farm_at_transform(_farm_root, _world_root, world_transform)
	if _farm_root != null:
		_farm_root.visible = true
	mode = Mode.PLACED


func _manual_preview_transform(controller_transform: Transform3D = Transform3D.IDENTITY) -> Transform3D:
	if _right_hand_tracked():
		return hover_over_hand(_right_hand.global_transform)
	if controller_transform != Transform3D.IDENTITY:
		return hover_over_hand(controller_transform)
	return _camera_preview_transform()


static func hover_over_hand(
	hand_transform: Transform3D,
	up_m: float = HAND_HOVER_UP_M
) -> Transform3D:
	return Transform3D(Basis.IDENTITY, hand_transform.origin + Vector3(0.0, up_m, 0.0))


func _camera_preview_transform() -> Transform3D:
	if _camera == null:
		return Transform3D.IDENTITY
	var forward := -_camera.global_transform.basis.z
	forward.y = 0.0
	if forward.length_squared() < 0.0001:
		forward = Vector3(0.0, 0.0, -1.0)
	else:
		forward = forward.normalized()
	var origin := _camera.global_position + forward * MANUAL_PREVIEW_FORWARD_M
	origin.y = maxf(_camera.global_position.y - MANUAL_PREVIEW_DROP_M, 0.0)
	return Transform3D(Basis.IDENTITY, origin)


static func surface_height_from_anchor(anchor: Node3D) -> float:
	for child: Node in anchor.get_children():
		if child.has_method("get_surface_height"):
			return child.get_surface_height()
	return 0.0


static func surface_size_from_anchor(anchor: Node3D) -> Vector3:
	for child: Node in anchor.get_children():
		if child.has_method("get_surface_size"):
			return child.get_surface_size()
	return Vector3(0.8, 0.0, 0.6)


static func table_place_offset(
	surface_height_m: float,
	table_size: Vector3,
	toward_flat: Vector3,
	offset_right: float = 0.25,
	offset_toward: float = 0.20
) -> Vector3:
	var toward := toward_flat
	toward.y = 0.0
	if toward.length_squared() < 0.0001:
		toward = Vector3(0.0, 0.0, 1.0)
	else:
		toward = toward.normalized()
	var right := Vector3(toward.z, 0.0, -toward.x)
	var world := right * (table_size.x * offset_right)
	world += toward * (table_size.z * offset_toward)
	return Vector3(world.x, surface_height_m, world.z)


static func attach_farm_to_anchor(
	farm_root: Node3D,
	anchor: Node3D,
	marker_offset_y: float = 0.0375,
	local_origin: Vector3 = Vector3.ZERO
) -> void:
	if farm_root.get_parent() != anchor:
		farm_root.reparent(anchor)
	farm_root.transform = Transform3D(Basis.IDENTITY, local_origin)
	var marker: Node3D = farm_root.get_node_or_null("Marker") as Node3D
	if marker != null:
		marker.position = Vector3(0.0, marker_offset_y, 0.0)


static func lock_farm_at_transform(
	farm_root: Node3D,
	world_root: Node3D,
	world_transform: Transform3D
) -> void:
	if farm_root.get_parent() != world_root:
		farm_root.reparent(world_root)
	if world_root.is_inside_tree():
		farm_root.global_transform = world_transform
	else:
		farm_root.transform = world_transform
	var marker: Node3D = farm_root.get_node_or_null("Marker") as Node3D
	if marker != null:
		marker.position = Vector3(0.0, 0.0375, 0.0)
