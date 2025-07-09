class_name WithinAggroRangeCondition extends ConditionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if actor is Enemy:		
		if actor.player.global_position.distance_to(actor.global_position) < actor.enemy_resource.aggro_range:		
			return SUCCESS
		else:
			return FAILURE
	return FAILURE
