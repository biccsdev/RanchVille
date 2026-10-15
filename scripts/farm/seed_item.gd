class_name SeedItem
extends Grabbable

@export var crop_id: StringName = &"wheat"


func _ready() -> void:
	super._ready()
	add_to_group(&"seed")
