class_name SoilTileViewTest
extends GdUnitTestSuite

const _SoilTileScript := preload("res://scripts/farm/soil_tile.gd")
const _SoilScene := preload("res://scenes/soil_tile.tscn")


func _add_tile(start_tilled: bool) -> Node3D:
	var tile: Node3D = _SoilScene.instantiate()
	tile.start_tilled = start_tilled
	var root := Node3D.new()
	auto_free(root)
	add_child(root)
	root.add_child(tile)
	return tile


func test_starts_empty_when_not_tilled() -> void:
	var tile := _add_tile(false)
	await get_tree().process_frame
	assert_int(tile.get_state()).is_equal(_SoilTileScript.State.EMPTY)
	var bump: Node = tile.get_node("SeedBump")
	assert_bool(bump.visible).is_false()


func test_starts_tilled_when_flag_set() -> void:
	var tile := _add_tile(true)
	await get_tree().process_frame
	assert_int(tile.get_state()).is_equal(_SoilTileScript.State.TILLED)


func test_try_plant_shows_bump() -> void:
	var tile := _add_tile(true)
	await get_tree().process_frame
	assert_bool(tile.try_plant()).is_true()
	var bump: Node = tile.get_node("SeedBump")
	assert_bool(bump.visible).is_true()
	assert_int(tile.get_state()).is_equal(_SoilTileScript.State.PLANTED)
