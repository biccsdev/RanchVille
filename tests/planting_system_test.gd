class_name PlantingSystemTest
extends GdUnitTestSuite

const _PlantingSystemScript := preload("res://scripts/farm/planting_system.gd")
const _GrabSystemScript := preload("res://scripts/grab/grab_system.gd")
const _SoilTileViewScript := preload("res://scripts/farm/soil_tile_view.gd")
const _SoilTileScript := preload("res://scripts/farm/soil_tile.gd")
const _SeedScene := preload("res://scenes/seed_item.tscn")
const _SoilScene := preload("res://scenes/soil_tile.tscn")
const _FakeHandInputScript := preload("res://scripts/input/fake_hand_input.gd")


func _wire_farm() -> Dictionary:
	var world := Node3D.new()
	auto_free(world)
	add_child(world)
	var right := Node3D.new()
	right.name = "RightHand"
	world.add_child(right)
	var grab: Node = _GrabSystemScript.new()
	grab.name = "GrabSystem"
	grab.right_hand_holder = right
	grab.left_hand_holder = right
	world.add_child(grab)
	var planting: Node = _PlantingSystemScript.new()
	planting.grab_system = NodePath("../GrabSystem")
	world.add_child(planting)
	await get_tree().process_frame
	var tilled: Node3D = _SoilScene.instantiate()
	tilled.start_tilled = true
	tilled.position = Vector3(0.0, 0.0, 0.0)
	world.add_child(tilled)
	var empty: Node3D = _SoilScene.instantiate()
	empty.start_tilled = false
	empty.position = Vector3(0.2, 0.0, 0.0)
	world.add_child(empty)
	var seed: Node3D = _SeedScene.instantiate()
	world.add_child(seed)
	await get_tree().process_frame
	var fake: RefCounted = _FakeHandInputScript.new(get_node("/root/HandInput"))
	return {
		"world": world,
		"right": right,
		"grab": grab,
		"planting": planting,
		"tilled": tilled,
		"empty": empty,
		"seed": seed,
		"fake": fake,
	}


func test_drop_on_tilled_plants_and_consumes_seed() -> void:
	var ctx := await _wire_farm()
	ctx["seed"].global_position = ctx["tilled"].global_position
	ctx["fake"].pinch_start(&"right")
	assert_bool(ctx["seed"].is_held()).is_true()
	ctx["right"].global_position = ctx["tilled"].global_position
	ctx["fake"].pinch_end(&"right")
	await get_tree().process_frame
	assert_int(ctx["tilled"].get_state()).is_equal(_SoilTileScript.State.PLANTED)
	assert_bool(is_instance_valid(ctx["seed"])).is_false()


func test_drop_on_empty_rejects_seed() -> void:
	var ctx := await _wire_farm()
	ctx["seed"].global_position = ctx["empty"].global_position
	ctx["fake"].pinch_start(&"right")
	ctx["right"].global_position = ctx["empty"].global_position
	ctx["fake"].pinch_end(&"right")
	await get_tree().process_frame
	assert_int(ctx["empty"].get_state()).is_equal(_SoilTileScript.State.EMPTY)
	assert_bool(is_instance_valid(ctx["seed"])).is_true()


func test_drop_on_planted_rejects_second_seed() -> void:
	var ctx := await _wire_farm()
	ctx["tilled"].try_plant()
	var seed2: Node3D = _SeedScene.instantiate()
	ctx["world"].add_child(seed2)
	await get_tree().process_frame
	seed2.global_position = ctx["tilled"].global_position
	ctx["fake"].pinch_start(&"right")
	ctx["right"].global_position = ctx["tilled"].global_position
	ctx["fake"].pinch_end(&"right")
	await get_tree().process_frame
	assert_int(ctx["tilled"].get_state()).is_equal(_SoilTileScript.State.PLANTED)
	assert_bool(is_instance_valid(seed2)).is_true()


func test_poke_on_tilled_with_held_seed_plants() -> void:
	var ctx := await _wire_farm()
	ctx["fake"].pinch_start(&"right")
	ctx["right"].global_position = ctx["tilled"].global_position
	await get_tree().process_frame
	ctx["fake"].poke(&"right")
	await get_tree().process_frame
	assert_int(ctx["tilled"].get_state()).is_equal(_SoilTileScript.State.PLANTED)
	assert_bool(is_instance_valid(ctx["seed"])).is_false()


func test_out_of_range_drop_does_not_plant() -> void:
	var ctx := await _wire_farm()
	ctx["seed"].global_position = Vector3(1.0, 0.0, 1.0)
	ctx["fake"].pinch_start(&"right")
	ctx["right"].global_position = Vector3(1.0, 0.0, 1.0)
	ctx["fake"].pinch_end(&"right")
	await get_tree().process_frame
	assert_int(ctx["tilled"].get_state()).is_equal(_SoilTileScript.State.TILLED)
	assert_bool(is_instance_valid(ctx["seed"])).is_true()


func test_planting_scripts_do_not_reference_openxr() -> void:
	for path in [
		"res://scripts/farm/planting_system.gd",
		"res://scripts/farm/seed_item.gd",
		"res://scripts/farm/soil_tile_view.gd",
	]:
		var text := FileAccess.get_file_as_string(path)
		assert_bool(text.contains("OpenXR")).is_false()
		assert_bool(text.contains("XRHand")).is_false()
