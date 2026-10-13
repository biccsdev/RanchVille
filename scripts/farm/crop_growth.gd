class_name CropGrowth
extends RefCounted

signal stage_changed(from_index: int, to_index: int)

var data: Resource
var elapsed_sec: float = 0.0
var watered: bool = false

var _stage_index: int = 0


func water() -> void:
	watered = true


func advance(delta_sec: float) -> void:
	if not watered or delta_sec <= 0.0 or data == null:
		return
	var from_index := _stage_index
	elapsed_sec += delta_sec
	_stage_index = _compute_stage_index(elapsed_sec)
	if _stage_index != from_index:
		stage_changed.emit(from_index, _stage_index)


func current_stage_index() -> int:
	return _stage_index


func current_stage() -> Resource:
	if data == null or data.stages.is_empty():
		return null
	return data.stages[_stage_index]


func is_harvest_ready() -> bool:
	if data == null or not data.is_stage_data_valid():
		return false
	var last_index: int = data.stages.size() - 1
	if _stage_index != last_index:
		return false
	return elapsed_sec >= data.total_growth_duration_sec()


func _compute_stage_index(time_sec: float) -> int:
	if data == null or data.stages.is_empty():
		return 0
	var cumulative := 0.0
	for i in data.stages.size():
		cumulative += data.stages[i].duration_sec
		if time_sec < cumulative:
			return i
	return data.stages.size() - 1
