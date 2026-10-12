extends Node3D


func _ready() -> void:
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface == null or not xr_interface.is_initialized():
		push_warning(
			"OpenXR not initialized; skipping XR viewport (expected in headless)."
		)
		return

	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	get_viewport().use_xr = true
	_enable_passthrough(xr_interface)


func _enable_passthrough(xr_interface: XRInterface) -> void:
	var world_environment: WorldEnvironment = $WorldEnvironment
	var environment: Environment = world_environment.environment
	var viewport: Viewport = get_viewport()
	var modes: Array = xr_interface.get_supported_environment_blend_modes()

	if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
		xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
		viewport.transparent_bg = true
	elif XRInterface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
		xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ADDITIVE
		viewport.transparent_bg = false
	else:
		push_warning("Passthrough not supported; no alpha or additive blend mode.")
		return

	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.0, 0.0, 0.0, 0.0)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
