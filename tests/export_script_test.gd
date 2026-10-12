class_name ExportScriptTest
extends GdUnitTestSuite

const _SCRIPT_RES := "res://export_quest.sh"


func _script_path() -> String:
	return ProjectSettings.globalize_path(_SCRIPT_RES)


func _run_export_script(args: PackedStringArray) -> int:
	var output: Array = []
	return OS.execute(_script_path(), args, output, true)


func test_export_quest_script_exists() -> void:
	assert_file(_SCRIPT_RES).is_file()


func test_export_quest_check_succeeds() -> void:
	var exit_code := _run_export_script(PackedStringArray(["--check"]))
	assert_int(exit_code).is_equal(0)


func test_export_quest_rejects_unknown_format() -> void:
	var exit_code := _run_export_script(
		PackedStringArray(["--format", "invalid", "--check"])
	)
	assert_int(exit_code).is_not_equal(0)
