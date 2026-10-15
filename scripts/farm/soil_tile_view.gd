class_name SoilTileView
extends Node3D

const _SoilTile := preload("res://scripts/farm/soil_tile.gd")

const COLOR_GRASS := Color("#6F9148")
const COLOR_SOIL := Color("#5C3D2E")
const COLOR_SEED_BUMP := Color("#F3E4C4")

@export var start_tilled := false

var tile: RefCounted

var _pad: MeshInstance3D
var _bump: MeshInstance3D


func _ready() -> void:
	add_to_group(&"soil_tile")
	tile = _SoilTile.new()
	_pad = get_node_or_null("Pad") as MeshInstance3D
	_bump = get_node_or_null("SeedBump") as MeshInstance3D
	if start_tilled:
		tile.till()
	_refresh_visual()
	if tile.has_signal("state_changed"):
		tile.state_changed.connect(_on_tile_state_changed)


func get_state() -> int:
	return tile.state


func try_plant() -> bool:
	if not tile.plant():
		return false
	_refresh_visual()
	return true


func _on_tile_state_changed(_from_state: int, _to_state: int) -> void:
	_refresh_visual()


func _refresh_visual() -> void:
	if _pad == null:
		return
	var mat := _pad.material_override as StandardMaterial3D
	if mat == null:
		mat = StandardMaterial3D.new()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_pad.material_override = mat
	match tile.state:
		_SoilTile.State.EMPTY:
			mat.albedo_color = COLOR_GRASS
			if _bump != null:
				_bump.visible = false
		_SoilTile.State.TILLED:
			mat.albedo_color = COLOR_SOIL
			if _bump != null:
				_bump.visible = false
		_SoilTile.State.PLANTED:
			mat.albedo_color = COLOR_SOIL
			if _bump != null:
				_bump.visible = true
