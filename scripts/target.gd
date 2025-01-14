extends Node3D

@onready var area := $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.area_entered.connect(on_hit)

func on_hit(_area: Area3D) -> void: 
	queue_free()
