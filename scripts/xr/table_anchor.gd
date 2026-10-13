class_name TableAnchor
extends Node

const _Picker := preload("res://scripts/xr/table_anchor_picker.gd")

enum Mode { SEEKING, MANUAL, PLACED }

const SETTLE_SEC := 1.0
const MARKER_SURFACE_OFFSET_Y := 0.15

var mode: Mode = Mode.SEEKING
var _capture_requested := false
var _table_candidates: Array[XRAnchor3D] = []
var _settle_generation := 0

@onready var _farm_root: Node3D = $"../FarmRoot"
@onready var _world_root: Node3D = get_parent()
@onready var _xr_origin: XROrigin3D = $"../XROrigin3D"
@onready var _camera: XRCamera3D = $"../XROrigin3D/XRCamera3D"
@onready var _scene_manager: OpenXRFbSceneManager = $"../XROrigin3D/OpenXRFbSceneManager"
@onready var _right_hand: XRController3D = $"../XROrigin3D/RightHand"
@onready var _left_hand: XRController3D = $"../XROrigin3D/LeftHand"


func _ready() -> void:
	var hand_input: Node = get_node_or_null("/root/HandInput")
	if hand_input != null:
		hand_input.poke.connect(_on_hand_poke)

	for hand: XRController3D in [_right_hand, _left_hand]:
		if hand != null:
			hand.button_pressed.connect(_on_controller_button_pressed.bind(hand))

	if not _openxr_active():
		mode = Mode.MANUAL
		return

	_scene_manager.openxr_fb_scene_anchor_created.connect(_on_scene_anchor_created)
	_scene_manager.openxr_fb_scene_data_missing.connect(_on_scene_data_missing)
	_scene_manager.openxr_fb_scene_capture_completed.connect(_on_scene_capture_completed)

	_restart_settle_timer()


func _process(_delta: float) -> void:
	if mode != Mode.MANUAL:
		return
	var hand := _active_controller()
	if hand == null:
		return
	_farm_root.global_transform = _manual_preview_transform(hand.global_transform)


func _openxr_active() -> bool:
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	return xr_interface != null and xr_interface.is_initialized()


func _active_controller() -> XRController3D:
	if _right_hand != null and _right_hand.is_active():
		return _right_hand
	if _left_hand != null and _left_hand.is_active():
		return _left_hand
	return _right_hand if _right_hand != null else _left_hand


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
	_restart_settle_timer()


func _on_controller_button_pressed(name: StringName, hand: XRController3D) -> void:
	if name == &"trigger_click" and mode == Mode.MANUAL:
		confirm_manual(hand.global_transform)


func _on_hand_poke() -> void:
	if mode != Mode.MANUAL:
		return
	var hand := _active_controller()
	if hand == null:
		return
	confirm_manual(hand.global_transform)


func enter_manual_mode() -> void:
	mode = Mode.MANUAL


func place_on_table(anchor: XRAnchor3D) -> void:
	attach_farm_to_anchor(_farm_root, anchor, MARKER_SURFACE_OFFSET_Y)
	mode = Mode.PLACED


func confirm_manual(controller_transform: Transform3D) -> void:
	lock_farm_at_transform(_farm_root, _world_root, _manual_preview_transform(controller_transform))
	mode = Mode.PLACED


func _manual_preview_transform(controller_transform: Transform3D) -> Transform3D:
	var xf := controller_transform
	xf.origin.y = maxf(xf.origin.y, 0.0)
	return xf


static func attach_farm_to_anchor(
	farm_root: Node3D,
	anchor: Node3D,
	marker_offset_y: float = MARKER_SURFACE_OFFSET_Y
) -> void:
	if farm_root.get_parent() != anchor:
		farm_root.reparent(anchor)
	farm_root.transform = Transform3D.IDENTITY
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
		marker.position = Vector3(0.0, MARKER_SURFACE_OFFSET_Y, 0.0)
