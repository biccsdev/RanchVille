class_name GrabSystemTest
extends GdUnitTestSuite

const _GrabSystemScript := preload("res://scripts/grab/grab_system.gd")
const _GrabbableScript := preload("res://scripts/grab/grabbable.gd")
const _FakeHandInputScript := preload("res://scripts/input/fake_hand_input.gd")


func _wire_scene() -> Dictionary:
	var world := Node3D.new()
	auto_free(world)
	add_child(world)
	var right := Node3D.new()
	right.name = "RightHand"
	right.position = Vector3.ZERO
	world.add_child(right)
	var left := Node3D.new()
	left.name = "LeftHand"
	world.add_child(left)
	var near: Node3D = _GrabbableScript.new()
	near.position = Vector3(0.1, 0.0, 0.0)
	world.add_child(near)
	var far: Node3D = _GrabbableScript.new()
	far.position = Vector3(0.5, 0.0, 0.0)
	world.add_child(far)
	var grab_system: Node = _GrabSystemScript.new()
	grab_system.left_hand_holder = left
	grab_system.right_hand_holder = right
	world.add_child(grab_system)
	var hand_input: Node = get_node("/root/HandInput")
	var fake: RefCounted = _FakeHandInputScript.new(hand_input)
	return {
		"world": world,
		"right": right,
		"near": near,
		"far": far,
		"grab_system": grab_system,
		"fake": fake,
		"hand_input": hand_input,
	}


func test_pinch_grabs_nearest_in_range() -> void:
	var ctx := _wire_scene()
	ctx["fake"].pinch_start(&"right")
	assert_object(ctx["near"].get_parent()).is_same(ctx["right"])
	assert_bool(ctx["far"].is_held()).is_false()


func test_pinch_ignores_out_of_range_only() -> void:
	var world := Node3D.new()
	auto_free(world)
	add_child(world)
	var right := Node3D.new()
	world.add_child(right)
	var only: Node3D = _GrabbableScript.new()
	only.position = Vector3(0.5, 0.0, 0.0)
	world.add_child(only)
	var grab_system: Node = _GrabSystemScript.new()
	grab_system.right_hand_holder = right
	world.add_child(grab_system)
	var fake: RefCounted = _FakeHandInputScript.new(get_node("/root/HandInput"))
	fake.pinch_start(&"right")
	assert_object(only.get_parent()).is_same(world)
	assert_bool(only.is_held()).is_false()


func test_pinch_end_releases_held_object() -> void:
	var ctx := _wire_scene()
	ctx["fake"].pinch_start(&"right")
	ctx["fake"].pinch_end(&"right")
	assert_object(ctx["near"].get_parent()).is_same(ctx["world"])
	assert_bool(ctx["near"].is_held()).is_false()


func test_left_pinch_end_does_not_release_right_hand_hold() -> void:
	var ctx := _wire_scene()
	ctx["fake"].pinch_start(&"right")
	ctx["fake"].pinch_end(&"left")
	assert_object(ctx["near"].get_parent()).is_same(ctx["right"])
	assert_bool(ctx["near"].is_held()).is_true()


func test_grab_scripts_do_not_reference_openxr() -> void:
	for path in [
		"res://scripts/grab/grab_selector.gd",
		"res://scripts/grab/grabbable.gd",
		"res://scripts/grab/grab_system.gd",
	]:
		var text := FileAccess.get_file_as_string(path)
		assert_bool(text.contains("OpenXR")).is_false()
		assert_bool(text.contains("XRHand")).is_false()
		assert_bool(text.contains("XRController")).is_false()
