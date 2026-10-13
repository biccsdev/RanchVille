class_name CropData
extends Resource

@export var crop_id: StringName = &""
@export var stages: Array = []


func is_stage_data_valid() -> bool:
	if stages.size() < 3:
		return false
	var harvest_ready_count := 0
	for i in stages.size():
		var stage: Resource = stages[i]
		if stage == null:
			return false
		if stage.duration_sec <= 0.0:
			return false
		if stage.harvest_ready:
			harvest_ready_count += 1
			if i != stages.size() - 1:
				return false
	if harvest_ready_count != 1:
		return false
	return stages[stages.size() - 1].harvest_ready


func total_growth_duration_sec() -> float:
	var total := 0.0
	for stage in stages:
		if stage != null:
			total += stage.duration_sec
	return total
