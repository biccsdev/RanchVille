class_name XrEmptySceneTest
extends GdUnitTestSuite

const _MAIN_SCENE := "res://scenes/xr_empty.tscn"
const _BOOTSTRAP_SCRIPT := "res://scripts/xr_bootstrap.gd"
const _PROJECT_SETTINGS := "res://project.godot"


func test_project_main_scene_points_to_xr_empty() -> void:
	assert_file(_PROJECT_SETTINGS).is_file()
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains('run/main_scene="res://scenes/xr_empty.tscn"')


func test_xr_empty_scene_loads_with_origin_and_camera() -> void:
	assert_file(_MAIN_SCENE).is_file()
	var packed: PackedScene = load(_MAIN_SCENE) as PackedScene
	assert_object(packed).is_not_null()
	var root: Node = auto_free(packed.instantiate())
	var origin: XROrigin3D = root.get_node("XROrigin3D") as XROrigin3D
	assert_object(origin).is_not_null()
	var camera: XRCamera3D = origin.get_node("XRCamera3D") as XRCamera3D
	assert_object(camera).is_not_null()


func test_xr_empty_root_uses_bootstrap_script() -> void:
	var packed: PackedScene = load(_MAIN_SCENE) as PackedScene
	var root: Node = auto_free(packed.instantiate())
	var script: Script = root.get_script()
	assert_object(script).is_not_null()
	assert_str(script.resource_path).is_equal(_BOOTSTRAP_SCRIPT)
