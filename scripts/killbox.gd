@tool
extends Area3D

@export var size: Vector3
@onready var collision_shape: CollisionShape3D = %CollisionShape3D
		
func _process(delta: float) -> void:	
	collision_shape.shape.size = size				
