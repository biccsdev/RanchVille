@tool
extends EditorPlugin

const _DEBUG := "debug_options"


func _enter_tree() -> void:
	var settings := EditorInterface.get_editor_settings()
	settings.set_project_metadata(_DEBUG, "run_file_server", false)
	settings.set_project_metadata(_DEBUG, "run_deploy_remote_debug", true)
	settings.set_project_metadata(_DEBUG, "run_reload_scripts", true)
	settings.set_project_metadata(_DEBUG, "run_live_debug", true)
	settings.set_project_metadata(_DEBUG, "run_debug_keepopen", true)
	_enable_external_script_reload(settings)
	add_tool_menu_item("RanchVille: Quest live reload help", _show_help)
	add_tool_menu_item("RanchVille: Clear inspector filter", _clear_inspector_filter)
	call_deferred("_clear_inspector_filter")


func _exit_tree() -> void:
	remove_tool_menu_item("RanchVille: Quest live reload help")
	remove_tool_menu_item("RanchVille: Clear inspector filter")


func _clear_inspector_filter() -> void:
	var inspector := EditorInterface.get_inspector()
	if inspector == null:
		return
	var dock: Node = inspector.get_parent()
	while dock != null and dock.name != "Inspector":
		if dock.get_parent() == EditorInterface.get_base_control():
			break
		dock = dock.get_parent()
	if dock != null:
		_wipe_filter_line_edits(dock)
	_wipe_filter_line_edits(inspector)


func _wipe_filter_line_edits(n: Node) -> void:
	if n is LineEdit:
		var le := n as LineEdit
		var ph := le.placeholder_text.to_lower()
		var txt := le.text.to_lower()
		if ph.contains("filter") or txt == "off" or txt == "offset" or txt.begins_with("off"):
			le.clear()
			le.text_changed.emit("")
	for child: Node in n.get_children():
		_wipe_filter_line_edits(child)


func _enable_external_script_reload(settings: EditorSettings) -> void:
	var keys: PackedStringArray = [
		"text_editor/behavior/files/auto_reload_scripts_on_external_change",
		"text_editor/behavior/files/auto_reload_and_parse_scripts_on_save",
	]
	for key: String in keys:
		if settings.has_setting(key):
			settings.set_setting(key, true)


func _show_help() -> void:
	print("RanchVille live reload:")
	print("1. Connect Quest 3 with USB debugging.")
	print("2. Confirm Debug menu: Remote Debug, Sync Scripts, Sync Scenes.")
	print("   Leave Small Deploy OFF. It breaks the Quest scene load.")
	print("3. Press the Android deploy button in the editor.")
	print("4. Keep the editor open. Save a script to push it to the headset.")
	print("5. New files, project.godot, or export changes still need a new deploy.")
