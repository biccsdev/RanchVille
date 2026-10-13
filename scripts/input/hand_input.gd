extends Node

signal pinch_started
signal pinch_ended
signal poke


func emit_pinch_started() -> void:
	pinch_started.emit()


func emit_pinch_ended() -> void:
	pinch_ended.emit()


func emit_poke() -> void:
	poke.emit()
