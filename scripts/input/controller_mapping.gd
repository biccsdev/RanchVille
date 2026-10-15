class_name ControllerMapping
extends RefCounted

## Analog trigger/grip above this value counts as pinched (Quest Touch fallback).
const ANALOG_PINCH_THRESHOLD := 0.5


static func is_pinch_button(button_name: StringName) -> bool:
	return button_name == &"trigger_click" or button_name == &"grip_click"


static func is_poke_button(button_name: StringName) -> bool:
	return button_name == &"ax_button"


static func is_pinching(
	click_trigger: bool,
	click_grip: bool,
	trigger: float,
	grip: float,
) -> bool:
	if click_trigger or click_grip:
		return true
	if trigger > ANALOG_PINCH_THRESHOLD:
		return true
	if grip > ANALOG_PINCH_THRESHOLD:
		return true
	return false
