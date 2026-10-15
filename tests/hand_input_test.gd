class_name HandInputTest
extends GdUnitTestSuite

const _HandInputScript := preload("res://scripts/input/hand_input.gd")
const _FakeHandInputScript := preload("res://scripts/input/fake_hand_input.gd")
const _HAND_INPUT_SCRIPT := "res://scripts/input/hand_input.gd"
const _FAKE_HAND_INPUT_SCRIPT := "res://scripts/input/fake_hand_input.gd"
const _CONTROLLER_MAPPING_SCRIPT := "res://scripts/input/controller_mapping.gd"
const _PROJECT_SETTINGS := "res://project.godot"


func _make_hand_input() -> Node:
	var node: Node = _HandInputScript.new()
	auto_free(node)
	return node


func _connect_counters(hand: Node) -> Dictionary:
	var counts := {"pinch_started": 0, "pinch_ended": 0, "poke": 0}
	hand.pinch_started.connect(func() -> void: counts["pinch_started"] += 1)
	hand.pinch_ended.connect(func() -> void: counts["pinch_ended"] += 1)
	hand.poke.connect(func() -> void: counts["poke"] += 1)
	return counts


func test_fake_pinch_started_fires_once() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var fake: RefCounted = _FakeHandInputScript.new(hand)
	fake.pinch_start()
	assert_int(counts["pinch_started"]).is_equal(1)
	assert_int(counts["pinch_ended"]).is_equal(0)
	assert_int(counts["poke"]).is_equal(0)


func test_fake_pinch_ended_fires_once() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var fake: RefCounted = _FakeHandInputScript.new(hand)
	fake.pinch_end()
	assert_int(counts["pinch_started"]).is_equal(0)
	assert_int(counts["pinch_ended"]).is_equal(1)
	assert_int(counts["poke"]).is_equal(0)


func test_fake_poke_fires_once() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var fake: RefCounted = _FakeHandInputScript.new(hand)
	fake.poke()
	assert_int(counts["pinch_started"]).is_equal(0)
	assert_int(counts["pinch_ended"]).is_equal(0)
	assert_int(counts["poke"]).is_equal(1)


func test_fake_pinch_sets_active_hand() -> void:
	var hand := _make_hand_input()
	var fake: RefCounted = _FakeHandInputScript.new(hand)
	fake.pinch_start(&"left")
	assert_str(String(hand.active_hand)).is_equal("left")
	fake.pinch_end(&"right")
	assert_str(String(hand.active_hand)).is_equal("right")


func test_fake_poke_fires_once_per_event() -> void:
	var hand := _make_hand_input()
	var counts := _connect_counters(hand)
	var fake: RefCounted = _FakeHandInputScript.new(hand)
	fake.poke()
	fake.poke()
	assert_int(counts["poke"]).is_equal(2)


func test_input_scripts_do_not_reference_openxr() -> void:
	for path in [_HAND_INPUT_SCRIPT, _FAKE_HAND_INPUT_SCRIPT, _CONTROLLER_MAPPING_SCRIPT]:
		var text := FileAccess.get_file_as_string(path)
		assert_bool(text.contains("OpenXR")).is_false()
		assert_bool(text.contains("XRHand")).is_false()
	for path in [_HAND_INPUT_SCRIPT, _FAKE_HAND_INPUT_SCRIPT]:
		var text := FileAccess.get_file_as_string(path)
		assert_str(text).contains("pinch_started")


func test_project_registers_hand_input_autoload() -> void:
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains('HandInput="*res://scripts/input/hand_input.gd"')
