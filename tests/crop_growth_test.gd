class_name CropGrowthTest
extends GdUnitTestSuite

const _CropDataScript := preload("res://scripts/farm/crop_data.gd")
const _CropStageScript := preload("res://scripts/farm/crop_stage.gd")
const _CropGrowthScript := preload("res://scripts/farm/crop_growth.gd")
const _FakeClockScript := preload("res://scripts/farm/fake_clock.gd")
const _WHEAT_CROP := "res://resources/crops/wheat_crop.tres"
const _CROP_SCRIPTS := [
	"res://scripts/farm/crop_data.gd",
	"res://scripts/farm/crop_stage.gd",
	"res://scripts/farm/crop_growth.gd",
	"res://scripts/farm/fake_clock.gd",
]


func _load_wheat() -> Resource:
	return load(_WHEAT_CROP) as Resource


func _make_growth(crop_data: Resource) -> RefCounted:
	var growth: RefCounted = _CropGrowthScript.new()
	growth.data = crop_data
	return growth


func _make_stage(id: StringName, duration: float, ready: bool) -> Resource:
	var stage: Resource = _CropStageScript.new()
	stage.id = id
	stage.duration_sec = duration
	stage.mesh = BoxMesh.new()
	stage.harvest_ready = ready
	return stage


func _make_crop_data(stages: Array) -> Resource:
	var data: Resource = _CropDataScript.new()
	data.crop_id = &"test"
	data.stages = stages
	return data


func test_wheat_crop_loads_with_three_stages_and_meshes() -> void:
	var wheat := _load_wheat()
	assert_object(wheat).is_not_null()
	assert_str(String(wheat.crop_id)).is_equal("wheat")
	assert_int(wheat.stages.size()).is_equal(3)
	assert_bool(wheat.is_stage_data_valid()).is_true()
	for stage in wheat.stages:
		assert_object(stage.mesh).is_not_null()
	assert_bool(wheat.stages[2].harvest_ready).is_true()


func test_watered_crop_reaches_harvest_ready_after_total_duration() -> void:
	var wheat := _load_wheat()
	var growth := _make_growth(wheat)
	var clock: RefCounted = _FakeClockScript.new()
	growth.water()
	clock.advance(wheat.total_growth_duration_sec() + 0.01)
	growth.advance(clock.elapsed_sec)
	assert_bool(growth.is_harvest_ready()).is_true()
	assert_int(growth.current_stage_index()).is_equal(2)


func test_unwatered_crop_stays_at_seed_and_not_harvest_ready() -> void:
	var wheat := _load_wheat()
	var growth := _make_growth(wheat)
	var clock: RefCounted = _FakeClockScript.new()
	clock.advance(wheat.total_growth_duration_sec() + 0.01)
	growth.advance(clock.elapsed_sec)
	assert_int(growth.current_stage_index()).is_equal(0)
	assert_bool(growth.is_harvest_ready()).is_false()
	assert_float(growth.elapsed_sec).is_equal(0.0)


func test_partial_time_after_water_lands_on_middle_stage() -> void:
	var wheat := _load_wheat()
	var growth := _make_growth(wheat)
	growth.water()
	var first_duration: float = wheat.stages[0].duration_sec
	growth.advance(first_duration + 0.5)
	assert_int(growth.current_stage_index()).is_equal(1)
	assert_bool(growth.is_harvest_ready()).is_false()


func test_extra_time_after_ready_stays_harvest_ready() -> void:
	var wheat := _load_wheat()
	var growth := _make_growth(wheat)
	growth.water()
	var total: float = wheat.total_growth_duration_sec()
	growth.advance(total + 10.0)
	assert_bool(growth.is_harvest_ready()).is_true()
	assert_int(growth.current_stage_index()).is_equal(2)


func test_invalid_stage_lists_fail_validation() -> void:
	var two_stages := _make_crop_data([
		_make_stage(&"a", 1.0, false),
		_make_stage(&"b", 1.0, true),
	])
	assert_bool(two_stages.is_stage_data_valid()).is_false()

	var ready_not_last := _make_crop_data([
		_make_stage(&"a", 1.0, true),
		_make_stage(&"b", 1.0, false),
		_make_stage(&"c", 1.0, false),
	])
	assert_bool(ready_not_last.is_stage_data_valid()).is_false()

	var no_harvest := _make_crop_data([
		_make_stage(&"a", 1.0, false),
		_make_stage(&"b", 1.0, false),
		_make_stage(&"c", 1.0, false),
	])
	assert_bool(no_harvest.is_stage_data_valid()).is_false()


func test_stage_changed_on_legal_transitions() -> void:
	var wheat := _load_wheat()
	var growth := _make_growth(wheat)
	var changes: Array = []
	growth.stage_changed.connect(
		func(from_index: int, to_index: int) -> void:
			changes.append({"from": from_index, "to": to_index})
	)
	growth.water()
	growth.advance(wheat.stages[0].duration_sec)
	growth.advance(wheat.stages[1].duration_sec)
	assert_int(changes.size()).is_equal(2)
	assert_int(changes[0]["from"]).is_equal(0)
	assert_int(changes[0]["to"]).is_equal(1)
	assert_int(changes[1]["from"]).is_equal(1)
	assert_int(changes[1]["to"]).is_equal(2)


func test_time_before_water_does_not_count() -> void:
	var wheat := _load_wheat()
	var growth := _make_growth(wheat)
	growth.advance(100.0)
	assert_float(growth.elapsed_sec).is_equal(0.0)
	growth.water()
	growth.advance(1.0)
	assert_float(growth.elapsed_sec).is_equal(1.0)


func test_crop_scripts_do_not_reference_openxr() -> void:
	for path in _CROP_SCRIPTS:
		var text := FileAccess.get_file_as_string(path)
		assert_bool(text.contains("OpenXR")).is_false()
		assert_bool(text.contains("XRHand")).is_false()
