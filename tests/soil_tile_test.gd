class_name SoilTileTest
extends GdUnitTestSuite

const _SoilTileScript := preload("res://scripts/farm/soil_tile.gd")
const _SOIL_TILE_SCRIPT := "res://scripts/farm/soil_tile.gd"


func _make_tile() -> RefCounted:
	return _SoilTileScript.new()


func _connect_state_changes(tile: RefCounted) -> Array:
	var changes: Array = []
	tile.state_changed.connect(
		func(from_state: int, to_state: int) -> void:
			changes.append({"from": from_state, "to": to_state})
	)
	return changes


func test_new_tile_starts_empty() -> void:
	var tile := _make_tile()
	assert_int(tile.state).is_equal(_SoilTileScript.State.EMPTY)


func test_till_from_empty_succeeds() -> void:
	var tile := _make_tile()
	assert_bool(tile.till()).is_true()
	assert_int(tile.state).is_equal(_SoilTileScript.State.TILLED)


func test_plant_from_tilled_succeeds() -> void:
	var tile := _make_tile()
	tile.till()
	assert_bool(tile.plant()).is_true()
	assert_int(tile.state).is_equal(_SoilTileScript.State.PLANTED)


func test_full_legal_sequence() -> void:
	var tile := _make_tile()
	assert_bool(tile.till()).is_true()
	assert_bool(tile.plant()).is_true()
	assert_int(tile.state).is_equal(_SoilTileScript.State.PLANTED)


func test_plant_from_empty_fails_and_stays_empty() -> void:
	var tile := _make_tile()
	assert_bool(tile.plant()).is_false()
	assert_int(tile.state).is_equal(_SoilTileScript.State.EMPTY)


func test_till_from_tilled_fails_and_stays_tilled() -> void:
	var tile := _make_tile()
	tile.till()
	assert_bool(tile.till()).is_false()
	assert_int(tile.state).is_equal(_SoilTileScript.State.TILLED)


func test_till_from_planted_fails() -> void:
	var tile := _make_tile()
	tile.till()
	tile.plant()
	assert_bool(tile.till()).is_false()
	assert_int(tile.state).is_equal(_SoilTileScript.State.PLANTED)


func test_plant_from_planted_fails() -> void:
	var tile := _make_tile()
	tile.till()
	tile.plant()
	assert_bool(tile.plant()).is_false()
	assert_int(tile.state).is_equal(_SoilTileScript.State.PLANTED)


func test_state_changed_on_legal_transitions_only() -> void:
	var tile := _make_tile()
	var changes := _connect_state_changes(tile)
	assert_bool(tile.till()).is_true()
	assert_bool(tile.plant()).is_true()
	assert_int(changes.size()).is_equal(2)
	assert_int(changes[0]["from"]).is_equal(_SoilTileScript.State.EMPTY)
	assert_int(changes[0]["to"]).is_equal(_SoilTileScript.State.TILLED)
	assert_int(changes[1]["from"]).is_equal(_SoilTileScript.State.TILLED)
	assert_int(changes[1]["to"]).is_equal(_SoilTileScript.State.PLANTED)


func test_state_changed_not_emitted_on_illegal_transition() -> void:
	var tile := _make_tile()
	var changes := _connect_state_changes(tile)
	assert_bool(tile.plant()).is_false()
	assert_bool(tile.till()).is_true()
	assert_bool(tile.till()).is_false()
	assert_int(changes.size()).is_equal(1)


func test_soil_tile_script_does_not_reference_openxr() -> void:
	var text := FileAccess.get_file_as_string(_SOIL_TILE_SCRIPT)
	assert_str(text).contains("class_name SoilTile")
	assert_bool(text.contains("OpenXR")).is_false()
	assert_bool(text.contains("XRHand")).is_false()
