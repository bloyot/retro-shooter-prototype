class_name WithinShootingRange extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor is Enemy:
		if actor.enemy_resource.type == EnemyResource.TYPE.RANGED:
			return SUCCESS if actor.player.global_position.distance_to(actor.global_position) < actor.enemy_resource.shooting_range else FAILURE
	return FAILURE
