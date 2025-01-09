class_name Projectile
extends CharacterBody3D

const DEFAULT_SPEED := 20.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#position += direction.normalized() * get_speed() * delta
	velocity = transform.basis.z * get_speed()
	var collision := move_and_collide(velocity * delta)
	if (collision != null):
		on_collision(collision)

# subclasses can overwrite if they want a different projectile speed
func get_speed() -> float:
	return DEFAULT_SPEED
	
func on_collision(collision: KinematicCollision3D) -> void:
	queue_free()
	
