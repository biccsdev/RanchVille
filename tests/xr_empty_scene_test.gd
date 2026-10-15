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
	var marker: MeshInstance3D = farm_root.get_node("Marker") as MeshInstance3D
	var box: BoxMesh = marker.mesh as BoxMesh
	assert_object(box).is_not_null()
	assert_vector(box.size).is_equal(Vector3(0.075, 0.075, 0.075))
	var origin: XROrigin3D = root.get_node("XROrigin3D") as XROrigin3D
	assert_bool(origin.has_node("OpenXRFbSceneManager")).is_true()
	assert_bool(origin.has_node("RightHand")).is_true()
	assert_bool(root.has_node("TableAnchor")).is_true()


func test_project_enables_meta_scene_api() -> void:
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains("openxr/extensions/meta/scene_api=true")
	assert_str(text).contains("openxr/extensions/meta/anchor_api=true")


func test_project_registers_openxr_action_map() -> void:
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains('openxr/action_map="res://openxr_action_map.tres"')
	assert_file("res://openxr_action_map.tres").is_file()


func test_project_enables_openxr_hand_interaction() -> void:
	var text := FileAccess.get_file_as_string(_PROJECT_SETTINGS)
	assert_str(text).contains("openxr/extensions/hand_tracking=true")
	assert_str(text).contains("openxr/extensions/hand_tracking_unobstructed_data_source=true")
	assert_str(text).contains("openxr/extensions/hand_tracking_controller_data_source=true")
	assert_str(text).contains("openxr/extensions/hand_interaction_profile=true")
	var action_map := FileAccess.get_file_as_string("res://openxr_action_map.tres")
	assert_str(action_map).contains("/interaction_profiles/ext/hand_interaction_ext")
	assert_str(action_map).contains("/interaction_profiles/microsoft/hand_interaction")


func test_xr_empty_has_grab_system_and_hand_input_xr() -> void:
	var packed: PackedScene = load(_MAIN_SCENE) as PackedScene
	var root: Node = auto_free(packed.instantiate())
	assert_bool(root.has_node("GrabSystem")).is_true()
	assert_bool(root.has_node("HandInputXr")).is_true()
	var farm_root: Node3D = root.get_node("FarmRoot") as Node3D
	assert_bool(farm_root.has_node("DebugGrabbable")).is_false()
	assert_bool(farm_root.has_node("DebugGrabbable2")).is_false()
	var xr_script: Script = root.get_node("HandInputXr").get_script()
	assert_str(xr_script.source_code).contains("../XROrigin3D/RightHand")
	assert_bool(xr_script.source_code.contains("PinchDetector")).is_false()
	assert_bool(xr_script.source_code.contains("HAND_JOINT")).is_false()
	var origin: XROrigin3D = root.get_node("XROrigin3D") as XROrigin3D
	var left_tracked: XRNode3D = origin.get_node("LeftHandTracked") as XRNode3D
	var right_tracked: XRNode3D = origin.get_node("RightHandTracked") as XRNode3D
	assert_object(left_tracked).is_not_null()
	assert_object(right_tracked).is_not_null()
	assert_str(String(left_tracked.tracker)).is_equal("/user/hand_tracker/left")
	assert_str(String(right_tracked.tracker)).is_equal("/user/hand_tracker/right")
	assert_str(String(left_tracked.pose)).is_equal("default")
	var point_script: Script = root.get_node("XROrigin3D/RightHand/InteractionPoint").get_script()
	assert_str(point_script.source_code).contains("HandDetectMarker")
	assert_str(point_script.source_code).contains("RightHandTracked")
	assert_bool(point_script.source_code.contains("HAND_JOINT")).is_false()


func test_xr_empty_has_planting_and_soil_tiles() -> void:
	var packed: PackedScene = load(_MAIN_SCENE) as PackedScene
	var root: Node = auto_free(packed.instantiate())
	assert_bool(root.has_node("PlantingSystem")).is_true()
	var farm_root: Node3D = root.get_node("FarmRoot") as Node3D
	assert_bool(farm_root.has_node("SoilTileEmpty")).is_true()
	assert_bool(farm_root.has_node("SoilTileTilled")).is_true()
	assert_bool(farm_root.has_node("SeedItem")).is_true()
	assert_bool(farm_root.has_node("SeedItem2")).is_true()
	var marker: MeshInstance3D = farm_root.get_node("Marker") as MeshInstance3D
	assert_object(marker).is_not_null()
	var seed: Node = farm_root.get_node("SeedItem")
	assert_str(seed.scene_file_path).is_equal("res://scenes/seed_item.tscn")
	var plant_range_m := 0.08
	var empty: Node3D = farm_root.get_node("SoilTileEmpty") as Node3D
	var tilled: Node3D = farm_root.get_node("SoilTileTilled") as Node3D
	var seed2: Node3D = farm_root.get_node("SeedItem2") as Node3D
	assert_float((seed as Node3D).position.distance_to(empty.position)).is_greater(plant_range_m)
	assert_float(seed2.position.distance_to(tilled.position)).is_greater(plant_range_m)


func test_debug_grabbable_uses_grabbable_script() -> void:
	var packed: PackedScene = load("res://scenes/debug_grabbable.tscn") as PackedScene
	var prop: Node = auto_free(packed.instantiate())
	var script: Script = prop.get_script()
	assert_object(script).is_not_null()
	assert_str(script.resource_path).is_equal("res://scripts/grab/grabbable.gd")
