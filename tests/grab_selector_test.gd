class_name GrabSelectorTest
extends GdUnitTestSuite

const _GrabSelectorScript := preload("res://scripts/grab/grab_selector.gd")


func test_pick_nearest_chooses_closest_in_range() -> void:
	var near := Node3D.new()
	near.position = Vector3(0.1, 0.0, 0.0)
	auto_free(near)
	var far := Node3D.new()
	far.position = Vector3(0.14, 0.0, 0.0)
	auto_free(far)
	var chosen: Node3D = _GrabSelectorScript.pick_nearest(Vector3.ZERO, 0.15, [far, near])
	assert_object(chosen).is_same(near)


func test_pick_nearest_returns_null_when_all_out_of_range() -> void:
	var node := Node3D.new()
	node.position = Vector3(0.2, 0.0, 0.0)
	auto_free(node)
	var chosen: Node3D = _GrabSelectorScript.pick_nearest(Vector3.ZERO, 0.15, [node])
	assert_object(chosen).is_null()


func test_pick_nearest_includes_boundary_at_range() -> void:
	var node := Node3D.new()
	node.position = Vector3(0.15, 0.0, 0.0)
	auto_free(node)
	var chosen: Node3D = _GrabSelectorScript.pick_nearest(Vector3.ZERO, 0.15, [node])
	assert_object(chosen).is_same(node)
