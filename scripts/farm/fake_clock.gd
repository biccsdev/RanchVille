class_name FakeClock
extends RefCounted

var elapsed_sec: float = 0.0


func advance(delta_sec: float) -> void:
	if delta_sec > 0.0:
		elapsed_sec += delta_sec
