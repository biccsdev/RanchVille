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


func test_xr_empty_has_transparent_environment_and_no_floor() -> void:
	var packed: PackedScene = load(_MAIN_SCENE) as PackedScene
	var root: Node = auto_free(packed.instantiate())
	assert_bool(root.has_node("Floor")).is_false()
	var world_env: WorldEnvironment = root.get_node("WorldEnvironment") as WorldEnvironment
	assert_object(world_env).is_not_null()
	var env: Environment = world_env.environment
	assert_object(env).is_not_null()
	assert_int(env.background_mode).is_equal(Environment.BG_COLOR)
	assert_float(env.background_color.a).is_equal(0.0)


func test_project_enables_meta_passthrough_and_alpha_blend() -> void:
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains("openxr/extensions/meta/passthrough=true")
	assert_str(text).contains("openxr/environment_blend_mode=2")


func test_bootstrap_enables_alpha_blend_passthrough() -> void:
	assert_file(_BOOTSTRAP_SCRIPT).is_file()
	var text := FileAccess.get_file_as_string(_BOOTSTRAP_SCRIPT)
	assert_str(text).contains("XR_ENV_BLEND_MODE_ALPHA_BLEND")
	assert_str(text).contains("transparent_bg")
	assert_str(text).contains("session_begun")


func test_xr_empty_has_farm_root_and_scene_manager() -> void:
	var packed: PackedScene = load(_MAIN_SCENE) as PackedScene
	var root: Node = auto_free(packed.instantiate())
	var farm_root: Node3D = root.get_node("FarmRoot") as Node3D
	assert_object(farm_root).is_not_null()
	assert_bool(farm_root.has_node("Marker")).is_true()
	var origin: XROrigin3D = root.get_node("XROrigin3D") as XROrigin3D
	assert_bool(origin.has_node("OpenXRFbSceneManager")).is_true()
	assert_bool(origin.has_node("RightHand")).is_true()
	assert_bool(root.has_node("TableAnchor")).is_true()


func test_project_enables_meta_scene_api() -> void:
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains("openxr/extensions/meta/scene_api=true")
	assert_str(text).contains("openxr/extensions/meta/anchor_api=true")
