class_name MoveTowardsPlayer extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	# cast it first for convenience
	if actor is Enemy:
		var target_position = actor.global_position.move_toward(actor.player.global_position, actor.enemy_resource.move_speed)
		actor.target_position = Vector3(target_position.x, actor.global_position.y, target_position.z)
	
	# TODO possibly need to check out of range here and return failure? not sure if condition handles that
	return RUNNING
