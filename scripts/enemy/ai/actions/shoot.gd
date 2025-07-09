class_name Shoot extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	# cast it first for convenience
	if actor is Enemy:
		var player_position = actor.player.global_position		
		if !actor.is_facing_player():
			actor.rotate_towards(player_position)		
		elif actor.can_shoot():			
			actor.shoot(player_position)
		
	return RUNNING
