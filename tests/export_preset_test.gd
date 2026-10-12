class_name ExportPresetTest
extends GdUnitTestSuite

const _PRESET_PATH := "res://export_presets.cfg"

const _REQUIRED_SNIPPETS: PackedStringArray = [
	'name="Quest 3"',
	'name="Quest 3 AAB"',
	"gradle_build/use_gradle_build=true",
	"architectures/arm64-v8a=true",
	"xr_features/enable_meta_plugin=true",
	"meta_xr_features/quest_3_support=true",
	"meta_xr_features/hand_tracking=1",
	"meta_xr_features/passthrough=2",
	'package/unique_name="com.biccs.ranchville"',
	"gradle_build/export_format=0",
	"gradle_build/export_format=1",
]


func test_export_presets_define_quest_3_with_meta_xr_features() -> void:
	assert_file(_PRESET_PATH).is_file()
	var text := FileAccess.get_file_as_string(_PRESET_PATH)
	assert_str(text).is_not_empty()
	for snippet: String in _REQUIRED_SNIPPETS:
		assert_bool(text.contains(snippet)).override_failure_message(
			"export_presets.cfg missing: %s" % snippet
		).is_true()
