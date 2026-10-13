class_name HandTrackerLookupTest
extends GdUnitTestSuite

const _Lookup := preload("res://scripts/xr/hand_tracker_lookup.gd")


func test_tracker_names_use_openxr_hand_tracker_paths() -> void:
	assert_str(String(_Lookup.tracker_name(&"left"))).is_equal("/user/hand_tracker/left")
	assert_str(String(_Lookup.tracker_name(&"right"))).is_equal("/user/hand_tracker/right")


func test_get_hand_returns_null_without_runtime() -> void:
	assert_object(_Lookup.get_hand(&"left")).is_null()
	assert_bool(_Lookup.has_optical_tracking(&"right")).is_false()
