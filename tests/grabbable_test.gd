class_name GrabbableTest
extends GdUnitTestSuite

const _GrabbableScript := preload("res://scripts/grab/grabbable.gd")


func _add_to_tree(node: Node) -> Node3D:
	var root := Node3D.new()
	auto_free(root)
	add_child(root)
	root.add_child(node)
	return root


func test_grab_reparents_to_holder_and_keeps_world_pose() -> void:
	var world := Node3D.new()
	var holder := Node3D.new()
	var grabbable: Node3D = _GrabbableScript.new()
	_add_to_tree(world)
	world.add_child(holder)
	world.add_child(grabbable)
	grabbable.global_position = Vector3(1.0, 0.5, 2.0)
	holder.global_position = Vector3(0.0, 0.0, 0.0)

	grabbable.grab(holder)

	assert_object(grabbable.get_parent()).is_same(holder)
	assert_vector(grabbable.global_position).is_equal(Vector3(1.0, 0.5, 2.0))
	assert_bool(grabbable.is_held()).is_true()


func test_release_restores_original_parent_and_world_pose() -> void:
	var world := Node3D.new()
	var holder := Node3D.new()
	var grabbable: Node3D = _GrabbableScript.new()
	_add_to_tree(world)
	world.add_child(holder)
	world.add_child(grabbable)
	grabbable.global_position = Vector3(1.0, 0.5, 2.0)
	grabbable.grab(holder)
	holder.global_position = Vector3(3.0, 0.0, 0.0)
	var release_pos := grabbable.global_position

	grabbable.release()

	assert_object(grabbable.get_parent()).is_same(world)
	assert_vector(grabbable.global_position).is_equal(release_pos)
	assert_bool(grabbable.is_held()).is_false()


func test_set_highlighted_toggles_outline() -> void:
	var grabbable: Node3D = _GrabbableScript.new()
	_add_to_tree(grabbable)
	grabbable.set_highlighted(true)
	var outline: Node = grabbable.get_node("GrabHighlight")
	assert_bool(outline.visible).is_true()
	grabbable.set_highlighted(false)
	assert_bool(outline.visible).is_false()
