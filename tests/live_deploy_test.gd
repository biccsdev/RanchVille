class_name LiveDeployTest
extends GdUnitTestSuite

const _PLUGIN_CFG := "res://addons/ranchville_live_deploy/plugin.cfg"
const _PLUGIN_SCRIPT := "res://addons/ranchville_live_deploy/plugin.gd"
const _LIVE_SCRIPT := "res://run_quest_live.sh"
const _PROJECT := "res://project.godot"


func test_live_deploy_plugin_is_registered() -> void:
	assert_file(_PLUGIN_CFG).is_file()
	assert_file(_PLUGIN_SCRIPT).is_file()
	var text := FileAccess.get_file_as_string(_PROJECT)
	assert_str(text).contains("res://addons/ranchville_live_deploy/plugin.cfg")


func test_live_deploy_script_uses_adb_reverse() -> void:
	assert_file(_LIVE_SCRIPT).is_file()
	var text := FileAccess.get_file_as_string(_LIVE_SCRIPT)
	assert_str(text).contains("adb")
	assert_str(text).contains("reverse")
	assert_str(text).contains("6007")
