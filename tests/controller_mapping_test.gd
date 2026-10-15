class_name ControllerMappingTest
extends GdUnitTestSuite

const _ControllerMappingScript := preload("res://scripts/input/controller_mapping.gd")
const _CONTROLLER_MAPPING_SCRIPT := "res://scripts/input/controller_mapping.gd"


func test_pinch_buttons_are_trigger_and_grip_click() -> void:
	assert_bool(_ControllerMappingScript.is_pinch_button(&"trigger_click")).is_true()
	assert_bool(_ControllerMappingScript.is_pinch_button(&"grip_click")).is_true()
	assert_bool(_ControllerMappingScript.is_pinch_button(&"ax_button")).is_false()


func test_poke_button_is_ax_only() -> void:
	assert_bool(_ControllerMappingScript.is_poke_button(&"ax_button")).is_true()
	assert_bool(_ControllerMappingScript.is_poke_button(&"trigger_click")).is_false()
	assert_bool(_ControllerMappingScript.is_poke_button(&"grip_click")).is_false()


func test_is_pinching_from_clicks() -> void:
	assert_bool(
		_ControllerMappingScript.is_pinching(true, false, 0.0, 0.0),
	).is_true()
	assert_bool(
		_ControllerMappingScript.is_pinching(false, true, 0.0, 0.0),
	).is_true()


func test_is_pinching_from_analog_above_threshold() -> void:
	assert_bool(
		_ControllerMappingScript.is_pinching(false, false, 0.51, 0.0),
	).is_true()
	assert_bool(
		_ControllerMappingScript.is_pinching(false, false, 0.0, 0.51),
	).is_true()


func test_is_pinching_false_at_analog_threshold_inclusive() -> void:
	assert_bool(
		_ControllerMappingScript.is_pinching(false, false, 0.5, 0.5),
	).is_false()


func test_controller_mapping_script_has_no_openxr() -> void:
	var text := FileAccess.get_file_as_string(_CONTROLLER_MAPPING_SCRIPT)
	assert_bool(text.contains("OpenXR")).is_false()
	assert_bool(text.contains("XRController")).is_false()
