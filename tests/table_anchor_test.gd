class_name TableAnchorTest
extends GdUnitTestSuite

const _TableAnchorPickerScript := preload("res://scripts/xr/table_anchor_picker.gd")
const _TableAnchorScript := preload("res://scripts/xr/table_anchor.gd")
const _TableSurfaceScript := preload("res://scripts/xr/table_surface.gd")
const _TABLE_ANCHOR_SCRIPT := "res://scripts/xr/table_anchor.gd"
const _TABLE_ANCHOR_PICKER_SCRIPT := "res://scripts/xr/table_anchor_picker.gd"


func test_is_table_label_accepts_table() -> void:
	assert_bool(_TableAnchorPickerScript.is_table_label(PackedStringArray(["table"]))).is_true()
	assert_bool(_TableAnchorPickerScript.is_table_label(PackedStringArray(["TABLE"]))).is_true()


func test_is_table_label_rejects_floor_and_wall() -> void:
	assert_bool(_TableAnchorPickerScript.is_table_label(PackedStringArray(["floor"]))).is_false()
	assert_bool(_TableAnchorPickerScript.is_table_label(PackedStringArray(["wall_face"]))).is_false()


func test_pick_nearest_chooses_closest_origin() -> void:
	var near := Node3D.new()
	near.position = Vector3(0.0, 0.0, 1.0)
	auto_free(near)
	var far := Node3D.new()
	far.position = Vector3(0.0, 0.0, 5.0)
	auto_free(far)
	var chosen: Node3D = _TableAnchorPickerScript.pick_nearest(Vector3.ZERO, [far, near])
	assert_object(chosen).is_same(near)


func test_attach_farm_to_anchor_parents_and_resets_local_transform() -> void:
	var anchor := Node3D.new()
	auto_free(anchor)
	var world := Node3D.new()
	auto_free(world)
	world.add_child(anchor)
	var farm := Node3D.new()
	var marker := MeshInstance3D.new()
	marker.name = "Marker"
	farm.add_child(marker)
	world.add_child(farm)
	farm.position = Vector3(9.0, 9.0, 9.0)

	_TableAnchorScript.attach_farm_to_anchor(farm, anchor)

	assert_object(farm.get_parent()).is_same(anchor)
	assert_vector(farm.position).is_equal(Vector3.ZERO)
	assert_vector(marker.position).is_equal(Vector3(0.0, 0.0375, 0.0))


func test_lock_farm_at_transform_keeps_world_pose_on_root() -> void:
	var world := Node3D.new()
	auto_free(world)
	var farm := Node3D.new()
	var marker := MeshInstance3D.new()
	marker.name = "Marker"
	farm.add_child(marker)
	world.add_child(farm)
	var target := Transform3D(Basis.IDENTITY, Vector3(1.0, 0.5, 2.0))

	_TableAnchorScript.lock_farm_at_transform(farm, world, target)

	assert_object(farm.get_parent()).is_same(world)
	assert_vector(farm.position).is_equal(Vector3(1.0, 0.5, 2.0))
	assert_vector(marker.position).is_equal(Vector3(0.0, 0.0375, 0.0))


func test_table_anchor_logic_capture_fail_enters_manual() -> void:
	var anchor: Node = _TableAnchorScript.new()
	auto_free(anchor)
	anchor.mode = _TableAnchorScript.Mode.SEEKING
	anchor._capture_requested = true
	anchor._on_scene_capture_completed(false)
	assert_int(anchor.mode).is_equal(_TableAnchorScript.Mode.MANUAL)


func test_settle_timeout_in_seeking_with_no_candidates_enters_manual() -> void:
	var anchor: Node = _TableAnchorScript.new()
	auto_free(anchor)
	anchor.mode = _TableAnchorScript.Mode.SEEKING
	anchor._settle_generation = 2
	anchor._on_settle_timeout(2)
	assert_int(anchor.mode).is_equal(_TableAnchorScript.Mode.MANUAL)


func test_settle_timeout_when_placed_is_noop() -> void:
	var anchor: Node = _TableAnchorScript.new()
	auto_free(anchor)
	anchor.mode = _TableAnchorScript.Mode.PLACED
	anchor._on_settle_timeout(1)
	assert_int(anchor.mode).is_equal(_TableAnchorScript.Mode.PLACED)


func test_settle_timeout_in_manual_with_no_candidates_stays_manual() -> void:
	var anchor: Node = _TableAnchorScript.new()
	auto_free(anchor)
	anchor.mode = _TableAnchorScript.Mode.MANUAL
	anchor._on_settle_timeout(1)
	assert_int(anchor.mode).is_equal(_TableAnchorScript.Mode.MANUAL)


func test_scene_data_missing_after_capture_requested_enters_manual() -> void:
	var anchor: Node = _TableAnchorScript.new()
	auto_free(anchor)
	anchor.mode = _TableAnchorScript.Mode.SEEKING
	anchor._capture_requested = true
	anchor._on_scene_data_missing()
	assert_int(anchor.mode).is_equal(_TableAnchorScript.Mode.MANUAL)


func test_xr_scripts_do_not_reference_openxr_in_farm_or_input() -> void:
	for path in [
		"res://scripts/farm/crop_growth.gd",
		"res://scripts/input/hand_input.gd",
	]:
		var text := FileAccess.get_file_as_string(path)
		assert_bool(text.contains("OpenXR")).is_false()


func test_table_anchor_scripts_live_under_xr_folder() -> void:
	assert_file(_TABLE_ANCHOR_SCRIPT).is_file()
	assert_file(_TABLE_ANCHOR_PICKER_SCRIPT).is_file()


func test_table_anchor_waits_for_session_before_no_table_fallback() -> void:
	var text := FileAccess.get_file_as_string(_TABLE_ANCHOR_SCRIPT)
	assert_str(text).contains("session_begun")
	assert_str(text).contains("NO_TABLE_SEC")
	assert_str(text).contains("USE_SCENE")


func test_aabb_top_is_table_surface_height() -> void:
	var box := AABB(Vector3(-0.4, -0.35, -0.3), Vector3(0.8, 0.7, 0.6))
	assert_vector(Vector3(_TableSurfaceScript.height_from_aabb(box), 0.0, 0.0)).is_equal(
		Vector3(0.35, 0.0, 0.0)
	)


func test_attach_farm_raises_to_table_surface() -> void:
	var anchor := Node3D.new()
	auto_free(anchor)
	var world := Node3D.new()
	auto_free(world)
	world.add_child(anchor)
	var farm := Node3D.new()
	var marker := MeshInstance3D.new()
	marker.name = "Marker"
	farm.add_child(marker)
	world.add_child(farm)

	_TableAnchorScript.attach_farm_to_anchor(farm, anchor, 0.0375, 0.35)

	assert_vector(farm.position).is_equal(Vector3(0.0, 0.35, 0.0))
	assert_vector(marker.position).is_equal(Vector3(0.0, 0.0375, 0.0))


func test_no_table_timeout_in_seeking_enters_manual() -> void:
	var anchor: Node = _TableAnchorScript.new()
	auto_free(anchor)
	anchor.mode = _TableAnchorScript.Mode.SEEKING
	anchor._no_table_generation = 4
	anchor._on_no_table_timeout(4)
	assert_int(anchor.mode).is_equal(_TableAnchorScript.Mode.MANUAL)
